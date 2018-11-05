//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTVideoPlayer.h"
#import <MediaPlayer/MPVolumeView.h>
#import "HTAppConstants.h"

@implementation HTVideoPlayer
{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    
    id _timeObserver;
    double _duration; // Video duration
    HTVideoPlayerStatus _status;
    
    __weak id<HTVideoPlayerDelegate> _delegate;
}

static HTVideoPlayer *_sharedInstance = nil;

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedPlayer {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (void)free {
    [self unregisterNotifications];
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
    }
    [self stop];
}

- (void)playVideoWithUrl:(NSURL *)videoUrl delegate:(id<HTVideoPlayerDelegate>)delegate {

    [self stop];
    
    if (!videoUrl) {
        return;
    }
    
    _delegate = delegate;
    
    if (!_player) {
        _playerItem = [[AVPlayerItem alloc] initWithURL:videoUrl];
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        
        // Enable external screen, such as AirPlay, etc.
        _player.usesExternalPlaybackWhileExternalScreenIsActive = YES;
        
        CMTime tm = CMTimeMakeWithSeconds(0.2, NSEC_PER_SEC);
        __weak id weakSelf = self;
        _timeObserver = [_player addPeriodicTimeObserverForInterval:tm queue:NULL usingBlock:^(CMTime time) {
            [weakSelf updateProgress:time];
        }];
        
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [self registerNotifications];
    }
    
    [_player play];
    
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    _status = HTVideoPlayerStatusPlaying;

    if (_delegate && [_delegate respondsToSelector:@selector(player:didStartPlayingWithLayer:)]) {
        [_delegate player:self didStartPlayingWithLayer:_playerLayer];
    }
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemPlaybackStalled:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemFailedToPlayToEndTime:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wirelessRouteActiveDidChange:)
                                                 name:MPVolumeViewWirelessRouteActiveDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wirelessRoutesAvailableDidChange:)
                                                 name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification
                                               object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
}

- (void)stop {
    if (_playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        [_playerItem removeObserver:self forKeyPath:@"status" context:nil];
        
        [_player removeTimeObserver:_timeObserver];
        [_player pause];
        [_playerLayer removeFromSuperlayer];
    }
    _duration = 0;
    _playerItem = nil;
    _playerLayer = nil;
    _player = nil;
    
    _status = HTVideoPlayerStatusStopped;

    if (_delegate && [_delegate respondsToSelector:@selector(player:statusDidChange:)]) {
        [_delegate player:self statusDidChange:HTVideoPlayerStatusStopped];
    }
}

- (void)play {
    if (_player && _player.currentItem && _player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [_player play];
        
        _status = HTVideoPlayerStatusPlaying;
        
        if (_delegate && [_delegate respondsToSelector:@selector(player:statusDidChange:)]) {
            [_delegate player:self statusDidChange:HTVideoPlayerStatusPlaying];
        }
    }
}

- (void)pause {
    if (_player && _player.currentItem && _player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [_player pause];
        
        _status = HTVideoPlayerStatusPaused;
        
        if (_delegate && [_delegate respondsToSelector:@selector(player:statusDidChange:)]) {
            [_delegate player:self statusDidChange:HTVideoPlayerStatusPaused];
        }
    }
}

- (void)updateProgress:(CMTime)time {
    CMTime endTime = CMTimeConvertScale (_player.currentItem.asset.duration, _player.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
    
    if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(player:timeDidUpdate:endTime:)]) {
            [_delegate player:self timeDidUpdate:_player.currentTime endTime:endTime];
        }
    }
}

- (void)playerItemFailedToPlayToEndTime:(NSNotification *)notification {
    _status = HTVideoPlayerStatusPaused;
    
    if (_delegate && [_delegate respondsToSelector:@selector(player:statusDidChange:)]) {
        [_delegate player:self statusDidChange:HTVideoPlayerStatusPaused];
    }
}

- (void)playerItemPlaybackStalled:(NSNotification *)notification {
    _status = HTVideoPlayerStatusStalled;

    if (_delegate && [_delegate respondsToSelector:@selector(player:statusDidChange:)]) {
        [_delegate player:self statusDidChange:HTVideoPlayerStatusStalled];
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self stop];
}

// Posted when the wirelessRouteActive property changes.
- (void)wirelessRouteActiveDidChange:(NSNotification *)notification {
    if (_delegate && [_delegate respondsToSelector:@selector(playerWirelessRouteActiveDidChange:)]) {
        [_delegate playerWirelessRouteActiveDidChange:self];
    }
}

// Posted when the wirelessRoutesAvailable property changes.
- (void)wirelessRoutesAvailableDidChange:(NSNotification *)notification {
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"loadedTimeRanges" isEqualToString:keyPath]) {
        NSArray *timeRanges = (NSArray*)[change objectForKey:NSKeyValueChangeNewKey];
        [self performSelectorOnMainThread:@selector(updateVideoAvailable:) withObject:timeRanges waitUntilDone:NO];
    }
    else if ([@"status" isEqualToString:keyPath]) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            CMTime duration = [self playerItemDuration:_player];
            _duration = CMTimeGetSeconds(duration);
            if (_delegate && [_delegate respondsToSelector:@selector(player:durationDidFetche:)]) {
                [_delegate player:self durationDidFetche:_duration];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(player:statusDidChange:)]) {
                [_delegate player:self statusDidChange:HTVideoPlayerStatusPlaying];
            }
        }
        else if (status == AVPlayerItemStatusFailed) {
            if (_delegate && [_delegate respondsToSelector:@selector(playerFailedToDownloadVideo:)]) {
                [_delegate playerFailedToDownloadVideo:self];
            }
        }
        else if (status == AVPlayerItemStatusUnknown) {
            if (_delegate && [_delegate respondsToSelector:@selector(playerFailedToDownloadVideo:)]) {
                [_delegate playerFailedToDownloadVideo:self];
            }
        }
    }
}

- (void)updateVideoAvailable:(NSArray *)timeRanges {
    if (timeRanges && [timeRanges count]) {
        CMTimeRange timeRange = [[timeRanges objectAtIndex:0]CMTimeRangeValue];
        CGFloat smartValue = CMTimeGetSeconds(CMTimeAdd(timeRange.start, timeRange.duration));
        if (_duration > 0) {
            double progress = MIN(smartValue / _duration, 1.0);
            if (_delegate && [_delegate respondsToSelector:@selector(player:downloadProgressDidUpdate:)]) {
                [_delegate player:self downloadProgressDidUpdate:progress];
            }
            
            if (_status == HTVideoPlayerStatusStalled) {
                [self play];
            }
        }
    }
}

- (CMTime)playerItemDuration:(AVPlayer *)player {
    AVPlayerItem *playerItem = [player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        /*
         NOTE:
         Because of the dynamic nature of HTTP Live Streaming Media, the best practice
         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3.
         Prior to iOS 4.3, you would obtain the duration of a player item by fetching
         the value of the duration property of its associated AVAsset object. However,
         note that for HTTP Live Streaming Media the duration of a player item during
         any particular playback session may differ from the duration of its asset. For
         this reason a new key-value observable duration property has been defined on
         AVPlayerItem.
         
         See the AV Foundation Release Notes for iOS 4.3 for more information.
         */
        
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}

@end
