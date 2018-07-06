//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTBaseViewController.h"
#import "HTNetworkManager.h"
#import "HTNetworkReachabilityManager.h"
#import "HTShakingView.h"
#import "HYCircleLoadingView.h"
#import "HTRetryView.h"
#import "HTLoadingView.h"
#import <objc/runtime.h>
#import "Constants.h"
#import "HTDefaultBackgroundView.h"
#import "HTNotificationKeys.h"
#import "HTNavigationController.h"
#import "HTColor.h"
#import "HTViewKit.h"
#import "NSString+Utilities.h"
#import "UIScrollView+HTRefresh.h"
#import "UIView+ConvenienceFrame.h"
#import "HTLabel.h"

static CGFloat WARNING_MESSAGE_DELAY = 3.0f;
static CGFloat WARNING_MESSAGE_DISPLAY_DELAY = 0.2f;
static NSString *HTNotificationNumberKey = @"notificationNumber";
static NSString *HTNotificationDataKey = @"notificationData";
static NSString * const reuseId = @"WTViewControllerPlaceHolderHeaderFooterView";

@interface HTBaseViewController ()

@end

@implementation HTBaseViewController
{
    NSMutableArray *_refreshTypes;
    NSMutableDictionary *_refreshType2Data;
    BOOL _firstLoad;
    HTRetryView *_retryView;
    HTLoadingView *_loadingView;
    HTDefaultBackgroundView *_noDataView, *_requestErrorView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (BEFORE_iOSVersion(11)) {
            self.automaticallyAdjustsScrollViewInsets = YES;
        }
        self.edgesForExtendedLayout = UIRectEdgeAll;
        _autorotate = YES;
        _orientationMask = UIInterfaceOrientationMaskAll;
        _preferredOrientation = UIInterfaceOrientationPortrait;
        _interactivePopGestureEnabled = YES;
        _reloadRemoteType = HTReloadRemoteTypeViewDidAppear;
        _shakingEnabled = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_firstLoad) {
        _firstLoad = NO;
    }
    else {
        if(self.reloadRemoteType == HTReloadRemoteTypeViewDidAppear){
            [self checkReloadRemoteData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAutorotate:_autorotate];
    [self setOrientationMask:_orientationMask];
    [self setPreferredOrientation:_preferredOrientation];

    if(_firstLoad){
        _firstLoad = NO;
    }
    else{
        if(self.reloadRemoteType == HTReloadRemoteTypeViewWillAppear) {
            [self checkReloadRemoteData];
        }
    }
    if (iOS6) {
        [self.view becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (iOS6) {
        [self.view resignFirstResponder];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRefreshRequired object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"############### Dealloc: %@", [self class]);
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_shakingEnabled){
        HTShakingView *shakingView = [[HTShakingView alloc] initWithFrame:self.view.bounds];
        __weak id weakSelf = self;
        shakingView.onShaking = ^(void){
            [weakSelf handleShaking];
        };
        self.view = shakingView;
    }
    self.view.backgroundColor = kWhiteColor;
    
    _refreshTypes = [NSMutableArray array];
    _refreshType2Data = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefreshNotification:) name:kNotificationRefreshRequired object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)setNavgationBarTitleDefaultColor{
    
    UINavigationController * nav = self.navigationController;
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [HTColor themeBlack],
                                 NSFontAttributeName : [UIFont  systemFontOfSize:18],
                                 };
    if (IOS9) {
        attributes = @{
                       NSForegroundColorAttributeName : [HTColor themeBlack],
                       NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:18],
                       };
    }
    
    [nav.navigationBar setTitleTextAttributes:attributes];
}
- (void)handleShaking {
    //DLog(@"####### Shaking........");
}

- (void)handleAppBecomeActive:(NSNotification *)notification {
    [self appBecomeActive:notification];
}

- (void)handleAppWillResignActive:(NSNotification *)notification {
    [self appWillResignActive:notification];
}

