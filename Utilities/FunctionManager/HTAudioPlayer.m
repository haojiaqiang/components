//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTAudioPlayer.h"

@interface HTAudioPlayer (InnerMethods)

- (void)updatePlayerStatus:(HTAudioPlayerStatus)status;

- (void)stopTimer;

- (void)handleTimer:(NSTimer *)timer;

- (void)updateProgress:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration power:(CGFloat)power;

- (void)resetPlayer;

@end

@interface HTAudioPlayer (AudioPlayerDelegate) <AVAudioPlayerDelegate>

@end

@implementation HTAudioPlayer
{
    AVAudioPlayer *_player;
    HTAudioPlayerStatus _status;
    
    __weak id<HTAudioPlayerDelegate> _delegate;
    
    NSTimer *_timer;
    NSTimeInterval _duration;
    NSTimeInterval _currentTime;
    
    NSURL *_audioURL;
    
    NSData *_audioData;
}

static HTAudioPlayer *_sharedInstance = nil;

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

- (void)playAudioWithURL:(NSURL *)audioURL {
    [self playAudioWithURL:audioURL delegate:nil];
}

- (void)playAudioWithURL:(NSURL *)audioURL delegate:(id<HTAudioPlayerDelegate>)delegate {
    _delegate = delegate;
    if(_player) {
        if (_audioURL == audioURL) {
            if(!_player.isPlaying){
                [self play];
            }
            return;
        }
        [self stop];
    }
    _audioURL = audioURL;
    _currentTime = 0;
    if(!_player) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        [_player setDelegate:self];
        [_player setMeteringEnabled:_meteringEnabled];
        _duration = _player.duration;
    }
    [self play];
}

- (void)playAudioWithData:(NSData *)audioData {
    [self playAudioWithData:audioData delegate:nil];
}

- (void)playAudioWithData:(NSData *)audioData delegate:(id<HTAudioPlayerDelegate>)delegate {
    _delegate = delegate;
    if(_player){
        if (_audioData == audioData) {
            return;
        }
        [self stop];
    }
    _currentTime = 0;
    if(!_player) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions: AVAudioSessionCategoryOptionDuckOthers error:nil];
        
        _player = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
        [_player setDelegate:self];
        [_player setMeteringEnabled:_meteringEnabled];
        _duration = _player.duration;
    }
    [self play];
}

- (void)play {
    if(_player && [_player prepareToPlay]){
        [_player play];
        [_player setCurrentTime:_currentTime];
        [self stopTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        [self updatePlayerStatus:HTAudioPlayerStatusPlaying];
    }
}

- (void)pause {
    if (_player && _player.isPlaying) {
        [_player pause];
        [self updatePlayerStatus:HTAudioPlayerStatusPaused];
    }
    [self stopTimer];
    [self updateProgress:_player.currentTime duration:_duration power:0];
}

- (void)stop {
    [self resetPlayer];
    [self stopTimer];
    [self updateProgress:_player.currentTime duration:_duration power:0];
    if(_player){
        [_player stop];
        _player = nil;
        [self updatePlayerStatus:HTAudioPlayerStatusStopped];
    }
}

- (NSTimeInterval)duration {
    return _duration;
}

- (NSTimeInterval)currentTime {
    return _currentTime;
}

- (AVAudioPlayer *)player {
    return _player;
}

@end

@implementation HTAudioPlayer (InnerMethods)

- (void)updatePlayerStatus:(HTAudioPlayerStatus)status {
    _status = status;
    if (_delegate && [_delegate respondsToSelector:@selector(player:statusDidChnage:)]) {
        [_delegate player:self statusDidChnage:status];
    }
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)handleTimer:(NSTimer *)timer {
    float level = 0;
    if(_meteringEnabled){
        [_player updateMeters];
        level = [_player averagePowerForChannel:0];
    }
    [self updateProgress:_player.currentTime duration:_duration power:level];
}

- (void)updateProgress:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration power:(CGFloat)power {
    if(_delegate && [_delegate respondsToSelector:@selector(player:currentTime:totalTime:soundPower:)]){
        [_delegate player:self currentTime:currentTime totalTime:duration soundPower:power];
    }
}

- (void)resetPlayer {
    _currentTime = 0;
    _duration = 0;
    _audioURL = nil;
    _audioData = nil;
    _player.delegate = nil;
    _player = nil;
}

- (void)resetProgress {
    [self stopTimer];
    [self updateProgress:_currentTime duration:_duration power:0];
}

@end

@implementation HTAudioPlayer (AudioPlayerDelegate)

- (void)end {
    [self resetProgress];
    [self updatePlayerStatus:HTAudioPlayerStatusStopped];
    [self resetPlayer];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [self end];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self end];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self end];
}

- (void) audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    [self end];
}

@end
