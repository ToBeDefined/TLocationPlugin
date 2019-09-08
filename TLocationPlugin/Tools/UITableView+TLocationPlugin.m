//
//  UITableView+TLocationPlugin.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/8.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "UITableView+TLocationPlugin.h"
#import "TSafeRuntimeCFunc.h"
#import <objc/runtime.h>

@implementation UITableView (TLocationPlugin)

+ (void)load {
    t_exchange_instance_method(self, @selector(setEditing:), @selector(_t_setEditing:));
    t_exchange_instance_method(self, @selector(setEditing:animated:), @selector(_t_setEditing:animated:));
}

- (BOOL)isBeginingEdit {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setBeginingEdit:(BOOL)beginingEdit {
    objc_setAssociatedObject(self, @selector(isBeginingEdit), @(beginingEdit), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isEndingEdit {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setEndingEdit:(BOOL)endingEdit {
    objc_setAssociatedObject(self, @selector(isEndingEdit), @(endingEdit), OBJC_ASSOCIATION_RETAIN);
}

- (void)_t_setEditing:(BOOL)editing {
    self.beginingEdit = editing;
    self.endingEdit = !editing;
    [self _t_setEditing:editing];
    self.beginingEdit = NO;
    self.endingEdit = NO;
}

- (void)_t_setEditing:(BOOL)editing animated:(BOOL)animated {
    self.beginingEdit = editing;
    self.endingEdit = !editing;
    [self _t_setEditing:editing animated:animated];
    self.beginingEdit = NO;
    self.endingEdit = NO;
}

@end
