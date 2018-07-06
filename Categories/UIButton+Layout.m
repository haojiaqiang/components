//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UIButton+Layout.h"

@implementation UIButton (Layout)

- (void)centerImageAndTitleWithSpace:(float)spacing {
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle {
    [self centerImageAndTitleWithSpace:0];
}

- (void)makeImageRightWithSpace:(float)space {
    CGFloat imageWidth = self.imageView.bounds.size.width;
    CGFloat titleWidth = self.titleLabel.bounds.size.width ;//[self.titleLabel.text textSizeForOneLineWithFont:self.titleLabel.font].width;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space), 0, imageWidth+space)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleWidth+space, 0, -(titleWidth+space))];
}

- (void)makeImageRight {
    [self makeImageRightWithSpace:0];
}

- (void)resetButtonLayout {
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

@end
