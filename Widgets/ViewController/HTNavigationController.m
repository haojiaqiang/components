//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTNavigationController.h"

@interface HTNavigationController ()

@end

@implementation HTNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _autorotate = NO;
        _orientationMask = UIInterfaceOrientationMaskAll;
        _preferredOrientation = UIInterfaceOrientationPortrait;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setAutorotate:(BOOL)autorotate{
    _autorotate = autorotate;
}

- (BOOL) isAutorotate{
    return _autorotate;
}

- (void) setOrientationMask:(UIInterfaceOrientationMask)orientationMask{
    _orientationMask = orientationMask;
}

- (void) setPreferredOrientation:(UIInterfaceOrientation)preferredOrientation{
    _preferredOrientation = preferredOrientation;
}

- (BOOL)shouldAutorotate{
    return  _autorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return _orientationMask;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return _preferredOrientation;
}

- (void) setInteractivePopGestureRecognizerEnabled:(BOOL)enabled{
   if( [UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = enabled;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
