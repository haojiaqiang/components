//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#ifndef Mars_HTAppConstants_h
#define Mars_HTAppConstants_h

#define HTBaseViewBackgroundColor   kHRGB(0xf5f5f5)
#define HTAppBaseGrayColor      kHRGB(0x4e4e4e)
#define HTAppBaseColor      kHRGB(0x4081d6)
#define HTAppBaseColorA(alpha)      kHRGBA(0x4081d6, alpha)
#define HTAppNavColor       kRGB(105, 105, 105)
#define HTAppRedColor       kRGB(255, 90, 95)
#define HTAppExtendColor    kHRGB(0xff8b00)
#define HTAppPlaceholderColor kHRGB(0x999999)

#define HTAppBaseButtonTitleColor      kHRGB(0x92A7C3)

#define HTHostBaseViewBackgroundColor   kHRGB(0xf5f5f5)
#define HTAppHostBaseColor  kHRGB(0x4081d6)

#define kAdaptFont(fsize, name) [UIFont fontWithName:name size:fsize*kDeviceWidthScaleToiPhone6]
#define kAppAdaptFont(size) [UIFont systemFontOfSize:size*kDeviceWidthScaleToiPhone6]
#define kAppAdaptFontBold(size) [UIFont boldSystemFontOfSize:size*kDeviceWidthScaleToiPhone6]

#define kAppAdaptHeight(height) (((NSInteger)((height) * kDeviceWidthScaleToiPhone6 * kAppScale)) / kAppScale)
#define kAppAdaptWidth(width) (((NSInteger)((width) * kDeviceWidthScaleToiPhone6 * kAppScale)) / kAppScale)

#define kScreenMarginWidth(MarginWith) ((MarginWith) * ([[HTScreenAdaptManager  sharedManager] marginWidth:1.0]))
#define kScreenMarginHeight(MarginHeight)    ((MarginHeight) * ([[HTScreenAdaptManager  sharedManager] marginHeight:1.0]))
#define kScreenWidth(Width)  ((Width) * ([[HTScreenAdaptManager sharedManager] width:1.0]))
#define kScreenHeight(Height) ((Height) * ([[HTScreenAdaptManager  sharedManager] height:1.0]))

#define kAppAdaptDeviceHeight(height) (((NSInteger)((height) * kAppScale)) / kAppScale)
#define kAppAdaptDeviceWidth(width) (((NSInteger)((width) * kAppScale)) / kAppScale)

#define kAppSepratorLineHeight (1.0 / kAppScale)

#define kSSKeychainServiceName    @"WKZFKeychainServiceName";
#define kSSKeychainAccountName    @"WKZFKeychainAccountName";
#define kSSKeychainPassword       @"WKZFKeychainPassword";
#define kSSKeychainLabel          @"WKZFKeychainLabel";

#define ALL_MARGIN              10
#define ALL_MARGIN_5            5
#define ALL_MARGIN_10           10
#define ALL_MARGIN_15           15
#define kAllAdaptMargin         kAppAdaptWidth(15)

#define ALL_FONT_SIZE           kAppFont(14)
#define ALL_TITLE_SIZE          kAppFont(16)
#define ALL_DETAIL_SIZE         kAppFont(12)

#define ALL_CORNERRADIUS        4
#define ALL_CORNERRADIUS_4      4
#define ALL_CORNERRADIUS_6      6
#define ALL_CORNERRADIUS_8      8

#define ALL_BORDER_COLOR        kHRGB(0xe4e4e4)

#define ALL_LINE_COLOR          kHRGB(0xe4e4e4)

#define kAppURL @""

#define kLocalSettingsKeySearchHistory(uniqueID)            ([NSString stringWithFormat:@"kLocalSettingsKeySearchHistory3.2_%@", uniqueID])
#define kLocalSettingsKeyGroupDescriptionHidden(uniqueID)            ([NSString stringWithFormat:@"kLocalSettingsKeyGroupDescriptionHidden%@", uniqueID])
#define kLocalSettingsKeyHasChatHistory(agentId,cityId)     [NSString stringWithFormat:@"kLocalSettingsKeyHasChatHistory_%d_%d", agentId,cityId]
#define kLocalSettingsKeyHostReleaseHouse(userId)  ([NSString stringWithFormat:@"kLocalSettingsKeyHostReleaseHouse%lld", userId])
#define kLocalSettingsKeyLandlordSendMessageHistory(agentIMId, guestId, houseId)     ([NSString stringWithFormat:@"kLocalSettingsKeyLandlordSendMessageHistory_%@_%d_%@", agentIMId, guestId, houseId])
#define kLocalSettingsKeyDeletedChatConversationHistory(userId)            ([NSString stringWithFormat:@"kLocalSettingsKeyDeletedChatConversationHistory_%d", userId])

#endif
