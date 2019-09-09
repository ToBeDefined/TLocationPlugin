//
//  NSObject+TLocationPlugin.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NSObject+TLocationPlugin.h"
#import "TSafeRuntimeCFunc.h"
#import "TLocationManager.h"
#import "UIWindow+TLocationPluginToast.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import <mach-o/ldsyms.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <mach-o/nlist.h>

#ifdef __LP64__
typedef struct mach_header_64       ah_mach_header_t;
typedef struct segment_command_64   ah_segment_command_t;
typedef struct section_64           ah_section_t;
typedef struct nlist_64             ah_nlist_t;
typedef uint64_t                    ah_local_addr;
#define AH_LC_SEGMENT_ARCH          LC_SEGMENT_64

#else

typedef struct mach_header          ah_mach_header_t;
typedef struct segment_command      ah_segment_command_t;
typedef struct section              ah_section_t;
typedef struct nlist                ah_nlist_t;
typedef uint32_t                    ah_local_addr;
#define AH_LC_SEGMENT_ARCH          LC_SEGMENT

#endif // __LP64__

@implementation NSObject (TLocationPlugin)

static NSArray<NSString *> *_t_get_mach_o_load_dylibs(uint32_t image_index) {
    NSMutableArray *array = [NSMutableArray array];
    const struct mach_header *header = _dyld_get_image_header(image_index);
    ah_segment_command_t *cur_seg_cmd;
    uintptr_t cur = (uintptr_t)header + sizeof(ah_mach_header_t);
    for (uint i = 0; i < header->ncmds; i++,cur += cur_seg_cmd->cmdsize) {
        cur_seg_cmd = (ah_segment_command_t *)cur;
        if(cur_seg_cmd->cmd == LC_LOAD_DYLIB || cur_seg_cmd->cmd == LC_LOAD_WEAK_DYLIB) {
            struct dylib_command *dylib = (struct dylib_command *)cur_seg_cmd;
            char *name = (char *)((uintptr_t)dylib + dylib->dylib.name.offset);
            NSString *dylibName = [NSString stringWithUTF8String:name];
            [array addObject:dylibName];
        }
    }
    return [array copy];
}

+ (void)load {
    const char *old_location_sel_name = sel_getName(@selector(locationManager:didUpdateToLocation:fromLocation:));
    const char *new_location_sel_name = sel_getName(@selector(locationManager:didUpdateLocations:));
    /// 替换用户实现的代理方法，不替换系统的方法
    // Dl_info info;
    // dladdr(&_mh_execute_header, &info);
    // NSString *exe_path = [NSString stringWithUTF8String:info.dli_fname];
    NSString *exe_path = [NSBundle mainBundle].executablePath;
    NSString *exe_dir = [NSBundle mainBundle].bundlePath;
    NSString *eframework_path = exe_dir;
    NSString *rframework_path = [exe_dir stringByAppendingString:@"/Frameworks"];
    NSArray *array = _t_get_mach_o_load_dylibs(0);
    NSMutableArray<NSString *> *user_code_binary_paths = [NSMutableArray<NSString *> array];
    [user_code_binary_paths addObject:exe_path];
    for (NSString *framework_path in array) {
        // 规避动态库自身
        if ([framework_path rangeOfString:@"TLocationPlugin"].location != NSNotFound) {
            continue;
        }
        // 记录 rpath
        if ([framework_path hasPrefix:@"@rpath"]) {
            NSString *framework_absolute_path = [framework_path stringByReplacingOccurrencesOfString:@"@rpath"
                                                                                          withString:rframework_path];
            [user_code_binary_paths addObject:framework_absolute_path];
        }
        
        // 基本上不会出现 @executable_path
        if ([framework_path hasPrefix:@"@executable_path"]) {
            NSString *framework_absolute_path = [framework_path stringByReplacingOccurrencesOfString:@"@executable_path"
                                                                                          withString:eframework_path];
            [user_code_binary_paths addObject:framework_absolute_path];
        }
    }
    
    unsigned int count;
    const char **classes;
    for (NSString *path in user_code_binary_paths) {
        classes = objc_copyClassNamesForImage([path cStringUsingEncoding:NSUTF8StringEncoding], &count);
        for (int i = 0; i < count; i++) {
            Class class = objc_getClass(classes[i]);
            unsigned int method_list_count;
            Method *methods = class_copyMethodList(class, &method_list_count);
            for (int i = 0; i < method_list_count; i++) {
                const char *selName = sel_getName(method_getName(methods[i]));
                if (strcmp(selName, old_location_sel_name) == 0 ||
                    strcmp(selName, new_location_sel_name) == 0) {
                    [self replaceCLLocationsFunctionToClass:class];
                }
            }
            free(methods);
        }
    }
}

