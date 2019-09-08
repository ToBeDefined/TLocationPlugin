//
//  TLocationTableViewCell.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TLocationTableViewCell.h"
#import "UIImage+TLocationPlugin.h"
#import "UITableView+TLocationPlugin.h"

@implementation TLocationTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.selectedBackgroundView = [[UIView alloc] init];
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = UIColor.darkGrayColor;
        self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.tableView.isEditing || self.tableView.isBeginingEdit) {
        return;
    }
}

- (void)setModel:(TLocationModel *)model {
    self->_model = model;
    
    if (model.isSelect) {
        self.imageView.image = [UIImage t_imageNamed:@"checked_location"];
    } else {
        self.imageView.image = [UIImage t_imageNamed:@"none"];
    }
    self.textLabel.text = model.name;
    self.detailTextLabel.text = model.locationText;
}

///// 添加选择方法为了防止和编辑模式下默认的 select 冲突
//- (void)setSelectedCell:(BOOL)selected {
//    if (selected) {
//        self.imageView.image = [UIImage t_imageNamed:@"checked_location"];
//    } else {
//        self.imageView.image = [UIImage t_imageNamed:@"none"];
//    }
//}

@end
