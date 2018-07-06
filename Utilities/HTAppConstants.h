//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#ifndef HTAppConstants_h
#define HTAppConstants_h

#define kAdaptFont(fsize, name) [UIFont fontWithName:name size:fsize*kDeviceWidthScaleToiPhone6]
#define kAppAdaptFont(size) [UIFont systemFontOfSize:size*kDeviceWidthScaleToiPhone6]
#define kAppAdaptFontBold(size) [UIFont boldSystemFontOfSize:size*kDeviceWidthScaleToiPhone6]

#define kAppAdaptHeight(height) (((NSInteger)((height) * kDeviceWidthScaleToiPhone6 * kAppScale)) / kAppScale)
#define kAppAdaptWidth(width) (((NSInteger)((width) * kDeviceWidthScaleToiPhone6 * kAppScale)) / kAppScale)

#define kAppAdaptDeviceHeight(height) (((NSInteger)((height) * kAppScale)) / kAppScale)
#define kAppAdaptDeviceWidth(width) (((NSInteger)((width) * kAppScale)) / kAppScale)

#define kAppSepratorLineHeight (1.0 / kAppScale)

#endif