- (void)appBecomeActive:(NSNotification *)notification {
    
}

- (void)appWillResignActive:(NSNotification *)notification {
    
}

- (void)handleRefreshNotification:(NSNotification *)notification {
    NSDictionary *dictionary = notification.object;
    if(dictionary){
        NSNumber *number = [dictionary objectForKey:HTNotificationNumberKey];
        if (number) {
            id data = [dictionary objectForKey:HTNotificationDataKey];
            [self addRefreshType:number.integerValue withData:data];
        }
    }
}

- (void)addRefreshType:(NSInteger)refreshType withData:(id)data {
    if(![self containsNotification:refreshType]){
        [_refreshTypes addObject:[NSNumber numberWithInteger:refreshType]];
        if (data) {
            [_refreshType2Data setObject:data forKey:[NSString stringWithFormat:@"%d", (int)refreshType]];
        }
    }
}

- (void)checkReloadRemoteData {
    if(_refreshTypes.count > 0) {
        for(NSNumber *number in _refreshTypes){
            [self didReceiveNotification:number.integerValue withData:[_refreshType2Data objectForKey:[NSString stringWithFormat:@"%d", (int)number.integerValue]]];
        }
        [_refreshTypes removeAllObjects];
    }
}

- (void)setAutorotate:(BOOL)autorotate {
    _autorotate = autorotate;
    if([self.navigationController isKindOfClass:[HTNavigationController class]]){
        [((HTNavigationController *)self.navigationController) setAutorotate:autorotate];
    }
}

- (BOOL)isAutorotate {
    return _autorotate;
}

- (void)setOrientationMask:(UIInterfaceOrientationMask)orientationMask {
    _orientationMask = orientationMask;
    if([self.navigationController isKindOfClass:[HTNavigationController class]]){
        [((HTNavigationController *)self.navigationController) setOrientationMask:orientationMask];
    }
}

- (void)setPreferredOrientation:(UIInterfaceOrientation)preferredOrientation {
    _preferredOrientation = preferredOrientation;
    if([self.navigationController isKindOfClass:[HTNavigationController class]]){
        [((HTNavigationController*)self.navigationController) setPreferredOrientation:preferredOrientation];
    }
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:preferredOrientation] forKey:@"orientation"];
}

- (BOOL)shouldAutorotate {
    return _autorotate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _orientationMask;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return _preferredOrientation;
}

- (void) setInteractivePopGestureRecognizerEnabled:(BOOL)enabled{
    _interactivePopGestureEnabled = enabled;
    if([self.navigationController isKindOfClass:[HTNavigationController class]]){
        [((HTNavigationController*)self.navigationController) setInteractivePopGestureRecognizerEnabled:enabled];
    }
}

//NeHTork Related Interfaces
- (BOOL) isReachable{
    return [[HTNetworkReachabilityManager sharedManager] isReachable];
}

