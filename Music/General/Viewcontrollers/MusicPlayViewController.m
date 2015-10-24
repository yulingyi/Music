//
//  MusicPlayViewController.m
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "MusicPlayerController.h"
#import "AudioStreamer.h"
#import "UIImageView+WebCache.h"
@interface MusicPlayViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dissVCButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *centerImg;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *endTimelabel;


@property (weak, nonatomic) IBOutlet UIButton *lastSong;


@property (weak, nonatomic) IBOutlet UIButton *playSong;

@property (weak, nonatomic) IBOutlet UIButton *nextSong;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UIImageView *circulation;
@property (weak, nonatomic) IBOutlet UIButton *downLoad;


@property (weak, nonatomic) IBOutlet UIButton *share;


@property (weak, nonatomic) IBOutlet UIButton *listBUtton;

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLeft;

@end

@implementation MusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicChanage:) name:@"MUSICMODEL" object:nil];
    self.tableViewLeft.constant = self.view.frame.size.width;

    [self setMusicPlayer];
    
    
    if (!self.player.isProcessing && _musicModel != nil) {
        self.player.url = [NSURL URLWithString:_musicModel.url];
        
        [self.player play];
       
    }
    
    
    CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
    monkeyAnimation.duration = 6;
    monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    monkeyAnimation.cumulative = NO;
    monkeyAnimation.removedOnCompletion = NO;
    monkeyAnimation.repeatCount = FLT_MAX;
    [self.centerImg.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
    [self.centerImg startAnimating];
   
    self.songNameLabel.text = _musicModel.name;
   self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(progess:) userInfo:nil repeats:YES];
    [self.slider addTarget:self action:@selector(chanageValue:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(dragEnterValue:) forControlEvents:UIControlEventTouchDragEnter];

}


- (void)musicChanage:(NSNotification *)notification
{
    
    
    self.songNameLabel.text = self.musicModel.albunName ? self.musicModel.albunName :self.musicModel.name;
    [self.centerImg sd_setImageWithURL:[NSURL URLWithString:self.musicModel.picUrl]];
    self.endTimelabel.text = self.player.streamer.totalTime;

    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    

    MusicModel *model = self.musicList[indexPath.row];
    cell.textLabel.text = model.name ? model.name :model.song_name;
    cell.detailTextLabel.text = model.singerName;
//    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.musicModel != self.musicList[indexPath.row]) {
    
        [self.player stop];
     
        self.musicModel = self.musicList[indexPath.row];
        self.player.url =[NSURL URLWithString:self.musicModel.url];
        self.songNameLabel.text = self.musicModel.albunName ? self.musicModel.albunName :self.musicModel.name;
        [self.centerImg sd_setImageWithURL:[NSURL URLWithString:self.musicModel.picUrl]];
         [self changMusicForMusicPlayerController];
        [self.player play];

        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicList.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row == 0) {
            [self.player stop];
            [self.musicList removeObjectAtIndex:indexPath.row];
            
            self.musicModel = self.musicList[0];
            self.player.url = [NSURL URLWithString:self.musicModel.url];
            [self.player play];
        }else{
          [self.musicList removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
         [self changMusicForMusicPlayerController];
    }
}

- (void)dragEnterValue:(UISlider *)slider
{

}


- (void)chanageValue:(UISlider *)slider
{
        [self.timer setFireDate:[NSDate distantFuture]];
    if (!self.player.streamer.isPaused) {
         [self.player.streamer pause];
    }

    
    [self.player.streamer seekToTime:self.slider.value];
    
    [self.player play];
    [self.timer setFireDate:[NSDate date]];
    
    
}
- (void)progess:(NSTimer *)timer

{ if([self.player.streamer isFinishing])
{
    [timer setFireDate:[NSDate distantFuture]];
    self.endTimelabel.text = @"00:00";
}else{
    
  
    
   
    self.slider.maximumValue = (float)self.player.streamer.duration;
    self.slider.value= self.player.streamer.progress;
    self.currentTimeLabel.text = self.player.streamer.currentTime;
   self.endTimelabel.text = self.player.streamer.totalTime;
}
}
- (IBAction)dissButtonAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)lastSongAction:(UIButton *)sender {
    
    [self.player stop];
    NSUInteger  index = [self.musicList indexOfObject:self.musicModel];
  
    if ((int)index - 1 > 0 && self.musicList[index - 1]) {
        self.musicModel = self.musicList[index - 1];
      [self changMusicForMusicPlayerController];
    }else
    {
        self.musicModel = [self.musicList lastObject];
        [self changMusicForMusicPlayerController];
    }
    
    [self.player play];
    
}


- (IBAction)playActopn:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    if (self.player.isProcessing) {
        [self.player.streamer pause];
        
        CFTimeInterval pausedTime = [self.centerImg.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.centerImg.layer.speed = 0.0;
        self.centerImg.layer.timeOffset = pausedTime;
        
        
       [self.playSong.imageView setImage:[UIImage imageNamed:@"stopButton"]];
    } else{
        
       [self.playSong.imageView setImage:[UIImage imageNamed:@"playButton"]];
        
        [self.player play];
        
        self.centerImg.layer.speed = 1;
        self.centerImg.layer.beginTime = 0.0;
        CFTimeInterval pausedTime = [self.centerImg.layer timeOffset];
        CFTimeInterval timeSincePause = [self.centerImg.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.centerImg.layer.beginTime = timeSincePause;
        
        

    }
    
    
    
}
- (IBAction)nextAction:(UIButton *)sender {
    [self.player stop];
    
    
    NSUInteger  index = [self.musicList indexOfObject:self.musicModel];
    if (index +1 < self.musicList.count && self.musicList[index + 1]) {
            self.musicModel = self.musicList[index + 1];
           self.songNameLabel.text = self.musicModel.albunName;
        [self changMusicForMusicPlayerController];
     
    }else
    {
        self.musicModel = self.musicList[0];
        self.player.url =[NSURL URLWithString:self.musicModel.url];
    }

          [self.player play];
   
}

- (void)changMusicForMusicPlayerController
{
     MusicPlayerController *musicPlayerController = [MusicPlayerController shareMusicPlayerController];
    musicPlayerController.musicList = self.musicList;
    musicPlayerController.musicModel = self.musicModel;
    
}




- (void)setMusicPlayer
{
    MusicPlayerController *musicPlayerController = [MusicPlayerController shareMusicPlayerController];
    self.musicList = musicPlayerController.musicList;
    self.musicModel = musicPlayerController.musicModel;
    self.avPlayer = musicPlayerController.avPlayer;
    self.player = musicPlayerController.player;
    self.centerImg.layer.cornerRadius = 100;
    self.centerImg.clipsToBounds = YES;
    [self.centerImg sd_setImageWithURL:[NSURL URLWithString:_musicModel.picUrl] placeholderImage:[UIImage imageNamed: @"disk"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

}
- (IBAction)songListAction:(UIButton *)sender {
    
    [UIView animateWithDuration:1 animations:^{
        if (self.tableViewLeft.constant == self.view.frame.size.width) {
            self.tableViewLeft.constant = 100;
            
        }else {
            self.tableViewLeft.constant = self.view.frame.size.width;
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
