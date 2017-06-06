//
//  AppCommon.h
//  CQArchitecture
//
//  Created by KevinCao on 2016/11/30.
//  Copyright © 2016年 caoqun. All rights reserved.
//

#import <UIKit/UIKit.h>

UIWindow *mainWindow();

UIViewController *topMostViewController();

@interface AppCommon : NSObject

////隐藏导航栏
+ (void)showNavigationBar:(BOOL)isShow;

////统一调用此方法来push
+ (void)pushViewController:(UIViewController*)vc animated:(BOOL)animate;
+ (void)presentViewController:(UIViewController*)vc animated:(BOOL)animated;
+ (void)dismissViewControllerAnimated:(BOOL)animated;
+ (void)pushWithVCClass:(Class)vcClass properties:(NSDictionary*)properties;
+ (void)pushWithVCClassName:(NSString*)className properties:(NSDictionary*)properties;
+ (void)pushWithVCClass:(Class)vcClass;
+ (void)pushWithVCClassName:(NSString*)className;
+ (void)pushWithVCClassName:(NSString*)className needLogin:(BOOL)isNeedLogin;
+ (void)popViewControllerAnimated:(BOOL)animated;
+ (void)popToRootViewControllerAnimated:(BOOL)animated;
+ (UINavigationController *)rootNavigationController;
+ (void)removeVC:(UIViewController *)thevc;
+ (void)removeFromerVC;
+ (void)setDeviceToken:(NSString*)deviceToken;
+ (NSString*)deviceToken;

@end
