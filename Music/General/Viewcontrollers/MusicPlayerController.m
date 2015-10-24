//
//  MusicPlayerController.m
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "MusicPlayerController.h"
#import "AudioStreamer.h"

@interface MusicPlayerController ()

@property (nonatomic, retain) NSTimer *timer;

@end

@implementation MusicPlayerController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.avPlayer = [[AVAudioPlayer alloc] init];
        self.player = [[AudioPlayer alloc] init];
        self.musicList = [@[] mutableCopy];
        self.manger = [AFHTTPRequestOperationManager manager];
        
        self.timer = [NSTimer  scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(isFinish:) userInfo:nil repeats:YES];
        [self addObserver:self forKeyPath:@"musicModel" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)isFinish:(NSTimer *)timer
{
    if (self.player.streamer.isFinishing) {
        [self.musicList addObject:self.musicModel];
        [self.musicList removeObjectAtIndex:0];
        [self.player stop];
        self.musicModel = [self.musicList firstObject];
        self.player.url = [NSURL URLWithString: self.musicModel.url];
        [self.player play];
    }
    
    
}

+ shareMusicPlayerController
{
    static MusicPlayerController *musicPlayer = nil;
    
    static dispatch_once_t onceToken;
    

    dispatch_once(&onceToken, ^{
        musicPlayer = [[MusicPlayerController alloc] init];
        
    });
    
    return musicPlayer;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MUSICMODEL" object:nil] ;

    
    
}


@end
