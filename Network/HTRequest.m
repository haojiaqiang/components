//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTRequest.h"

static NSTimeInterval REQUEST_TIMEOUT_INTERVAL = 30;

@implementation HTRequest
{
    BOOL _showsLoadingView;
    BOOL _showsRetryView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _showsLoadingView = YES;
        _showsRetryView = YES;
    }
    return self;
}

- (NSString *)url {
    return [NSString stringWithFormat:@"%@://%@:%@%@%@", [self scheme], [self host], [self port], [self path], [self api]];
}

- (NSString *)scheme {
    return @"http";
}

- (NSString *)host {
    return @"";
}

- (NSString *)port {
    return @"";
}

- (NSString *)path {
    return @"";
}

- (NSString *)api {
    return @"";
}

- (void) setShowsLoadingView:(BOOL)showsLoadingView {
    _showsLoadingView = showsLoadingView;
}

- (BOOL) showsLoadingView {
    return _showsLoadingView;
}

- (void) setShowRetryView:(BOOL)showsRetryView {
    _showsRetryView = showsRetryView;
}

- (BOOL) showsRetryView {
    return _showsRetryView;
}

- (NSDictionary *)parameters {
    return self.dictionary;
}

- (NSTimeInterval)timeoutInterval {
    return REQUEST_TIMEOUT_INTERVAL;
}

- (NSDictionary *)headers {
    return @{
             @"Accept" : @"application/json",
             @"Content-Type" : @"application/json",
             @"Data-Type" : @"json",
             @"Accept-Encoding" : @"gzip",
             @"Content-Encoding" : @"gzip",
             };
}

- (NSSet *)acceptContentTypes {
    return [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
}

- (BOOL)enableResponseObject {
    return NO;
}

+ (NSArray *)ignoredProperties {
    return @[@"showsLoadingView", @"showsRetryView", @"loadingMessage", @"retryMessage"];
}

@end
