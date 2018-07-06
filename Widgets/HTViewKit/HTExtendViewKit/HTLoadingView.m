//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLoadingView.h"
#import "Constants.h"

@interface LFKeyframeAnimation : CAKeyframeAnimation
@property (nonatomic, assign) NSInteger tag;
@end

@implementation LFKeyframeAnimation
@end

@interface LFBasicAnimation : CABasicAnimation
@property (nonatomic, assign) NSInteger tag;
@end

@implementation LFBasicAnimation
@end

@implementation HTLoadingView
{
    HTView *_backView;
    HTImageView *_imageView;
    int _index;
}

- (void) removeFromSuperview {
    [super removeFromSuperview];
    [self stopLoading];
}

- (void)loadSubviews {
    [super loadSubviews];
    
    self.direction = HTPopoverViewDirectionFromCenter;
    self.closeDirection = HTPopoverViewDirectionFromCenter;
    self.maskColor = kRGBA(0, 0, 0, .05);
    
    self.closable = NO;
    
    CGRect r = CGRectMake(0, 0, 110, 110);
    _imageView = [[HTImageView alloc] initWithFrame:r];
    [self addSubview:_imageView];
    
    __weak id weakSelf = self;
    self.popviewDidShow = ^(HTPopoverView *popoverView) {
        [weakSelf startLoading];
    };
}

- (void) setMessage:(NSString *)message {
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self layout];
}

- (void) layout{
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _imageView.contentMode = UIViewContentModeCenter;
    if (_backView) {
        _backView.center = _imageView.center;
    }
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isKindOfClass:[LFKeyframeAnimation class]]) {
        if (_index>=0) {
            _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d", (int)(_index%4+2)]];
            _index++;
            if (_index%4==0) {
                [_imageView stopAnimating];
                [_imageView.layer removeAllAnimations];
                [self startAnimations];
            }
        }
    }
}

- (void) animationDidStart:(CAAnimation *)anim {
    if ([anim isKindOfClass:[LFKeyframeAnimation class]]) {
        _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d", (int)(_index%4+1)]];
    }
}

- (void) startLoading{
    //TO-DO Hayato [ImageView setImage]
//    _imageView.image = [LFApplication sharedApplication].loadingImage;
    
    
    //[self startAnimations];
}

- (void) startAnimations {
    if (!_backView) {
        CGRect r = _imageView.frame;
        _backView = [[HTView alloc] initWithFrame:r andRadius:r.size.width/2];
        _backView.backgroundColor = kWhiteColor;
        [self insertSubview:_backView belowSubview:_imageView];
    }

    CGFloat duration = 0.5;
    for (NSInteger i=0; i<5; ++i) {
        LFKeyframeAnimation *rotateAnimation = [LFKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:M_PI_2*i+M_PI_4/3],
                                  [NSNumber numberWithFloat:M_PI_2*(i+1)+M_PI_4/3],
                                  nil];
        rotateAnimation.duration = duration;
        rotateAnimation.beginTime = CACurrentMediaTime()+duration*i;
        if (i<4) {
            rotateAnimation.delegate = self;
        }
        rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        rotateAnimation.tag = i;
        [_imageView.layer addAnimation:rotateAnimation forKey:[NSString stringWithFormat:@"Rotation%d", (int)i]];
        
        for (NSInteger j=0; j<2; ++j) {
            LFBasicAnimation *opacityAnimation = [LFBasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.tag = j<<i;
            opacityAnimation.fromValue = [NSNumber numberWithFloat:j&1];
            opacityAnimation.toValue = [NSNumber numberWithFloat:j^1];
            opacityAnimation.duration = duration*2.0/5.0;
            opacityAnimation.beginTime = CACurrentMediaTime()+(j*3.0/5.0+i)*duration;
            [_imageView.layer addAnimation:opacityAnimation forKey:[NSString stringWithFormat:@"Opacity%d%d", (int)i, (int)j]];
        }
    }
}

- (void) stopLoading {
    _index = -1;
    [_imageView stopAnimating];
    [_imageView.layer removeAllAnimations];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
