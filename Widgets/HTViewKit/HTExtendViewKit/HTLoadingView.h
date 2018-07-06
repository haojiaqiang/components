//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTPopoverView.h"
#import "HTImageView.h"

@interface HTLoadingView : HTPopoverView

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) HTImageView *gifImageView;

- (void) stopLoading;

@end
