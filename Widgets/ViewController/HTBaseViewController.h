//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTRequest.h"
#import  "HTResponse.h"
#import "HTAlert.h"
#import "HTView.h"

typedef enum{
    HTReloadRemoteTypeViewDidAppear,
    HTReloadRemoteTypeViewWillAppear,
}HTReloadRemoteType;

typedef NS_ENUM(NSUInteger, ShowWarningViewType) {
    ShowWarningViewTypeTop,
    ShowWarningViewTypeMiddle,
    ShowWarningViewTypeBottom,
};

@interface HTBaseViewController : UIViewController
{
    BOOL _autorotate;
    UIInterfaceOrientationMask _orientationMask;
    UIInterfaceOrientation _preferredOrientation;
    BOOL _interactivePopGestureEnabled;
    BOOL _shakingEnabled;
    BOOL _isRequestEverSuccessed;
}
@property (nonatomic, assign) HTReloadRemoteType reloadRemoteType;
@property (nonatomic, assign, readonly) CGFloat topLayoutGuideHeight;
@property (nonatomic, assign, readonly) CGFloat bottomLayoutGuideHeight;
@property (nonatomic, assign, readonly) CGFloat layoutGuideHeight;
@property (nonatomic, assign, readwrite, setter = setAutorotate:, getter = isAutorotate) BOOL autorotate;
@property (nonatomic, assign) BOOL shakingEnabled;
- (void) setOrientationMask:(UIInterfaceOrientationMask) orientationMask;
- (void) setPreferredOrientation:(UIInterfaceOrientation) preferredOrientation;
- (void) setInteractivePopGestureRecognizerEnabled:(BOOL) enabled;

//NeHTork Related Interfaces
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

- (UIImage*) screenShot;

- (void) post:(HTRequest*)request forResponseClass:(Class)clazz onSuccess:(void (^)(HTResponse *response)) success onFailure: (void (^)(NSError* error)) failure;
- (void) post:(HTRequest*)request forResponseClass:(Class)clazz onSuccess:(void (^)(HTResponse *response)) success onFailure: (void (^)(NSError* error)) failure onRetry: (void (^)()) onRetry;

- (void) handleErrorResponse:(id) responseData;
- (void) startLoadingViewWithMessage: (NSString*) loadingMessage;
- (void) stopLoadingView;
- (void) stopLoadingView:(BOOL) animated;
- (void) rightNavigationItemWithSpacing:(UIBarButtonSystemItem) systemItem target:(id) target action:(SEL) sel;

- (void) stopRefreshing:(UIScrollView*) scrollView refresh:(BOOL) refresh pulling:(BOOL) pulling;

- (void) appBecomeActive:(NSNotification*) notification;
- (void) appWillResignActive:(NSNotification*) notification;

//Create retry view
- (void) createRetryViewWithCompletion:(void(^)(void)) completion;
- (void) createRetryViewWithMessage:(NSString*) message onCompletion:(void(^)(void)) completion;
- (void) removeRetryView;
- (void) layoutRetryViewAnimate:(BOOL) animated;

// add default backgroundView when have no data
- (void)addNoDataViewWithImageName:(NSString *)imageName
                             title:(NSString *)title;

- (void)addNoDataViewWithImageName:(NSString *)imageName
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle;

- (void)addNoDataViewWithImageName:(NSString *)imageName
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle
                          btnTitle:(NSString *)btnTitle
                         ClikOnBtn:(void (^)())completion;

- (void)addNoDataViewWithImageName:(NSString *)imageName
                             title:(NSString *)title
                          subTitle:(NSString *)subTitle
                          btnTitle:(NSString *)btnTitle
                     btnTitleColor:(UIColor *)btnTitleColor
                btnBackgroundColor:(UIColor *)btnBackgroundColor
                         ClikOnBtn:(void (^)())completion;

