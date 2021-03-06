//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CGGeometry.h>

@interface NSString (Utilities)
- (BOOL) contains:(NSString*)string;
- (BOOL) containsCaseInsensitive:(NSString*)string;
- (NSString*) replace:(NSString*) string withString:(NSString*) replace;
- (NSString*) add:(NSString*)string;
- (NSDictionary*) firstAndLastName;
- (BOOL) isValidEmail;
- (BOOL) isValidMobile;
- (BOOL) isValidUserName;
- (BOOL) containsOnlyLetters;
- (BOOL) containsOnlyNumbers;
- (BOOL) containsOnlyNumbersAndLetters;
- (NSString*) safeSubstringToIndex:(NSUInteger)index;
- (NSString*) stringByRemovingPrefix:(NSString*)prefix;
- (NSString*) stringByRemovingPrefixes:(NSArray*)prefixes;
- (BOOL) hasPrefixes:(NSArray*)prefixes;
- (BOOL) hasSufixes:(NSArray*)sufixes;
- (BOOL) isEqualToOneOf:(NSArray*)strings;
- (NSString*) md5;
- (NSString*) telephoneWithReformat;
- (NSString*) trim;
- (NSArray*) splitBy:(NSString*) splitString;
- (NSInteger) getIntegerValue;
- (int) getIntValue;
- (int) getLength;
- (int) getLength2;
- (NSString*) base64:(BOOL) encoding;
+ (NSString*) safeString:(NSString*)str;
+ (BOOL) isNullOrEmpty:(NSString*)str;
+ (BOOL) equals:(NSString*) str1 to:(NSString*) str2;
+ (NSString*) generateRandomString:(int) length;
+ (NSString*) generateRandomString:(int) length fromSource:(NSString*) source;
+ (NSString*) generateRandomPassword:(int) length;
- (NSComparisonResult)caseSensitiveCompare:(NSString *)aString;
- (int)countWord;
- (CGSize)returnSize:(UIFont *)fnt;
- (CGSize)returnSize:(UIFont *)fnt MaxWidth:(CGFloat)maxWidth;
- (CGSize)returnSize:(UIFont *)fnt MaxWidth:(CGFloat)maxWidth lineSpacing:(CGFloat)lineSpacing;
- (CGFloat)widthForContentWithFontSize:(UIFont*)font;
- (int)textLineNumWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;//文字的行数
- (CGSize)textSizeForOneLineWithFont:(UIFont *)font;//文字放在一行时的宽高
- (NSString*)confusedMobileNumber;
- (BOOL)isPureInteger;
- (BOOL)isPureFloat;
- (BOOL)isPureDouble;
- (NSArray*)rangesArrayOfString:(NSString*)str;
- (id)stringToModel:(Class)model;
+ (NSString*)modelToString:(id)model;
@end
