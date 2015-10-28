//
//  MusicPlayerController.m
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "MusicPlayerController.h"
#import "AudioStreamer.h"
#import "Music.h"
#import "AppDelegate.h"
@interface MusicPlayerController ()

@property (nonatomic, retain) NSTimer *timer;

@end

@implementation MusicPlayerController

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"state"];
    [self removeObserver:self forKeyPath:@"musicModel"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isCirculation = YES;
        self.isOneCirculation = NO;
        

        self.player = [[AudioPlayer alloc] init];

        self.musicList = [@[] mutableCopy];
        self.manger = [AFHTTPRequestOperationManager manager];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStateForStreamer:) name:ASStatusChangedNotification object:nil];
        
        [self addObserver:self forKeyPath:@"musicModel" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
      
        [self getMusicListFromSQL];
    }
    return self;
}

//typedef enum
//{
//    AS_INITIALIZED = 0,
//    AS_STARTING_FILE_THREAD = 1,          // 启动线程
//    AS_WAITING_FOR_DATA = 2,              // 准备数据
//    AS_FLUSHING_EOF = 3,                  // 数据准备完毕
//    AS_WAITING_FOR_QUEUE_TO_START = 4,    // 排队播放
//    AS_PLAYING = 5,                       // 正在播放
//    AS_BUFFERING = 6,                     // 网络不好,自动缓冲
//    AS_PAUSED = 7,                        // 手动暂停
//    AS_STOPPING = 8,                      // 即将停止,自动提醒
//    AS_STOPPED = 9,                       // 已停止播放
//} AudioStreamerState;


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL isMusicModel = [keyPath isEqualToString:@"musicModel"];
    if (isMusicModel) {
        self.player.url = [NSURL URLWithString:self.musicModel.url];
          [[NSNotificationCenter defaultCenter] postNotificationName:@"MUSICMODEL" object:self.musicModel];

    }
    
}

-  (void)getStateForStreamer:(NSNotification *)notification
{

    
    
    switch ([(AudioStreamer *)notification.object state]) {
     
  
        case 3:
        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"AS_FLUSHING_EOF" object:nil];
            
        }
            break;
        case 6:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AS_BUFFERING" object:nil];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"网络不好,自动缓冲" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            
            [alter show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alter dismissWithClickedButtonIndex:0 animated:YES];
            });
            
        }
            break;
        case  9:
            
            [self isFinished];
            break;

        default:
            break;
    }
 

}

- (void)isFinished
{
    if (self.player.streamer.isFinishing) {
        
        if (_isCirculation ) {
            if (_isOneCirculation) {
                
                [self.player play];
                
            }else
            {
                [self.musicList addObject:self.musicModel];
                [self.player stop];
                [self.musicList removeObjectAtIndex:0];
            }
        }else
        {
                NSInteger i = arc4random() % self.musicList.count + 1;
            
            [self.musicList exchangeObjectAtIndex:0 withObjectAtIndex:i];

        }
        
        
        self.musicModel = [self.musicList firstObject];
        self.player.url = [NSURL URLWithString: self.musicModel.url];
        [self.player play];
    }
    
    
}

+ (MusicPlayerController *)shareMusicPlayerController
{
    static MusicPlayerController *musicPlayer = nil;
    
    static dispatch_once_t onceToken;
    

    dispatch_once(&onceToken, ^{
        musicPlayer = [[MusicPlayerController alloc] init];
        
    });
    
    return musicPlayer;
}




- (void)getMusicListFromSQL
{
    
    
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"Music"];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray * result =  [appDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (Music *music in result) {
        MusicModel *musicModel = [[MusicModel alloc] init];
        musicModel.name = music.name;
        musicModel.url = music.url;
        musicModel.song_name = music.name;
        musicModel.songId = [NSNumber numberWithLongLong:music.songId];
        musicModel.singerId =  [NSNumber numberWithLongLong:music.singerId];
        musicModel.singerName = music.singerName;
        musicModel.value =  [NSNumber numberWithLongLong:music.value];
        musicModel.albunName = music.albunName;
        musicModel.albumld =  [NSNumber numberWithLongLong:music.albumld];
        musicModel.picUrl = music.picUrl;
        [self.musicList addObject:musicModel];
    }
    if (self.musicList.count) {
        self.musicModel = self.musicList[0];
    }

}

- (void)removeFromSQLWith:(MusicModel *)musicModel
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    Music *music = [NSEntityDescription insertNewObjectForEntityForName:@"Music" inManagedObjectContext:appDelegate.managedObjectContext];
    music.name = musicModel.name;
    music.url = musicModel.url;
    music.song_name = musicModel.song_name;
    music.songId = [musicModel.songId intValue];
    music.singerId = [musicModel.singerId intValue];
    music.singerName = musicModel.singerName;
    music.value = [musicModel.value  intValue];
    music.albunName = musicModel.albunName;
    music.albumld = [musicModel.albumld intValue];
    music.picUrl = musicModel.picUrl;
    [appDelegate.managedObjectContext deleteObject:music];
    [appDelegate saveContext];
    
}

- (void)downLoadMusic:(MusicModel *)music
{
        NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSLog(@"沙盒路径%@", cachePath);
        
        

        NSString * downLoadDicCacheWithVideo = [cachePath stringByAppendingPathComponent:@"DownLoadChacheWithMusic"];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:downLoadDicCacheWithVideo]) {
            [fileManager createDirectoryAtPath:downLoadDicCacheWithVideo withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString * musicPath = [downLoadDicCacheWithVideo stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",music.name]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:musicPath]) {
            UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"音乐已存在" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alterView show];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alterView dismissWithClickedButtonIndex:0 animated:YES];
            });
 
        }else{
            NSURL * url = [NSURL URLWithString:music.url];

            NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:-1];
            AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request] ;
            
            operation.outputStream = [[NSOutputStream alloc] initToFileAtPath:musicPath append:YES];
//            [operation start];
            [self.manger.operationQueue addOperation:operation];
            
            
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"%f",(float)totalBytesWritten / totalBytesExpectedToWrite);
            }];
            
            __weak MusicModel *musicBlock = music;
            __block NSString *musicPathBlock = musicPath;
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString * downLoadDicWithVideo = [cachePath stringByAppendingPathComponent:@"DownLoadWithMusic"];
                NSFileManager * fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:downLoadDicWithVideo]) {
                    [fileManager createDirectoryAtPath:downLoadDicWithVideo withIntermediateDirectories:YES attributes:nil error:nil];
                }
                NSString * musicPath = [downLoadDicWithVideo stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",musicBlock.name]];

                
                [fileManager moveItemAtPath:musicPathBlock toPath:musicPath error:nil];
              
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ 下载失败..." ,music.name] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                
                [alter show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alter dismissWithClickedButtonIndex:0 animated:YES];
                });
            }];
        }


}


- (void)collection:(MusicModel *)musicModel{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    Music *music = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Music" inManagedObjectContext:delegate.managedObjectContext];
    
    music.name = musicModel.name;
    music.url = musicModel.url;
    music.song_name = musicModel.song_name;
    music.songId = [musicModel.songId intValue];
    music.singerId = [musicModel.singerId intValue];
    music.singerName = musicModel.singerName;
    music.value = [musicModel.value  intValue];
    music.albunName = musicModel.albunName;
    music.albumld = [musicModel.albumld intValue];
    music.picUrl = musicModel.picUrl;
    
//    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alterView show];
//    
//    [delegate saveContext];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [alterView dismissWithClickedButtonIndex:0 animated:YES];
//    });
    
}
















@end
