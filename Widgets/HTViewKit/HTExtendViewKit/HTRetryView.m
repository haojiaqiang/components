//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//


#import "HTRetryView.h"
#import "HTImageView.h"
#import "HTLabel.h"
#import "Constants.h"

@implementation HTRetryView
{
    HTImageView *_imageView, *_coverView;
    HTLabel *_retryLabel;
    UIActivityIndicatorView *_loadingView;
}

- (void) removeFromSuperview{
    self.onRetry = nil;
    [super removeFromSuperview];
}

- (void) dealloc{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id) init{
    self = [super init];
    if(self){
        [self initUI];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andRadius:(CGFloat)radius{
    self = [super initWithFrame:frame andRadius:radius];
    if(self){
        [self initUI];
    }
    return self;
}

- (void) initUI{
    _imageView = [[HTImageView alloc] initWithImage:[UIImage imageNamed:@"default-icon"]];
    _imageView.backgroundColor = kClearColor;
    [self addSubview:_imageView];
    _retryLabel = [[HTLabel alloc] init];
    _retryLabel.textAlignment = NSTextAlignmentCenter;
    _retryLabel.font = kAppFont(12);
    _retryLabel.textColor = kRGB(55, 55, 55);
    _retryLabel.numberOfLines = 3;
    _retryLabel.text = kStr(@"Tap to reload");
    [self addSubview:_retryLabel];
    
    _coverView = [[HTImageView alloc] init];
    //[_coverView setImage:[UIImage imageNamed:@""]];
    [self addSubview:_coverView];
    _coverView.hidden = YES;
    
    [self layout:self.radius];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:_loadingView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped:)];
    [self addGestureRecognizer:tapGesture];
}

- (void) handleTapped:(UITapGestureRecognizer*) recognizer{
    if(recognizer.state==UIGestureRecognizerStateEnded){
        if(self.onRetry){
            self.onRetry();
        }
    }
}

- (void) setRadius:(CGFloat)radius{
    [super setRadius:radius];
    [self layout:radius];
}

- (void) layout:(CGFloat) radius{
    _imageView.frame = CGRectMake(radius, radius, self.frame.size.width-radius*2, self.frame.size.width-radius*2);
    _coverView.frame = _imageView.frame;
    _retryLabel.frame = CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y+_imageView.frame.size.height, self.frame.size.width-radius*2, self.frame.size.height-_imageView.frame.origin.y-_imageView.frame.size.height);
    _loadingView.center = _imageView.center;
}

- (void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layout:_radius];
}

- (void) setIconBGColor:(UIColor *)iconBGColor{
    _iconBGColor = iconBGColor;
    _imageView.backgroundColor = iconBGColor;
}

- (void) setTitleBGColor:(UIColor *)titleBGColor{
    _titleBGColor = titleBGColor;
    _retryLabel.backgroundColor = titleBGColor;
}

- (UIColor*) getIcnBGColor{
    return _iconBGColor;
}

- (UIColor*) getTitleBGColor{
    return _titleBGColor;
}

- (void) setRetryMessage:(NSString *)retryMessage{
    _retryMessage = retryMessage;
    _retryLabel.text = retryMessage;
}

- (NSString*) retryMessage{
    return _retryMessage;
}

@end
