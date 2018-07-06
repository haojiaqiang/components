//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UILabel+Attributes.h"
#import "NSString+Utilities.h"

@implementation UILabel (Attributes)

-(void) setPartString:(NSString *) str  attributes:(NSDictionary *) attrs{
    
    //NSRange range = [self.text rangeOfString:str];
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    if (attributedString == nil) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    NSArray* rangeArray = [self.text rangesArrayOfString:str];
    for (NSValue* value in rangeArray) {
        NSRange range = value.rangeValue;
        [attributedString setAttributes:attrs range:range];
    }
    
    self.attributedText = attributedString;
}


-(void) addPrefixString:(NSString *) str  attributes:(NSDictionary *) attrs{
    
    self.text  = [NSString stringWithFormat:@"%@%@",str,self.text];
    [self setPartString:str attributes:attrs];
}

-(void) addSuffixString:(NSString *) str  attributes:(NSDictionary *) attrs{
    
    self.text  = [NSString stringWithFormat:@"%@%@",self.text,str];
    [self setPartString:str attributes:attrs];
}

-(void)subString:(NSString *)subString color:(UIColor *)color font:(UIFont *)font lineSpace:(CGFloat)space{
    NSString *title = self.text;
    if (!subString || !title || subString.length==0 || title.length == 0) {
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: title];
    
    NSRange range =[title rangeOfString:subString];
    
    if (range.location != NSNotFound)
    {
        [str addAttribute:NSFontAttributeName value:font range:range];
        [str addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];

        if (space) {
            [paragraphStyle setLineSpacing:space];
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
        }

    }
    
    self.attributedText = str;
}

- (void)setLabelLineSpace:(CGFloat)space{
    
    NSString *title = self.text;
    if (!title || title.length == 0) {
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: title];
    
    if (space) {

        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];

        [paragraphStyle setLineSpacing:space];
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    }
    self.attributedText = str;
}
@end