- (BOOL) isReachableViaWiFi{
    return [[HTNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

- (BOOL) isReachableViaWWAN{
    return [[HTNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}

- (void) post:(HTRequest*)request forResponseClass:(Class)clazz onSuccess:(void (^)(HTResponse* response)) success onFailure: (void (^)(NSError* error)) failure {
    __weak id weakSelf = self;
    BOOL showLoadingView = request.showsLoadingView;
    if (showLoadingView) {
        [self startLoadingViewWithMessage:kStr(@"Loading")];
    }
    [[HTNetworkManager sharedManager] post:request forResponseClass:clazz progress:nil success:^(HTResponse *response) {
        if (showLoadingView) {
            [weakSelf stopLoadingView];
        }
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (showLoadingView) {
            [weakSelf stopLoadingView];
        }
        if (failure) {
            failure(error);
        }
    }];
}

- (void) post:(HTRequest*)request forResponseClass:(Class)clazz onSuccess:(void (^)(HTResponse *response)) success onFailure: (void (^)(NSError* error)) failure onRetry: (void (^)()) onRetry {
    __weak id weakSelf = self;
    BOOL showLoadingView = request.showsLoadingView;
    if (showLoadingView) {
        [self startLoadingViewWithMessage:kStr(@"Loading")];
    }
    BOOL isShowRetryView = request.showsRetryView;
    if (isShowRetryView) {
        [self removeRetryView];
    }
    [self post:request forResponseClass:clazz onSuccess:^(HTResponse *response) {
        if (showLoadingView) {
            [weakSelf stopLoadingView];
        }
        if (success) {
            success(response);
        }
    } onFailure:^(NSError *error) {
        if (showLoadingView) {
            [weakSelf stopLoadingView];
        }
        if (failure) {
            failure(error);
        }
        if (onRetry) {
            [weakSelf showWarningView:kStr(@"Request Failed") onCompletion:^{
                [weakSelf createRetryViewWithMessage:kStr(@"Tap to retry") onCompletion:onRetry];
            }];
        }
    }];
}

- (void) handleCommonError: (NSError*) error {
    //TODO:
}

- (void) handleErrorResponse:(id)responseData{
    if(responseData){
        NSString *message = [responseData objectForKey:@"message"];
        if(message && ![NSString isNullOrEmpty:message]){
            [self showAlertMessage:[responseData objectForKey:@"message"] withTitle:kStr(@"Error")];
        }
    }
}

- (void) startHTLoadingViewWithMessage:(NSString*) message {
    
}

- (void) stopHTLoadingView {
    
}

- (void) stopRefreshing:(UIScrollView*) scrollView refresh:(BOOL) refresh pulling:(BOOL) pulling {
    if (pulling) {
        if (refresh) {
            [scrollView stopHeaderRefreshing];
        }
        else {
            [scrollView stopFooterRefreshing];
        }
    } else {
        [self stopLoadingView];
    }
}

- (void) startLoadingViewWithMessage:(NSString *)loadingMessage{
    if (!_loadingView) {
        _loadingView = [[HTLoadingView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) andRadius:0];
        _loadingView.backgroundColor = _loadingView.maskColor;
        __weak id weakSelf = self;
        _loadingView.popviewDidClose = ^(HTPopoverView *popoverView) {
            [weakSelf handleCloseLoadingView];
        };
    }
    [_loadingView showInView:self.view];
}

- (UIColor*) loadingMaskColor {
    return kClearColor;
}

- (void) handleCloseLoadingView {
    _loadingView = nil;
}

- (void) stopLoadingView{
    [self stopLoadingView:YES];
}

- (void) stopLoadingView:(BOOL)animated{
    if (_loadingView) {
        [_loadingView close/*:animated*/];
    }
}

- (void) rightNavigationItemWithSpacing:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)sel{
    BOOL special = NO;
    switch (systemItem) {
        case UIBarButtonSystemItemSearch:
        case UIBarButtonSystemItemAdd:
        case UIBarButtonSystemItemAction:
        case UIBarButtonSystemItemBookmarks:
        case UIBarButtonSystemItemCamera:
        case UIBarButtonSystemItemCompose:
        case UIBarButtonSystemItemFastForward:
        case UIBarButtonSystemItemPlay:
        case UIBarButtonSystemItemTrash:
        case UIBarButtonSystemItemRewind:
        case UIBarButtonSystemItemOrganize:
        case UIBarButtonSystemItemPause:
        case UIBarButtonSystemItemRefresh:
        case UIBarButtonSystemItemReply:
        case UIBarButtonSystemItemStop:
        case UIBarButtonSystemItemPageCurl:
            special = YES;
            break;
            
        default:
            break;
    }
    if (IOS7 && special) {
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = -8;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:sel], space, nil];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:sel];
    }
}

- (UIImage*)screenShot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != &UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) createRetryViewWithCompletion:(void (^)(void))completion{
    [self createRetryViewWithMessage:nil onCompletion:completion];
}

