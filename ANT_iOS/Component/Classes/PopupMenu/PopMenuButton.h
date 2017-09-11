//
//  PopMenuButton.h
//  ANT_NH
//
//  Created by 宇玄丶 on 2017/5/4.
//  Copyright © 2017年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyPopMenuView.h"

@class PopMenuButton,PopMenuModel;
typedef void (^completionAnimation)( PopMenuButton * _Nonnull );

@interface PopMenuButton : UIButton <CAAnimationDelegate>

@property (nonatomic, nonnull, strong) PopMenuModel* model;
@property (nonatomic, nonnull, strong) completionAnimation block;

- (instancetype __nonnull)init;
- (void)selectdAnimation;
- (void)cancelAnimation;

@end
