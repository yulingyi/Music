//
//  MusicPlayerController.h
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"
#import "MusicModel.h"
#import "AFHTTPRequestOperationManager.h"
@interface MusicPlayerController : NSObject
@property (nonatomic, assign) BOOL isCirculation;
@property (nonatomic, assign) BOOL isOneCirculation;
@property (nonatomic, strong) MusicModel *musicModel;
@property (nonatomic, strong) AVAudioPlayer *avPlayer;
@property (nonatomic, strong) AudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *musicList;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manger;
+ (MusicPlayerController *)shareMusicPlayerController;
- (void)downLoadMusic:(MusicModel *)music;
- (BOOL)collection:(MusicModel *)musicModel;
- (void)removeFromSQLWith:(MusicModel *)musicModel;
@end
