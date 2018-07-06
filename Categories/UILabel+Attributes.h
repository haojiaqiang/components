//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Attributes)

-(void) setPartString:(NSString *) str  attributes:(NSDictionary *) attrs;
-(void) addPrefixString:(NSString *) str  attributes:(NSDictionary *) attrs;
-(void) addSuffixString:(NSString *) str  attributes:(NSDictionary *) attrs;
-(void)subString:(NSString *)subString color:(UIColor *)color font:(UIFont *)font lineSpace:(CGFloat)space;
- (void)setLabelLineSpace:(CGFloat)space;
@end
