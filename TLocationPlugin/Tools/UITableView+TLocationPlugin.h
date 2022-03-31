//
//  UITableView+TLocationPlugin.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/8.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (TLocationPlugin)

@property (nonatomic, assign, getter=isEditBegining) BOOL editBegining;
@property (nonatomic, assign, getter=isEditEnding) BOOL editEnding;

@end

NS_ASSUME_NONNULL_END
