//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, HTAudioPlayerStatus){
    HTAudioPlayerStatusNone,
    HTAudioPlayerStatusPlaying,
    HTAudioPlayerStatusPaused,
    HTAudioPlayerStatusStopped
};

@protocol HTAudioPlayerDelegate;

@interface HTAudioPlayer : NSObject

@property (nonatomic, assign) BOOL meteringEnabled;

@property (nonatomic, assign, readonly) NSTimeInterval duration;

@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

@property (nonatomic, strong, readonly) AVAudioPlayer *player;

+ (HTAudioPlayer *)sharedPlayer;

- (void)playAudioWithURL:(NSURL *)audioURL;

- (void)playAudioWithURL:(NSURL *)audioURL delegate:(id<HTAudioPlayerDelegate>)delegate;

- (void)playAudioWithData:(NSData *)audioData;

- (void)playAudioWithData:(NSData *)audioData delegate:(id<HTAudioPlayerDelegate>)delegate;

- (void)play;

- (void)pause;

- (void)stop;

@end

@protocol HTAudioPlayerDelegate <NSObject>

@optional

- (void)player:(HTAudioPlayer *)player currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime soundPower:(CGFloat)soundPower;

- (void)player:(HTAudioPlayer *)player statusDidChnage:(HTAudioPlayerStatus)status;

@end
