//
//  TAddLocationDataViewController.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLocationModel.h"
#import "TBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TAddLocationDataCompletionBlock)(TLocationModel *model);

@interface TAddLocationDataViewController : TBaseViewController

@property (nonatomic, copy) TAddLocationDataCompletionBlock addLocationBlock;

@end

NS_ASSUME_NONNULL_END
