//
//  AdvertScrollView.h
//  ANT_NH
//
//  Created by 宇玄丶 on 2017/5/15.
//  Copyright © 2017年 qianmo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdvertScrollView;

typedef enum : NSUInteger {
    AdvertScrollViewStyleNormal,
    AdvertScrollViewStyleTwo,
} AdvertScrollViewStyle;

/** delegate */
@protocol AdvertScrollViewDelegate <NSObject>
- (void)advertScrollView:(AdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface AdvertScrollView : UIView
/** delegate_SG */
@property (nonatomic, weak) id<AdvertScrollViewDelegate> delegateAdvertScrollView;
/** AdvertScrollViewStyle */
@property (nonatomic, assign) AdvertScrollViewStyle advertScrollViewStyle;
/** 设置滚动时间间隔(默认 3s) */
@property (nonatomic, assign) CGFloat scrollTimeInterval;
/** 左边提示图片 */
@property (nonatomic, strong) NSString *leftImageString;
/** 右边标题数组，当 SGAdvertScrollViewStyle 为 SGAdvertScrollViewStyleTwo, 此标题数组为 topLabel 标题数组 */
@property (nonatomic, strong) NSArray *titles;
/** 左边标志图片数组，只有 SGAdvertScrollViewStyleTwo 样式时，才有效 */
@property (nonatomic, strong) NSArray *signImages;
/** 左边底部标题数组，只有 SGAdvertScrollViewStyleTwo 样式时，才有效 */
@property (nonatomic, strong) NSArray *bottomTitles;
/** 标题字体大小(默认 12), 当 SGAdvertScrollViewStyle 为 SGAdvertScrollViewStyleTwo, 此 titleFont 为 topLabel 文字颜色 */
@property (nonatomic, strong) UIFont *titleFont;
/** 标题字体颜色(默认 黑色), 当 SGAdvertScrollViewStyle 为 SGAdvertScrollViewStyleTwo, 此 titleColor 为 topLabel 文字颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 标题字体大小(默认 12), 只有 SGAdvertScrollViewStyleTwo 样式时，才有效 */
@property (nonatomic, strong) UIFont *bottomTitleFont;
/** 标题字体颜色(默认 黑色), 只有 SGAdvertScrollViewStyleTwo 样式时，才有效 */
@property (nonatomic, strong) UIColor *bottomTitleColor;
/** 是否显示分割线(默认为 YES) */
@property (nonatomic, assign) BOOL isShowSeparator;
/** 分割线颜色(默认 浅灰色) */
@property (nonatomic, strong) UIColor *separatorColor;

@end
