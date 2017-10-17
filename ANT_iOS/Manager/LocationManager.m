//
//  LocationManager.m
//  anz
//
//  Created by KevinCao on 16/7/9.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "LocationManager.h"
//#import "PerfectUserInfoRequest.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define NotificationLocationUpdated               @"NotificationLocationUpdated"

@interface LocationManager () <AMapLocationManagerDelegate>
@property(nonatomic,assign,readwrite)double latitude;
@property(nonatomic,assign,readwrite)double longitude;
@property(nonatomic,strong)AMapLocationManager *amapLocationService;
@property(nonatomic,strong)AMapSearchAPI *amapSearch;

@property (nonatomic, assign, readwrite) LocationManagerLocationResult locationResult;
@property (nonatomic, assign, readwrite) LocationManagerLocationServiceStatus locationStatus;
//定位成功之后就不需要再通知到外面了，防止外面的数据变化。
@property (nonatomic) BOOL shouldNotifyOtherObjects;
//完善用户信息请求
//@property(nonatomic,strong)PerfectUserInfoRequest *perfectUserInfoRequest;
//更新用户定位信息
@property(nonatomic,assign)BOOL isLocateForPerfectUserInfo;
@property(nonatomic,strong)UIView *hudSuperView;
@property(nonatomic,copy)VoidBlock successBlock;
@property(nonatomic,copy)VoidBlock failBlock;
@end

@implementation LocationManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t AJKHDLocationManagerOnceToken;
    static LocationManager *sharedInstance = nil;
    dispatch_once(&AJKHDLocationManagerOnceToken, ^{
        sharedInstance = [[LocationManager alloc] init];
        sharedInstance.shouldNotifyOtherObjects = YES;
    });
    return sharedInstance;
}

- (BOOL)checkLocationAndShowingAlert:(BOOL)showingAlert;
{
    BOOL result = NO;
    BOOL serviceEnable = [self locationServiceEnabled];
    LocationManagerLocationServiceStatus authorizationStatus = [self locationServiceStatus];
    if (authorizationStatus == LocationManagerLocationServiceStatusOK && serviceEnable) {
        result = YES;
    }else if (authorizationStatus == LocationManagerLocationServiceStatusNotDetermined) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (serviceEnable && result) {
        result = YES;
    }else{
        result = NO;
    }
    
    if (result == NO) {
        [self failedLocationWithResultType:LocationManagerLocationResultFail statusType:self.locationStatus];
    }
    
    if (showingAlert && result == NO) {
        NSString *message = @"请到“设置->隐私->定位服务”中开启定位";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前定位服务不可用" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
        [alert show];
    }
    
    return result;
}

- (void)startLocation
{
    if ([self checkLocationAndShowingAlert:NO]) {
        self.locationResult = LocationManagerLocationResultLocating;
//        [self.locationService startUserLocationService];
        [self.amapLocationService startUpdatingLocation];
    } else {
        [self failedLocationWithResultType:LocationManagerLocationResultFail statusType:self.locationStatus];
    }
}

- (void)requestLocationWithReGeocode:(BOOL)reGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock
{
    [self.amapLocationService requestLocationWithReGeocode:reGeocode completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [self updateUserLocationFail];
            }
        } else {
            NSLog(@"location:%@", location);
            
            self.userLocation = location;
            self.coordinate = location.coordinate;
            self.latitude = location.coordinate.latitude;
            self.longitude = location.coordinate.longitude;
            self.locationResult = LocationManagerLocationResultSuccess;
            self.shouldNotifyOtherObjects = NO;
            if (self.isLocateForPerfectUserInfo) {
//                [self.perfectUserInfoRequest loadDataWithHUDOnView:self.hudSuperView];
                self.isLocateForPerfectUserInfo = NO;
            }
            
            if (regeocode)
            {
                NSLog(@"reGeocode:%@", regeocode);
            }
        }
        completionBlock(location, regeocode, error);
    }];
}

- (void)reGeoSearchWithDelegate:(id)delegate coordinate:(CLLocationCoordinate2D)coordinate
{
    __weak typeof(delegate) weakDelegate = delegate;
    self.amapSearch.delegate = weakDelegate;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    [self.amapSearch AMapReGoecodeSearch:regeo];
}

- (void)poiSearchWithDelegate:(id)delegate keyword:(NSString *)keyword city:(NSString *)city
{
    __weak typeof(delegate) weakDelegate = delegate;
    self.amapSearch.delegate = weakDelegate;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords = keyword;
    if (city.length) {
        request.city = city;
    }

    [self.amapSearch AMapPOIKeywordsSearch:request];
}

- (void)stopLocation
{
    if ([self checkLocationAndShowingAlert:NO]) {
//        [self.locationService stopUserLocationService];
        [self.amapLocationService stopUpdatingLocation];
    }
}

- (void)poiSearchNearbyWithDelegate:(id)delegate coordinate:(CLLocationCoordinate2D)coordinate keyword:(NSString *)keyword
{
    __weak typeof(delegate) weakDelegate = delegate;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.keywords = keyword;
    /* 按照距离排序. */
    request.sortrule = 0;
    request.requireExtension = YES;
    self.amapSearch.delegate = weakDelegate;
    [self.amapSearch AMapPOIAroundSearch:request];
}

- (void)updateUserLocationWithCheckAlert:(BOOL)showingAlert onView:(UIView *)view success:(void(^)(void))success fail:(void(^)(void))fail
{
    self.isLocateForPerfectUserInfo = YES;
    self.hudSuperView = view;
    self.successBlock = success;
    self.failBlock = fail;
    if ([self checkLocationAndShowingAlert:showingAlert]) {
        [self startLocation];
    }
}

