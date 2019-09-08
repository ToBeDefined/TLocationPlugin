//
//  TLocationTableViewCell.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLocationTableViewCell : UITableViewCell

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) TLocationModel *model;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

//- (void)setSelectedCell:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
