//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HTLocation.h"
#import "NSString+Utilities.h"

@interface HTLocationViewController ()

@end

@interface HTLocationViewController (LocationDelegate) <CLLocationManagerDelegate>

@end

@implementation HTLocationViewController
{
    HTLocation *_location;
    BOOL _locating, _geoReversing;
}

static CLLocationManager *_locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self startLocationService];
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

- (void) locationServiceNotAvailable {
    DLog(@"location service disabled.");
}

- (void) locationDidUpdated:(HTLocation*) location {
    
}

- (void) handleReverseGeoInfo:(HTLocation *)location{

}

- (void) reverseGeoFinished {
    _geoReversing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation HTLocationViewController (LocationDelegate)


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
                [self locationDidUpdated:location];
            }else{
                [self locationDidUpdated:nil];
            }
            //[self reverseGeoLoc:loc];
        }
    }
}

- (void)reverseGeoLoc:(CLLocation *)loc {
    if (_geoReversing) {
        return;
    }
    if (_location) {
        return;
    }
    _geoReversing = YES;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak id weakSelf = self;
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        [weakSelf reverseGeoFinished];
        if (error)
        {
            //[self locationDidUpdated:nil];
            [weakSelf handleReverseGeoInfo:nil];
            DLog(@"Failed with error: %@", error);
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
                if (![NSString isNullOrEmpty:location.city] &&
                    ![NSString isNullOrEmpty:location.state] &&
                    ![NSString isNullOrEmpty:location.country] &&
                    ![NSString isNullOrEmpty:location.address]) {
                    _location = location;
                    //[self locationDidUpdated:location];
                    [weakSelf handleReverseGeoInfo:location];
                    break;
                }
            }
        }
    }];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLog(@"############# location error: %@", error);
    _locating = NO;
    [self locationDidUpdated:nil];
}

@end