- (void) createRetryViewWithMessage:(NSString *)message onCompletion:(void (^)(void))completion{
    if(!_retryView){
        CGFloat w = 148, h = 180;
        _retryView = [[HTRetryView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-h)/2, w, h) andRadius:8];
        _retryView.layer.opacity = 0.0f;
        _retryView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        //_retryView.backgroundColor = kRGB(245, 245, 245);
        _retryView.layer.opacity = .85;
        if (message) {
            _retryView.retryMessage = message;
        }
        [_retryView setIconBGColor:kClearColor];
        _retryView.onRetry = ^(void){
            if (completion) {
                completion();
            }
        };
        [self.view addSubview:_retryView];
        
        [UIView animateWithDuration:0.5 animations:^{
            _retryView.layer.opacity = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void) removeRetryView{
    if (_retryView) {
        [_retryView removeFromSuperview];
        _retryView = nil;
    }
}

- (void) layoutRetryViewAnimate:(BOOL)animated{
    if(_retryView){
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                _retryView.frame  =CGRectMake((self.view.frame.size.width-_retryView.frame.size.width)/2, (self.view.frame.size.height-_retryView.frame.size.height)/2, _retryView.frame.size.width, _retryView.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        }
        else{
            _retryView.frame  =CGRectMake((self.view.frame.size.width-_retryView.frame.size.width)/2, (self.view.frame.size.height-_retryView.frame.size.height)/2, _retryView.frame.size.width, _retryView.frame.size.height);
        }
    }
}

- (void)addNoDataViewWithImageName:(NSString *)imageName
                             title:(NSString *)title {
    [self addNoDataViewWithImageName:imageName
                               title:nil
                            subTitle:title
                            btnTitle:nil
                           ClikOnBtn:nil];
}

- (void)addNoDataViewWithImageName:(NSString *)imageName
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle {
    [self addNoDataViewWithImageName:imageName
                               title:title
                            subTitle:subTitle
                            btnTitle:nil
                           ClikOnBtn:nil];
}

- (void)addNoDataViewWithImageName:(NSString *)imageName
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle
                          btnTitle:(NSString *)btnTitle
                         ClikOnBtn:(void (^)())completion {

    [self addNoDataViewToView:nil
           moveVerticalOffset:0.0f
                WithImageName:imageName
                        title:title
                     subTitle:subTitle
                     btnTitle:btnTitle
                    ClikOnBtn:completion];
}

- (void)addNoDataViewWithImageName:(NSString *)imageName
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle
                          btnTitle:(NSString *)btnTitle
                     btnTitleColor:(UIColor *)btnTitleColor
                btnBackgroundColor:(UIColor *)btnBackgroundColor
                         ClikOnBtn:(void (^)())completion {
    [self addNoDataViewToView:nil
           moveVerticalOffset:0.0f
                WithImageName:imageName
                        title:title
                     subTitle:subTitle
                     btnTitle:btnTitle
                    btnTitleColor:btnTitleColor btnBackgroundColor:btnBackgroundColor ClikOnBtn:completion];
}

- (void)addNoDataViewToView:(UIView *)view
         moveVerticalOffset:(CGFloat)offset
              WithImageName:(NSString *)imageName
                      title:(NSString *)title
                   subTitle:(NSString *)subTitle
                   btnTitle:(NSString *)btnTitle
              btnTitleColor:(UIColor *)btnTitleColor
         btnBackgroundColor:(UIColor *)btnBackgroundColor
                  ClikOnBtn:(void (^)())completion {
    [self removeRequestErrorViewFromeSuperView];
    [self removeNoDataViewFromeSuperView];
    
    if (_noDataView == nil) {
        _noDataView = [HTDefaultBackgroundView
                       defaultBackgroundViewWithType:HTDefaultBackgroundViewNoData
                       image:[UIImage imageNamed:imageName]
                       title:title
                       subTitle:subTitle
                       btnTitle:btnTitle
                       completion:completion];
    }
    _noDataView.alpha = 0.0f;
    _noDataView.backgroundColor = kWhiteColor;
    if (btnTitleColor) {
        _noDataView.btnTitleColor = btnTitleColor;
    }
    if (btnBackgroundColor) {
        _noDataView.btnBackgroundColor = btnBackgroundColor;
    }
    if (view == nil) {
        _noDataView.frame = self.view.bounds;
        [self.view addSubview:_noDataView];
    } else {
        _noDataView.frame = view.bounds;
        [view addSubview:_noDataView];
    }
    _noDataView.verticalOffset = offset;
    //_noDataView.top += offset;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _noDataView.alpha = 1.0f;
                     }];
}

