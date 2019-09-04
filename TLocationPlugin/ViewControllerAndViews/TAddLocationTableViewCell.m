//
//  TAddLocationTableViewCell.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//
//  Copyright (C) 2011-2019 ShenZhen iBOXCHAIN Information Technology Co.,Ltd. 
//                             All rights reserved.
//
//      This  software  is  the  confidential  and  proprietary  information  of
//  iBOXCHAIN  Company  of  China. ("Confidential Information"). You  shall  not
//  disclose such Confidential Information and shall use it only in accordance
//  with the terms of the contract agreement you entered into with iBOXCHAIN inc.
//

#import "TAddLocationTableViewCell.h"
#import "UIImage+TLocation.h"

@implementation TAddLocationTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {}
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        self.imageView.image = [UIImage t_imageNamed:@"checked"];
    } else {
        self.imageView.image = [UIImage t_imageNamed:@"none"];
    }
}

@end
