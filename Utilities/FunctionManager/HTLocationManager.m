//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "NSString+Utilities.h"
//#import <AMapSearchKit/AMapSearchKit.h>

@interface HTLocationManager (LocationDelegate) <CLLocationManagerDelegate>//AMapSearchDelegate

@end

@interface HTLocationManager ()

//@property (nonatomic, strong) AMapSearchAPI *aMapSearch;
@property (nonatomic, strong) CLGeocoder * geocoder;
@property (nonatomic, copy) void(^reverseGeoCompletion)(HTLocation *location);

@end

@implementation HTLocationManager
{
    HTLocation *_location;
    CLLocation *_cllocation;
    BOOL _locating;
    CLLocationManager *_locationManager;
    void(^_clcompletion)(CLLocation *location);
    void(^_completion)(HTLocation *location);
    void(^_hanldeLocateDidFail)(NSError *error);
    void(^_handleDocateDidChangeAuthorizationStatus)(CLAuthorizationStatus status);
}

static HTLocationManager *_sharedInstance = nil;

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedManager {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (void) locationServiceNotAvailable {
    DLog(@"location service disabled.");
}

- (void) locateOnCompletion:(void (^)(CLLocation *location))completion {
    _clcompletion = completion;
    [self startLocationService];
}

- (void) locateCityOnCompletion:(void (^)(HTLocation *))completion {
    _completion = completion;
    [self startLocationService];
}

- (void) locateDidFailWithError:(void(^)(NSError *error)) hanldeLocateDidFail {
    _hanldeLocateDidFail = hanldeLocateDidFail;
}

- (void) locatedDidChangeAuthorizationStatus:(void(^)(CLAuthorizationStatus status)) handledocatedDidChangeAuthorizationStatus {
    _handleDocateDidChangeAuthorizationStatus = handledocatedDidChangeAuthorizationStatus;
}

- (void) startLocationService {
    
    //if (![CLLocationManager locationServicesEnabled]&&[CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self locationServiceNotAvailable];
    } else {
        if (_locating) {
            return;
        }
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.pausesLocationUpdatesAutomatically = YES;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
            if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
        }
        //CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        //DLog(@"authorization status: %d", status);
        _locating = YES;
        _locationManager.delegate = self;
        _location = nil;
        [_locationManager startUpdatingLocation];
    }
}

- (void)reverseGeoLoc:(CLLocation *)loc onCompletion:(void (^)(HTLocation *locatioin))completion{
    self.reverseGeoCompletion = completion;
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 11, *)) {
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        [self.geocoder reverseGeocodeLocation:loc preferredLocale:locale completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            [weakSelf handleGeocodeLocation:loc error:error placemarks:placemarks];
        }];
    }
    else {
        [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            [weakSelf handleGeocodeLocation:loc error:error placemarks:placemarks];
        }];
    }
}