- (void)addNoDataViewToView:(UIView *)view
         moveVerticalOffset:(CGFloat)offset
              WithImageName:(NSString *)imageName
                      title:(NSString *)title
                   subTitle:(NSString *)subTitle
                   btnTitle:(NSString *)btnTitle
                  ClikOnBtn:(void (^)())completion {
    [self addNoDataViewToView:view moveVerticalOffset:offset WithImageName:imageName title:title subTitle:subTitle btnTitle:btnTitle btnTitleColor:nil btnBackgroundColor:nil ClikOnBtn:completion];
}

- (void)removeNoDataViewFromeSuperView {
    if (_noDataView) {
        _noDataView.alpha = 0.0f;
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

- (void)addRequestErrorViewWithRetry:(void (^)())complition {
    [self addRequestErrorViewToView:nil moveOffset:0.0f WithRetry:complition];
}

- (void)addRequestErrorViewToView:(UIView *)view
                       moveOffset:(CGFloat)offset
                        WithRetry:(void (^)())complition {
    [self removeNoDataViewFromeSuperView];
    [self removeRequestErrorViewFromeSuperView];
    
    if (_requestErrorView == nil) {
        
        UIImage *image = nil;
        // 3.11 错误提示不区分，网络状态
        image = [UIImage imageNamed:@"no-neHTork"];
        
//        if ([self isReachable]) {
//            image = [UIImage imageNamed:@"webview-load"];
//        } else {
//            image = [UIImage imageNamed:@"no-neHTork"];
//        }
        _requestErrorView = [HTDefaultBackgroundView
        defaultBackgroundViewWithType:HTDefaultBackgroundViewRequestError
                                image:image
                                title:kStr(@"Request Error")
                             subTitle:kStr(@"LoadAgain")
                             btnTitle:nil
                           completion:complition];
    }
    _requestErrorView.alpha = 0.0f;
    _requestErrorView.backgroundColor = kWhiteColor;
    if (view == nil) {
        _requestErrorView.frame = self.view.bounds;
        [self.view addSubview:_requestErrorView];
    } else {
        _requestErrorView.frame = view.bounds;
        [view addSubview:_requestErrorView];
    }
    _requestErrorView.verticalOffset = offset;
    _requestErrorView.top += offset;

    [UIView animateWithDuration:0.25
                   animations:^{
                       _requestErrorView.alpha = 1.0f;
                    }];
}

- (void)addRequestErrorViewToView:(UIView *)view
                       moveOffset:(CGFloat)offset frame:(CGRect)frame
                        WithRetry:(void (^)())complition {
    [self removeNoDataViewFromeSuperView];
    [self removeRequestErrorViewFromeSuperView];
    
    if (_requestErrorView == nil) {
        
        UIImage *image = nil;
        if ([self isReachable]) {
            image = [UIImage imageNamed:@"webview-load"];
        } else {
            image = [UIImage imageNamed:@"no-neHTork"];
        }
        
        _requestErrorView = [HTDefaultBackgroundView
                             defaultBackgroundViewWithType:HTDefaultBackgroundViewRequestError
                             image:image
                             title:kStr(@"Request Error")
                             subTitle:kStr(@"LoadAgain")
                             btnTitle:nil
                             completion:complition];
    }
    _requestErrorView.alpha = 0.0f;
    _requestErrorView.backgroundColor = kWhiteColor;
    if (view == nil) {
        _requestErrorView.frame = frame;
        [self.view addSubview:_requestErrorView];
    } else {
        _requestErrorView.frame = frame;
        [view addSubview:_requestErrorView];
    }
    _requestErrorView.verticalOffset = offset;
    _requestErrorView.top += offset;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _requestErrorView.alpha = 1.0f;
                     }];
}


