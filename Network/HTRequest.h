//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTJSONModel.h"

@interface HTRequest : HTJSONModel

@property (nonatomic, assign) BOOL showsLoadingView;

@property (nonatomic, strong) NSString *loadingMessage; // only used when showsLoadingView is set to YES

@property (nonatomic, assign) BOOL showsRetryView;

@property (nonatomic, strong) NSString *retryMessage; // only used when showsRetryView is set to YES

- (NSTimeInterval)timeoutInterval;

- (NSString *)scheme; // eg. http, https, default : "http"

- (NSString *)host; // eg. www.example.com, default ""

- (NSString *)port; // eg. 80, 443 etc. default "80"

- (NSString *)path; // eg. app/ default ""

- (NSString *)api; // eg. getUser.rest etc. default : ""

- (NSString *)url; // no need to override, except your url is not format with: scheme://domain/path/api

- (NSDictionary *)headers; // http headers,

- (NSDictionary *)parameters; // no need to override except you have a specify realization

- (NSSet *)acceptContentTypes; // default: [NSSet setWithObjects: @"application/json", @"text/html", @"text/plain", nil];

- (BOOL)enableResponseObject; // return true if you want to get origin response object, else return false default: return false

@end
