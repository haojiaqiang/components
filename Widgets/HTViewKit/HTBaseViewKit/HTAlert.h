//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^HTAlertControllerAlertCompletionBlock)(NSInteger buttonIndex, UIAlertController *alertController);

typedef void(^HTAlertViewCompletionBlock)(NSInteger buttonIndex, UIAlertView *alertView);

typedef void(^HTAlertControllerActionSheetCompletionBlock)(NSInteger buttonIndex, UIAlertController *alertController);

typedef void(^HTActionSheetCompletionBlock)(NSInteger buttonIndex, UIActionSheet *actionSheet);

@interface HTAlert : NSObject
{
    UIAlertView *_alertView;
    UIActionSheet *_actionSheet;
}

+ (HTAlert*) sharedAlert;

// Wanring Actions
- (void)showWarningMessage:(NSString *)message;

- (void)showWarningMessage:(NSString *)message autoCloseAfter:(double)duration;

- (void)showWarningMessageInView:(UIView *)view message:(NSString *)message;

- (void)showWarningMessageInView:(UIView *)view message:(NSString *)message onCompletion:(void(^)())completion;

- (void)showWarningMessageInView:(UIView *)view message:(NSString *)message autoCloseAfter:(double) duration;

- (void)showWarningMessageInView:(UIView *)view message:(NSString *)message autoCloseAfter:(double) duration onCompletion:(void(^)())completion;

// Notification View Actions
- (void)showNotificationMessage:(NSString *)message;

- (void)showNotificationMessage:(NSString *)message onCompletion:(void(^)())completion;

// Alert Actions
- (void)showAlertMessageInViewController:(UIViewController *)viewController message:(NSString *)message;

- (void)showAlertMessageInViewController:(UIViewController *)viewController message:(NSString *)message withTitle:(NSString *)title;

- (void)showAlertMessageInViewController:(UIViewController *)viewController message:(NSString *)message onCompletion:(HTAlertControllerAlertCompletionBlock)completion;

- (void)showAlertMessageInViewController:(UIViewController *)viewController
                                 message:(NSString *)message
                               withTitle:(NSString *)title
                            onCompletion:(HTAlertControllerAlertCompletionBlock)completion;

- (void)showConfirmMessageInViewController:(UIViewController *)viewController
                                   message:(NSString *)message
                                 withTitle:(NSString *)title
                              onCompletion:(HTAlertControllerAlertCompletionBlock)completion;

- (void)showConfirmMessageInViewController:(UIViewController *)viewController
                                   message:(NSString *)message
                                 withTitle:(NSString *)title
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                             okButtonTitle:(NSString *)okButtonTitle
                              onCompletion:(HTAlertControllerAlertCompletionBlock)completion;

// Action Sheet Actions
- (void)showActionSheetInViewController:(UIViewController *)viewController
                             completion:(HTAlertControllerActionSheetCompletionBlock)completion
                              withTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)showActionSheetInViewController:(UIViewController *)viewController
                             completion:(HTAlertControllerActionSheetCompletionBlock)completion
                              withTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitlesInArray:(NSArray *)otherButtonTitles;

@end

@interface HTAlert (AlertView)

// Alert view actions
- (void) showAlertMessage:(NSString*) message;

- (void) showAlertMessage:(NSString*) message withTitle:(NSString*) title;

- (void) showAlertMessage:(NSString*) message onCompletion:(HTAlertViewCompletionBlock)completion;

- (void) showAlertMessage:(NSString*) message
                withTitle:(NSString*) title
             onCompletion:(HTAlertViewCompletionBlock)completion;

- (void) showConfirmMessage:(NSString*) message
                  withTitle:(NSString*) title
               onCompletion:(HTAlertViewCompletionBlock)completion;

- (void) showConfirmMessage:(NSString*) message
                  withTitle:(NSString*) title
          cancelButtonTitle:(NSString*) cancelButtonTitle
              okButtonTitle:(NSString*) okButtonTitle
               onCompletion:(HTAlertViewCompletionBlock)completion;

@end

@interface HTAlert (ActionSheet)

// Action sheet
- (void) showActionSheetInView:(UIView*) view
                    completion:(HTActionSheetCompletionBlock)completion
                     withTitle:(NSString *)title
             cancelButtonTitle:(NSString*) cancelButtonTitle
        destructiveButtonTitle:(NSString*) destructiveButtonTitle
             otherButtonTitles:(NSString*) otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void) showActionSheetInView:(UIView*) view
                    completion:(HTActionSheetCompletionBlock)completion
                     withTitle:(NSString *)title
             cancelButtonTitle:(NSString*) cancelButtonTitle
        destructiveButtonTitle:(NSString*) destructiveButtonTitle
      otherButtonTitlesInArray:(NSArray*) otherButtonTitles;

@end

@interface HTAlert (LoadingView)

- (void)showLoadingViewWithMessage:(NSString *)message inView:(UIView *)view;

- (void)removeLoadingView;

@end
