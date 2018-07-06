//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, HTVideoPlayerStatus) {
    HTVideoPlayerStatusNone = 0, // Uninitialized
    HTVideoPlayerStatusPlaying = 1,
    HTVideoPlayerStatusPaused = 2,
    HTVideoPlayerStatusStopped = 3,
    HTVideoPlayerStatusStalled = 4,
};

@protocol HTVideoPlayerDelegate;

@interface HTVideoPlayer : NSObject

@property (nonatomic, strong, readonly) AVPlayer *player;

+ (HTVideoPlayer *)sharedPlayer;

- (void)playVideoWithUrl:(NSURL *)videoUrl delegate:(id<HTVideoPlayerDelegate>)delegate;

- (void)play;

- (void)pause;

- (void)stop;

- (void)free;

@end

@protocol HTVideoPlayerDelegate <NSObject>

@optional
- (void)player:(HTVideoPlayer *)player didStartPlayingWithLayer:(AVPlayerLayer *)layer;

- (void)player:(HTVideoPlayer *)player statusDidChange:(HTVideoPlayerStatus)status;

- (void)player:(HTVideoPlayer *)player timeDidUpdate:(CMTime)currentTime endTime:(CMTime)endTime;

- (void)player:(HTVideoPlayer *)player durationDidFetche:(NSTimeInterval)duration;

- (void)player:(HTVideoPlayer *)player downloadProgressDidUpdate:(CGFloat)progress;

- (void)playerFailedToDownloadVideo:(HTVideoPlayer *)player;

- (void)playerWirelessRouteActiveDidChange:(HTVideoPlayer *)player;

@end