+ (void)replaceCLLocationsFunctionToClass:(Class)cls {
    if ([cls instancesRespondToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
        t_exchange_instance_method(cls,
                                   @selector(locationManager:didUpdateToLocation:fromLocation:),
                                   @selector(__t_locationManager:didUpdateToLocation:fromLocation:));
    }
    
    if ([cls instancesRespondToSelector:@selector(locationManager:didUpdateLocations:)]) {
        t_exchange_instance_method(cls,
                                   @selector(locationManager:didUpdateLocations:),
                                   @selector(__t_locationManager:didUpdateLocations:));
    }
}

- (void)__t_locationManager:(CLLocationManager *)manager
        didUpdateToLocation:(CLLocation *)newLocation
               fromLocation:(CLLocation *)oldLocation API_AVAILABLE(macos(10.6)) {
    BOOL useHook = TLocationManager.shared.usingHookLocation && TLocationManager.shared.hasCachedLocation;
    if (!useHook) {
        if (TLocationManager.shared.usingToast) {
            [UIWindow t_showTostForCLLocation:newLocation];
        }
        [self __t_locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
        return;
    }
    
    /// CLLocation 使用WGS84坐标
    CLLocation *t_newLocation = [[CLLocation alloc] initWithCoordinate:TLocationManager.shared.randomWGS84Coordinate
                                                              altitude:newLocation.altitude
                                                    horizontalAccuracy:newLocation.horizontalAccuracy
                                                      verticalAccuracy:newLocation.verticalAccuracy
                                                                course:newLocation.course
                                                                 speed:newLocation.speed
                                                             timestamp:newLocation.timestamp];
    if (TLocationManager.shared.usingToast) {
        [UIWindow t_showTostForCLLocation:t_newLocation];
    }
    [self __t_locationManager:manager didUpdateToLocation:t_newLocation fromLocation:oldLocation];
}

- (void)__t_locationManager:(CLLocationManager *)manager
         didUpdateLocations:(NSArray<CLLocation *> *)locations {
    BOOL useHook = TLocationManager.shared.usingHookLocation && TLocationManager.shared.hasCachedLocation;
    if (!useHook) {
        if (TLocationManager.shared.usingToast) {
            [UIWindow t_showTostForCLLocations:locations];
        }
        [self __t_locationManager:manager didUpdateLocations:locations];
        return;
    }
    NSMutableArray<CLLocation *> *t_locations = [NSMutableArray<CLLocation *> array];
    for (CLLocation *location in locations) {
        /// CLLocation 使用WGS84坐标
        CLLocation *t_location = [[CLLocation alloc] initWithCoordinate:TLocationManager.shared.randomWGS84Coordinate
                                                               altitude:location.altitude
                                                     horizontalAccuracy:location.horizontalAccuracy
                                                       verticalAccuracy:location.verticalAccuracy
                                                                 course:location.course
                                                                  speed:location.speed
                                                              timestamp:location.timestamp];
        [t_locations addObject:t_location];
    }
    
    if (TLocationManager.shared.usingToast) {
        [UIWindow t_showTostForCLLocations:t_locations];
    }
    [self __t_locationManager:manager didUpdateLocations:t_locations];
}

@end