- (void)handleGeocodeLocation:(CLLocation *)loc
                        error:(NSError *)error
                   placemarks:(NSArray<CLPlacemark *> *)placemarks
{
    if (error) {
        //逆地理编码失败，尝试用高德
//        [self aMapReverseGeoLoc:loc];
        return;
    }
    if(placemarks.count > 0)
    {
        for (CLPlacemark *placemark in placemarks) {
            HTLocation *location = [[HTLocation alloc] init];
            location.latitude = loc.coordinate.latitude;
            location.longitude = loc.coordinate.longitude;
            
            if([placemark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL){
                location.address = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            }
            
            if([placemark.addressDictionary objectForKey:@"SubAdministrativeArea"] != NULL){
                location.area = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
            }
            if([placemark.addressDictionary objectForKey:@"City"] != NULL){
                location.city = [placemark.addressDictionary objectForKey:@"City"];
            }
            if([placemark.addressDictionary objectForKey:@"State"]!=NULL){
                location.state = [placemark.addressDictionary objectForKey:@"State"];
            }
            if([placemark.addressDictionary objectForKey:@"Country"] != NULL){
                location.country = [placemark.addressDictionary objectForKey:@"Country"];
            }
            if (![NSString isNullOrEmpty:location.city] ||
                ![NSString isNullOrEmpty:location.state]/* ||
                                                         ![NSString isNullOrEmpty:location.country] ||
                                                         ![NSString isNullOrEmpty:location.address]*/) {
                                                             if (self.reverseGeoCompletion) {
                                                                 self.reverseGeoCompletion(location);
                                                             }
                                                             break;
                                                         }
        }
    }
}

- (CLAuthorizationStatus)authorizationStatus {
    return [CLLocationManager authorizationStatus];
}

- (BOOL)isLocationServicesAvailable {
    return ([CLLocationManager locationServicesEnabled] && ((kCLAuthorizationStatusAuthorizedAlways == [CLLocationManager authorizationStatus]) || (kCLAuthorizationStatusAuthorizedWhenInUse == [CLLocationManager authorizationStatus])));
}

- (void) locationDidUpdated:(CLLocation*) location {
    _cllocation = location;
    if (_clcompletion) {
        _clcompletion(location);
        _clcompletion = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (_handleDocateDidChangeAuthorizationStatus) {
        _handleDocateDidChangeAuthorizationStatus(status);
    }
//    switch (status) {
//        case kCLAuthorizationStatusNotDetermined:
//        {
//            DLog(@"用户还未决定授权");
//            break;
//        }
//        case kCLAuthorizationStatusRestricted:
//        {
//            DLog(@"访问受限");
//            break;
//        }
//        case kCLAuthorizationStatusDenied:
//        {
//            if ([CLLocationManager locationServicesEnabled]) {
//                DLog(@"定位服务开启，被拒绝");
//            } else {
//                DLog(@"定位服务关闭，不可用");
//            }
//            break;
//        }
//        case kCLAuthorizationStatusAuthorizedAlways:
//        {
//            DLog(@"获得前后台授权");
//            break;
//        }
//        case kCLAuthorizationStatusAuthorizedWhenInUse:
//        {
//            DLog(@"获得前台授权");
//            break;
//        }
//        default:
//            break;
//    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_hanldeLocateDidFail) {
        _hanldeLocateDidFail(error);
    }
}

- (void) handleReverseGeoInfo:(HTLocation *)location{
    
}

#pragma mark - 高德地图

//逆地理编码
//- (void)aMapReverseGeoLoc:(CLLocation *)loc {
//    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
//
//    regeo.location                    = [AMapGeoPoint locationWithLatitude:loc.coordinate.latitude longitude:loc.coordinate.longitude];
//    regeo.requireExtension            = YES;
//    [self.aMapSearch AMapReGoecodeSearch:regeo];
//}

#pragma mark - Setters & Getters

- (CLGeocoder *)geocoder
{
    if(!_geocoder)
    {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

//- (AMapSearchAPI *)aMapSearch {
//    if (!_aMapSearch) {
//        _aMapSearch = [[AMapSearchAPI alloc] init];
//        _aMapSearch.delegate = self;
//    }
//    return _aMapSearch;
//}

@end

@implementation HTLocationManager (LocationDelegate)


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _locating = NO;
    if (locations && locations.count>0) {
        [_locationManager stopUpdatingLocation];
        //for (NSInteger i=locations.count-1;i>=0;--i)
        {
            CLLocation *loc = [locations objectAtIndex:0];
            if (loc) {
                //                [[HTLocalSettings sharedSettings] setSettings:[NSNumber numberWithDouble:loc.coordinate.latitude]
                //                                                       forKey:kUserDefaultLoacationLat];
                //
                //                [[HTLocalSettings sharedSettings] setSettings:[NSNumber numberWithDouble:loc.coordinate.longitude]
                //                                                       forKey:kUserDefaultLoacationLog];
                HTLocation *location = [[HTLocation alloc] init];
                location.latitude = loc.coordinate.latitude;
                location.longitude = loc.coordinate.longitude;
                [self locationDidUpdated:loc];
            }else{
                [self locationDidUpdated:nil];
            }
            if (_completion) {
                [self reverseGeoLoc:loc onCompletion:_completion];
                _completion = nil;
            }
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    _locating = NO;
    [self locationDidUpdated:nil];
}

#pragma mark - 高德地图
//- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
//    if (response.regeocode != nil) {
//        //解析response获取地址描述
//        HTLocation *location = [[HTLocation alloc] init];
//        location.latitude = request.location.latitude;
//        location.longitude = request.location.longitude;
//        location.address = response.regeocode.formattedAddress;
//        location.area = response.regeocode.addressComponent.district;
//        if ([NSString isNullOrEmpty:response.regeocode.addressComponent.city]) {
//            location.city = response.regeocode.addressComponent.province;
//        } else {
//            location.city = response.regeocode.addressComponent.city;
//        }
//        location.state = response.regeocode.addressComponent.province;
//        if (self.reverseGeoCompletion) {
//            self.reverseGeoCompletion(location);
//        }
//    } else {
//        if (self.reverseGeoCompletion) {
//            self.reverseGeoCompletion(nil);
//        }
//    }
//}

//- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
//{
//    if (self.reverseGeoCompletion) {
//        self.reverseGeoCompletion(nil);
//    }
//}

@end
