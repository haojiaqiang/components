//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLabel.h"

@implementation HTLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(CGRect)boundingRectWithInitSize:(CGSize)size{
    
    self.lineBreakMode=NSLineBreakByWordWrapping;
    
    CGRect rect=[self.text boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil];
    
    return rect;
}

@end