#pragma mark - private
- (BOOL)locationServiceEnabled
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationStatus = LocationManagerLocationServiceStatusOK;
        return YES;
    } else {
        self.locationStatus = LocationManagerLocationServiceStatusUnknownError;
        return NO;
    }
}

- (LocationManagerLocationServiceStatus)locationServiceStatus
{
    self.locationStatus = LocationManagerLocationServiceStatusUnknownError;
    BOOL serviceEnable = [CLLocationManager locationServicesEnabled];
    if (serviceEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = LocationManagerLocationServiceStatusNotDetermined;
                break;
             
            case kCLAuthorizationStatusAuthorizedAlways:
                self.locationStatus = LocationManagerLocationServiceStatusOK;
                break;
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.locationStatus = LocationManagerLocationServiceStatusOK;
                break;
                
            case kCLAuthorizationStatusDenied:
                self.locationStatus = LocationManagerLocationServiceStatusNoAuthorization;
                break;
                
            default:
                self.locationStatus = LocationManagerLocationServiceStatusNoNetwork;
                break;
        }
    } else {
        self.locationStatus = LocationManagerLocationServiceStatusUnAvailable;
    }
    return self.locationStatus;
}

- (void)failedLocationWithResultType:(LocationManagerLocationResult)result statusType:(LocationManagerLocationServiceStatus)status
{
    self.locationResult = result;
    self.locationStatus = status;
    [self didFailToLocateUserWithError:nil];
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    self.userLocation = location;
    if (location.coordinate.latitude == self.coordinate.latitude && location.coordinate.longitude == self.coordinate.longitude) {
        if (self.isLocateForPerfectUserInfo) {
            [self updateUserLocationSuccess];
        }
        return;
    }
    
    self.coordinate = location.coordinate;
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    self.locationResult = LocationManagerLocationResultSuccess;
    self.shouldNotifyOtherObjects = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLocationUpdated object:nil];
    [self stopLocation];
    if (self.isLocateForPerfectUserInfo) {
        [self updateUserLocationSuccess];
        self.isLocateForPerfectUserInfo = NO;
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    //之前如果有定位成功的话，以后的定位失败就都不通知到外面了
    if (!self.shouldNotifyOtherObjects) {
        return;
    }
    //如果用户还没选择是否允许定位，则不认为是定位失败
    if (self.locationStatus == LocationManagerLocationServiceStatusNotDetermined) {
        return;
    }
    //如果正在定位中，那么也不会通知到外面
    if (self.locationResult == LocationManagerLocationResultLocating) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLocationUpdated object:nil userInfo:nil];
    [self updateUserLocationFail];
}

-(void)updateUserLocationSuccess
{
//    userManager.userData.latitude = [NSString stringWithFormat:@"%@",@(locationManager.latitude)];
//    userManager.userData.longitude = [NSString stringWithFormat:@"%@",@(locationManager.longitude)];
//    [UserManager saveLocalUserLoginInfo];
    if (self.successBlock) {
        self.successBlock();
        self.successBlock = nil;
    }
    self.isLocateForPerfectUserInfo = NO;
    self.failBlock = nil;
    self.hudSuperView = nil;
}

-(void)updateUserLocationFail
{
    if (self.failBlock) {
        self.failBlock();
        self.failBlock = nil;
    }
    self.isLocateForPerfectUserInfo = NO;
    self.successBlock = nil;
    self.hudSuperView = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}

//#pragma mark - APIManagerParamSourceDelegate
//- (NSDictionary *)paramsForApi:(APIRequest *)request {
//    if (request == self.perfectUserInfoRequest) {
//        return @{@"user":@{
//                         @"latitude":[NSString stringWithFormat:@"%@",@(locationManager.latitude)],
//                         @"longitude":[NSString stringWithFormat:@"%@",@(locationManager.longitude)],
//                         @"user_id":safeString(userManager.userData.userId)
//                         }};
//    }
//    return nil;
//}
//
//#pragma mark - APIManagerApiCallBackDelegate
//- (void)managerCallAPIDidSuccess:(APIRequest *)request {
//    [self updateUserLocationSuccess];
//}
//
//- (void)managerCallAPIDidFailed:(APIRequest *)request {
//    if (self.failBlock) {
//        self.failBlock();
//        self.successBlock = nil;
//        self.failBlock = nil;
//    }
//}

#pragma mark - getters and setters
-(AMapLocationManager *)amapLocationService
{
    if (!_amapLocationService) {
        _amapLocationService = [[AMapLocationManager alloc] init];
        _amapLocationService.delegate = self;
        [_amapLocationService setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _amapLocationService.locationTimeout = 2;
    }
    return _amapLocationService;
}

-(AMapSearchAPI *)amapSearch
{
    if (!_amapSearch) {
        _amapSearch = [[AMapSearchAPI alloc] init];
    }
    return _amapSearch;
}

//- (BOOL)isReachable
//{
//    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
//        return YES;
//    } else {
//        return [[AFNetworkReachabilityManager sharedManager] isReachable];
//    }
//}
//
//-(PerfectUserInfoRequest *)perfectUserInfoRequest
//{
//    if (!_perfectUserInfoRequest) {
//        _perfectUserInfoRequest = [[PerfectUserInfoRequest alloc] initWithDelegate:self paramSource:self];
//    }
//    return _perfectUserInfoRequest;
//}

@end
