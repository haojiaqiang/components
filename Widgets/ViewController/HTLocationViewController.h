
//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTBaseViewController.h"

@class HTLocation;

@interface HTLocationViewController : HTBaseViewController

- (void) startLocationService;

- (void) handleReverseGeoInfo:(HTLocation *)location;

@end
