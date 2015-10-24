//
//  MusicPlayViewController.h
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"
#import "MusicPlayerController.h"
#import "MusicModel.h"
@interface MusicPlayViewController : UIViewController
@property (nonatomic, strong) AVAudioPlayer *avPlayer;
@property (nonatomic, strong) AudioPlayer *player;
@property (nonatomic, strong) MusicModel *musicModel;
@property (nonatomic, strong) NSMutableArray *musicList;
@end
