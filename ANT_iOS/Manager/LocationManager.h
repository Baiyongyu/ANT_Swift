//
//  LocationManager.h
//  anz
//
//  Created by KevinCao on 16/7/9.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>

typedef void (^VoidBlock)();
typedef void (^IdBlock)(id object);

typedef NS_ENUM(NSUInteger, LocationManagerLocationResult) {
    LocationManagerLocationResultDefault,              //默认状态
    LocationManagerLocationResultLocating,             //定位中
    LocationManagerLocationResultSuccess,              //定位成功
    LocationManagerLocationResultFail,                 //定位失败
    LocationManagerLocationResultParamsError,          //调用API的参数错了
    LocationManagerLocationResultTimeout,              //超时
    LocationManagerLocationResultNoNetwork,            //没有网络
    LocationManagerLocationResultNoContent             //API没返回数据或返回数据是错的
};

typedef NS_ENUM(NSUInteger, LocationManagerLocationServiceStatus) {
    LocationManagerLocationServiceStatusDefault,               //默认状态
    LocationManagerLocationServiceStatusOK,                    //定位功能正常
    LocationManagerLocationServiceStatusUnknownError,          //未知错误
    LocationManagerLocationServiceStatusUnAvailable,           //定位功能关掉了
    LocationManagerLocationServiceStatusNoAuthorization,       //定位功能打开，但是用户不允许使用定位
    LocationManagerLocationServiceStatusNoNetwork,             //没有网络
    LocationManagerLocationServiceStatusNotDetermined          //用户还没做出是否要允许应用使用定位功能的决定，第一次安装应用的时候会提示用户做出是否允许使用定位功能的决定
};

@interface LocationManager : NSObject

@property(nonatomic,retain)CLLocation *userLocation;
@property(nonatomic,assign,readonly)double latitude;
@property(nonatomic,assign,readonly)double longitude;
@property(assign, nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) LocationManagerLocationServiceStatus locationStatus;

+ (instancetype)sharedInstance;
- (void)startLocation;
- (void)stopLocation;
- (void)requestLocationWithReGeocode:(BOOL)reGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock;
- (void)reGeoSearchWithDelegate:(id)delegate coordinate:(CLLocationCoordinate2D)coordinate;
- (void)poiSearchWithDelegate:(id)delegate keyword:(NSString *)keyword city:(NSString *)city;
- (void)poiSearchNearbyWithDelegate:(id)delegate coordinate:(CLLocationCoordinate2D)coordinate keyword:(NSString *)keyword;

- (BOOL)checkLocationAndShowingAlert:(BOOL)showingAlert;

- (void)updateUserLocationWithCheckAlert:(BOOL)showingAlert onView:(UIView *)view success:(void(^)(void))success fail:(void(^)(void))fail;

@end
