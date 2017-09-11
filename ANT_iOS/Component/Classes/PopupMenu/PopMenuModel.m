//
//  PopMenuModel.m
//  ANT_NH
//
//  Created by 宇玄丶 on 2017/5/4.
//  Copyright © 2017年 qianmo. All rights reserved.
//

#import "PopMenuButton.h"
#import "PopMenuModel.h"

@implementation PopMenuModel

+ (instancetype __nonnull)allocPopMenuModelWithImageNameString:(NSString* __nonnull)imageNameString

                                                 AtTitleString:(NSString* __nonnull)titleString

                                                   AtTextColor:(UIColor* __nonnull)textColor

                                              AtTransitionType:(PopMenuTransitionType)transitionType

                                    AtTransitionRenderingColor:(UIColor* __nullable)transitionRenderingColor
{
    PopMenuModel* model = [[PopMenuModel alloc] init];
    model.imageNameString = imageNameString;
    model.titleString = titleString;
    model.transitionType = transitionType;
    model.transitionRenderingColor = transitionRenderingColor;
    model.textColor = textColor;
    [model _obj];
    return model;
}

- (instancetype __nonnull)init
{
    self = [super init];
    if (self) {
        self.transitionType = PopMenuTransitionTypeSystemApi;
    }
    return self;
}

- (void)setAutomaticIdentificationColor:(BOOL)automaticIdentificationColor
{
    _automaticIdentificationColor = automaticIdentificationColor;
    [_customView setValue:self forKey:@"model"];
}

- (void)_obj
{
    PopMenuButton* button = [[PopMenuButton alloc] init];
    button.model = self;
    CGFloat buttonViewWidth = MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) / 3;
    buttonViewWidth = buttonViewWidth - 10;
    button.bounds = CGRectMake(0, 0, buttonViewWidth, buttonViewWidth);
    button.layer.masksToBounds = true;
    
    _customView = button;
}

@end
