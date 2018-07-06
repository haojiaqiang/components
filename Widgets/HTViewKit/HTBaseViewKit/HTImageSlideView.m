//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTImageSlideView.h"
#import "HTImageView.h"

@interface HTImageSlideViewCellView : HTSlideViewCellView

@end

@implementation HTImageSlideViewCellView
{
    HTImageView *_imageView;
}

- (void)loadSubviews {
    [super loadSubviews];
    
    _imageView = [[HTImageView alloc] initWithFrame:self.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
}

- (void)showWithItemData:(id)data {
    if ([data isKindOfClass:[NSString class]]) {
        [_imageView setImageWithURL:data];
    }
}

@end

@implementation HTImageSlideView

- (void)loadSubviews {
    [super loadSubviews];
    [self setItemViewClass:[HTImageSlideViewCellView class]];
}

@end