- (void)removeRequestErrorViewFromeSuperView {
    if (_requestErrorView) {
        _requestErrorView.alpha = 0.0f;

        [_requestErrorView removeFromSuperview];
        _requestErrorView = nil;
    }
}

- (UIControl*) buttonItemForBarButton:(UIBarButtonItem *)barButtonItem{
    UINavigationBar *toolbar = self.navigationController.navigationBar;
    UIControl *button = nil;
    for (UIView *subview in toolbar.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
            for (id target in [(UIControl *)subview allTargets]) {
                if (target == barButtonItem) {
                    button = (UIControl *)subview;
                    break;
                }
            }
            if (button != nil) break;
        }
    }
    return button;
}

- (CGFloat) topLayoutGuideHeight {
    return self.topLayoutGuide.length;
    //return ((UIView*)self.topLayoutGuide).frame.size.height;
}

- (CGFloat) bottomLayoutGuideHeight {
    return self.bottomLayoutGuide.length;
    //return ((UIView*)self.bottomLayoutGuide).frame.size.height;
}

- (CGFloat) layoutGuideHeight {
    return self.topLayoutGuideHeight+self.bottomLayoutGuideHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iOS 11 适配
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:reuseId];
        view.frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:reuseId];
        view.frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end

@implementation UIViewController (Message)

- (HTView *)warningView {
    return objc_getAssociatedObject(self, @"HTWarningView");
}

- (void)seHTarningView:(HTView *)warningView {
    if (warningView) {
        objc_setAssociatedObject(self, @"HTWarningView", warningView, OBJC_ASSOCIATION_RETAIN);
    }
    else {
        //objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, @"HTWarningView", nil, OBJC_ASSOCIATION_RETAIN);
    }
}

#pragma mark - showWarningViewOnMiddle

- (void) showWarningView:(NSString *)warningMessage{
    [self showWarningView:warningMessage autoCloseAfter:WARNING_MESSAGE_DELAY];
}

