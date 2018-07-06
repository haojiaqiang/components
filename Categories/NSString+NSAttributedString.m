//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "NSString+NSAttributedString.h"

@implementation NSString (NSAttributedString)

/*********************************************************************
 *  设置段落样式
 *
 *  @param lineSpacing 行高
 *  @param textcolor   字体颜色
 *  @param font        字体
 *
 *  @return 富文本
 ********************************************************************/
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font {
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.paragraphSpacing = 0;
    
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@0};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    return attriStr;
}


/*********************************************************************
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 ********************************************************************/
-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

/********************************************************************
 *  返回包含关键字的富文本编辑
 *
 *  @param lineSpacing 行高
 *  @param textcolor   字体颜色
 *  @param font        字体
 *  @param KeyColor    关键字字体颜色
 *  @param KeyFont     关键字字体
 *  @param KeyWords    关键字数组
 *
 *  @return  富文本
 *******************************************************************/
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font
                                    withKeyTextColor:(UIColor *)KeyColor
                                             keyFont:(UIFont *)KeyFont
                                            keyWords:(NSArray *)KeyWords {
    
    NSAttributedString * AttributeString = [self stringWithParagraphlineSpeace:lineSpacing textColor:textcolor textFont:font compated:^(NSMutableAttributedString *attriStr) {
        NSDictionary * KeyattriBute = @{NSForegroundColorAttributeName:KeyColor,NSFontAttributeName:KeyFont};
        for (NSString * item in KeyWords) {
            NSRange  range = [self rangeOfString:item options:(NSCaseInsensitiveSearch)];
            [attriStr addAttributes:KeyattriBute range:range];
        }
    }];
    return AttributeString;
}

/********************************************************************
 *  基本校验方法
 *
 *  @param lineSpacing 行高
 *  @param textcolor   字体颜色
 *  @param font        字体
 *  @param KeyColor    关键字字体颜色
 *  @param KeyFont     关键字字体
 *  @param KeyWords    关键字字符数组
 *
 *  @return  富文本
 ********************************************************************/
-(NSAttributedString *)stringWithParagraphlineSpeace:(CGFloat)lineSpacing
                                           textColor:(UIColor *)textcolor
                                            textFont:(UIFont *)font
                                            compated:(void(^)(NSMutableAttributedString * attriStr))compalted
{
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    // NSKernAttributeName字体间距
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@0.f};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:textcolor,NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, self.length)];
    if (compalted) {
        compalted(attriStr);
    }
    return attriStr;
}

@end
