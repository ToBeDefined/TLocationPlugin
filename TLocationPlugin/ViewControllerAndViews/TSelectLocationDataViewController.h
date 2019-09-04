//
//  TSelectLocationDataViewController.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBaseViewController.h"
#import "TLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TSelectLocationDataCompletionBlock)(TLocationModel *model);

@interface TSelectLocationDataViewController : TBaseViewController

@property (nonatomic, copy) TSelectLocationDataCompletionBlock selectLocationBlock;

@end

NS_ASSUME_NONNULL_END