- (void) showWarningViewWithDisplayDelay:(NSString *)warningMessage{
    [self showWarningView:warningMessage autoDisplayAfter:WARNING_MESSAGE_DISPLAY_DELAY autoCloseAfter:WARNING_MESSAGE_DELAY onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage autoDisplayAfter:(double)displayDelay{
    [self showWarningView:warningMessage autoDisplayAfter:displayDelay autoCloseAfter:WARNING_MESSAGE_DELAY onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage onCompletion:(void (^)())completion {
    [self showWarningView:warningMessage autoCloseAfter:WARNING_MESSAGE_DELAY onCompletion:completion];
}

- (void) showWarningView:(NSString *)warningMessage autoCloseAfter:(NSInteger)secondsDelay {
    [self showWarningView:warningMessage autoCloseAfter:secondsDelay onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage autoCloseAfter:(double)secondsDelay onCompletion:(void (^)())completion{
    [self showWarningView:warningMessage autoDisplayAfter:0 autoCloseAfter:secondsDelay onCompletion:completion];
}

- (void) showWarningView:(NSString *)warningMessage
        autoDisplayAfter:(double)displaySecondsDelay
          autoCloseAfter:(double)secondsDelay
            onCompletion:(void (^)())completion {
    [self showWarningView:warningMessage
                     type:ShowWarningViewTypeMiddle
         autoDisplayAfter:displaySecondsDelay
           autoCloseAfter:secondsDelay
             onCompletion:completion];
}

#pragma mark - showWarningViewWithType

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type {
    [self showWarningView:warningMessage
                     type:type
           autoCloseAfter:WARNING_MESSAGE_DELAY];
}

- (void) showWarningViewWithDisplayDelay:(NSString *)warningMessage
                                    type:(ShowWarningViewType)type {
    [self showWarningView:warningMessage
                     type:type
         autoDisplayAfter:WARNING_MESSAGE_DISPLAY_DELAY
           autoCloseAfter:WARNING_MESSAGE_DELAY
             onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
        autoDisplayAfter:(double)displayDelay {
    [self showWarningView:warningMessage
                     type:type
         autoDisplayAfter:displayDelay
           autoCloseAfter:WARNING_MESSAGE_DELAY
             onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
            onCompletion:(void(^)())completion {
    [self showWarningView:warningMessage
                     type:type
           autoCloseAfter:WARNING_MESSAGE_DELAY
             onCompletion:completion];
}

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
          autoCloseAfter:(NSInteger) secondsDelay {
    [self showWarningView:warningMessage
                     type:type
           autoCloseAfter:secondsDelay
             onCompletion:nil];
}

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
          autoCloseAfter:(double)secondsDelay
            onCompletion:(void(^)())completion {
     [self showWarningView:warningMessage
                      type:type
          autoDisplayAfter:0
            autoCloseAfter:secondsDelay
              onCompletion:completion];
}

- (void)showWarningViewOnBottom:(NSString *)warningMessage {
    [self showWarningView:warningMessage
                     type:ShowWarningViewTypeBottom];
}

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
        autoDisplayAfter:(double)displaySecondsDelay
          autoCloseAfter:(double)secondsDelay
            onCompletion:(void (^)())completion {
    if ([NSString isNullOrEmpty:warningMessage]) {
        return;
    }
    HTView *_warningView = [self warningView];
    if (_warningView == nil) {
        _warningView = [self createWarningView:warningMessage];
        _warningView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
        if (completion) {
            objc_setAssociatedObject(_warningView, @"warningViewCompletionBlock", completion, OBJC_ASSOCIATION_COPY);
        }
        [self seHTarningView:_warningView];
        [self.view addSubview:_warningView];
    }
    else{
        HTLabel *label = (HTLabel*)[_warningView viewWithTag:1000];
        [label setText:warningMessage];
    }
    // 根据风格显示在不同位置
    CGRect frame = _warningView.frame;
    CGFloat tap = 64; //距离上方或下方的间距
    switch (type) {
        case ShowWarningViewTypeTop: {
            frame.origin.y = 64 + tap;
            break;
        }
        case ShowWarningViewTypeMiddle: {
            // nothing
            break;
        }
        case ShowWarningViewTypeBottom: {
            frame.origin.y = kDeviceHeight - tap - frame.size.height;
            break;
        }
        default:
            break;
    }
    _warningView.frame = frame;
    if (displaySecondsDelay > 0.01){
        _warningView.hidden = YES;
        [self performSelector:@selector(displayWarningView:) withObject:_warningView afterDelay:displaySecondsDelay];
    }
    
    if(secondsDelay<=0){
        secondsDelay = WARNING_MESSAGE_DELAY;
    } else {
        secondsDelay += displaySecondsDelay;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWarningView:) object:_warningView];
    [self performSelector:@selector(hideWarningView:) withObject:_warningView afterDelay:secondsDelay];
}

- (HTView *)createWarningView:(NSString *)warningMessage {
    HTLabel *warningLabel = [[HTLabel alloc]initWithFrame:CGRectMake(16, 10, kDeviceWidth-16*2, 50)];
    warningLabel.text = warningMessage;
    warningLabel.textColor = kWhiteColor;
    warningLabel.font = kAppFont(14);
    warningLabel.tag = 1000;
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.numberOfLines = 0;
    [warningLabel sizeToFit];
    if (warningLabel.frame.size.width<self.view.frame.size.width/2) {
        CGRect r = warningLabel.frame;
        r.size.width = MAX(self.view.frame.size.width/3, r.size.width);
        warningLabel.frame = r;
    }
    
    HTView *_warningView = [[HTView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-warningLabel.frame.size.width-16*2)/2, (self.view.frame.size.height-warningLabel.frame.size.height-20)/2+64/2, warningLabel.frame.size.width+16*2, warningLabel.frame.size.height+20) andRadius:0.0f];
    
    //_warningView.radius = (int)_warningView.frame.size.height/2;
    _warningView.radius = 3; //和LFBaseViewController一致，保证风格统一
    [_warningView addSubview:warningLabel];
    warningLabel=nil;
    _warningView.backgroundColor = kRGBA(45, 45, 45, 0.85);
    return _warningView;
}

- (void)displayWarningView:(HTView*)warningView{
    warningView.hidden = NO;
}

- (void)hideWarningView:(HTView *)warningView{
    [UIView animateWithDuration:0.25 animations:^{
        warningView.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [warningView removeFromSuperview];
        void (^completionBlock)() = objc_getAssociatedObject(warningView, @"warningViewCompletionBlock");
        if (completionBlock) {
            completionBlock();
        }
        [self seHTarningView:nil];
    }];
}

- (void) showAlertMessage:(NSString *)message {
    [self showAlertMessage:message withTitle:nil];
}

- (void) showAlertMessage:(NSString *)message withTitle:(NSString *)title{
    [self showAlertMessage:message withTitle:title onCompletion:nil];
}

- (void) showAlertMessage:(NSString *)message onCompletion:(HTAlertViewCompletionBlock)completion {
    [self showAlertMessage:message withTitle:nil onCompletion:completion];
}

- (void) showAlertMessage:(NSString*) message withTitle:(NSString *)title onCompletion:(HTAlertViewCompletionBlock)completion {
    [self showConfirmMessage:message withTitle:title cancelButtonTitle:kStr(@"Close") okButtonTitle:nil onCompletion:completion];
}

- (void) showConfirmMessage:(NSString *)message withTitle:(NSString *)title onCompletion:(HTAlertViewCompletionBlock)completion {
    [self showConfirmMessage:message withTitle:title cancelButtonTitle:kStr(@"Cancel") okButtonTitle:kStr(@"Ok") onCompletion:completion];
}

- (void) showConfirmMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle onCompletion:(HTAlertViewCompletionBlock)completion {
    [[HTAlert sharedAlert] showConfirmMessage:message withTitle:title cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle onCompletion:completion];
}

- (void) showActionSheetOnCompletion:(HTActionSheetCompletionBlock)completion withTitle:(NSString *)title cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*) destructiveButtonTitle otherButtonTitles:(NSString*) otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    [[HTAlert sharedAlert] showActionSheetInView:self.view completion:completion withTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
}

- (void) showActionSheetOnCompletion:(HTActionSheetCompletionBlock)completion withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitlesInArray:(NSArray *)otherButtonTitles {
    [[HTAlert sharedAlert] showActionSheetInView:self.view completion:completion withTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitlesInArray:otherButtonTitles];
}

@end

@implementation HTBaseViewController (Notification)

- (void)sendNotification:(NSInteger)notification {
    [self sendNotification:notification withData:nil];
}

- (void)sendNotification:(NSInteger)notification withData:(id)data {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:notification] forKey:HTNotificationNumberKey];
    if (data) {
        [dictionary setObject:data forKey:HTNotificationDataKey];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshRequired object:dictionary];
}

- (void)didReceiveNotification:(NSInteger)notification withData:(id)data {
    
}

- (BOOL)containsNotification:(NSInteger)notification {
    NSNumber *number = [NSNumber numberWithInteger:notification];
    return [_refreshTypes containsObject:number];
}

@end

@implementation UIViewController (Helper)

- (void)setInteractivePopGestureEnabled:(BOOL)enabled {
    if (self.navigationController && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = enabled;
    }
}

@end