- (void)addNoDataViewToView:(UIView *)view
         moveVerticalOffset:(CGFloat)offset
              WithImageName:(NSString *)imageName
                      title:(NSString *)title
                   subTitle:(NSString *)subTitle
                   btnTitle:(NSString *)btnTitle
                  ClikOnBtn:(void (^)())completion;

- (void)removeNoDataViewFromeSuperView;

// add default backgroundView when request error
- (void)addRequestErrorViewWithRetry:(void (^)())complition;

- (void)addRequestErrorViewToView:(UIView *)view
                       moveOffset:(CGFloat)offset
                        WithRetry:(void (^)())complition;

- (void)addRequestErrorViewToView:(UIView *)view
                       moveOffset:(CGFloat)offset frame:(CGRect)frame
                        WithRetry:(void (^)())complition;

- (void)removeRequestErrorViewFromeSuperView;

- (UIControl*) buttonItemForBarButton:(UIBarButtonItem*) barButtonItem;

@end

@interface UIViewController (Message)

- (void) showWarningView:(NSString *)warningMessage;
- (void) showWarningViewWithDisplayDelay:(NSString *)warningMessage;
- (void) showWarningView:(NSString *)warningMessage autoDisplayAfter:(double)displayDelay;
- (void) showWarningView:(NSString *)warningMessage onCompletion:(void(^)())completion;
- (void) showWarningView:(NSString *)warningMessage autoCloseAfter:(NSInteger) secondsDelay;
- (void) showWarningView:(NSString *)warningMessage autoCloseAfter:(double) secondsDelay onCompletion:(void(^)())completion;

- (void) showWarningViewOnBottom:(NSString *)warningMessage;

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type;

- (void) showWarningViewWithDisplayDelay:(NSString *)warningMessage
                                    type:(ShowWarningViewType)type;

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
        autoDisplayAfter:(double)displayDelay;

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
            onCompletion:(void(^)())completion;

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
          autoCloseAfter:(NSInteger) secondsDelay;

- (void) showWarningView:(NSString *)warningMessage
                    type:(ShowWarningViewType)type
          autoCloseAfter:(double)secondsDelay
            onCompletion:(void(^)())completion;

- (HTView *)createWarningView:(NSString *)warningMessage;

//Show Alert Message
- (void) showAlertMessage:(NSString*) message;
- (void) showAlertMessage:(NSString*) message withTitle:(NSString*) title;
- (void) showAlertMessage:(NSString*) message onCompletion:(HTAlertViewCompletionBlock)completion;
- (void) showAlertMessage:(NSString*) message withTitle:(NSString*) title onCompletion:(HTAlertViewCompletionBlock)completion;
- (void) showConfirmMessage:(NSString*) message withTitle:(NSString*) title onCompletion:(HTAlertViewCompletionBlock)completion;
- (void) showConfirmMessage:(NSString*) message withTitle:(NSString*) title cancelButtonTitle:(NSString*) cancelButtonTitle okButtonTitle:(NSString*) okButtonTitle onCompletion:(HTAlertViewCompletionBlock)completion;

//Show action sheet
- (void) showActionSheetOnCompletion:(HTActionSheetCompletionBlock)completion withTitle:(NSString *)title cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*) destructiveButtonTitle otherButtonTitles:(NSString*) otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void) showActionSheetOnCompletion:(HTActionSheetCompletionBlock)completion withTitle:(NSString *)title cancelButtonTitle:(NSString*) cancelButtonTitle destructiveButtonTitle:(NSString*) destructiveButtonTitle otherButtonTitlesInArray:(NSArray*) otherButtonTitles;
- (void)setNavgationBarTitleDefaultColor;
@end

@interface HTBaseViewController (Notification)

- (void)sendNotification:(NSInteger)notification;

- (void)sendNotification:(NSInteger)notification withData:(id)data;

- (void)didReceiveNotification:(NSInteger)notification withData:(id)data;

- (BOOL)containsNotification:(NSInteger)notification;

@end

@interface UIViewController (Helper)

- (void)setInteractivePopGestureEnabled:(BOOL)enabled;

@end
