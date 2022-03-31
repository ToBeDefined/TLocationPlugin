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

- (BOOL)isEditBegining {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEditBegining:(BOOL)beginingEdit {
    objc_setAssociatedObject(self, @selector(isEditBegining), @(beginingEdit), OBJC_ASSOCIATION_RETAIN);
}


- (BOOL)isEditEnding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEditEnding:(BOOL)endingEdit {
    objc_setAssociatedObject(self, @selector(isEditEnding), @(endingEdit), OBJC_ASSOCIATION_RETAIN);
}

- (void)_t_setEditing:(BOOL)editing {
    self.editBegining = editing;
    self.editEnding = !editing;
    [self _t_setEditing:editing];
    self.editBegining = NO;
    self.editEnding = NO;
}

- (void)_t_setEditing:(BOOL)editing animated:(BOOL)animated {
    self.editBegining = editing;
    self.editEnding = !editing;
    [self _t_setEditing:editing animated:animated];
    self.editBegining = NO;
    self.editEnding = NO;
}

@end
