//
//  TAddLocationTableViewCell.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
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
