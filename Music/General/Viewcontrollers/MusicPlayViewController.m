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
#import "Music.h"
#import "AppDelegate.h"
#import "UMSocial.h"
@interface MusicPlayViewController ()<UITableViewDataSource,UMSocialUIDelegate, UITableViewDelegate>

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
@property (nonatomic, strong) MusicPlayerController *musicPlayerController;
@end

@implementation MusicPlayViewController

- (void)viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    self.slider.value = 0;
    self.downLoad.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.slider.minimumValue = 0.0;
    self.slider.value = 0.0;
    self.slider.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicChanage:) name:@"MUSICMODEL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushing:) name:@"AS_FLUSHING_EOF" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buffering:) name:@"AS_BUFFERING" object:nil];
    self.tableViewLeft.constant = self.view.frame.size.width;

    [self setMusicPlayer];
  
    
    if (!self.player.isProcessing && _musicModel != nil) {
        self.player.url = [NSURL URLWithString:_musicModel.url];
        
        [self.player play];
       
    }
    [self startCenterAnimation];
    
    
//    if (!self.player.streamer.isPlaying) {
//        CFTimeInterval pausedTime = [self.centerImg.layer convertTime:CACurrentMediaTime() fromLayer:nil];
//        self.centerImg.layer.speed = 0.0;
//        self.centerImg.layer.timeOffset = pausedTime;
//        
//
//        [self.centerImg stopAnimating];;
//    }
    
    
       self.songNameLabel.text = _musicModel.name;
   self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(progess:) userInfo:nil repeats:YES];
   
   
    [self.slider addTarget:self action:@selector(chanageValue:) forControlEvents:UIControlEventValueChanged];

    
}


- (void)customAlterView:(NSString *)str
{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, -60, self.view.frame.size.width, 60)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor blueColor];
    lable.textColor = [UIColor whiteColor];
    lable.text = str;
    
    
    [self.view.window addSubview:lable];
    __weak UILabel * lab = lable;
    [UIView animateWithDuration:1 animations:^{
       
        lab.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [UIView animateWithDuration:1 animations:^{
            lab.frame = CGRectMake(0, -60, self.view.frame.size.width, 60);
        } completion:^(BOOL finished) {
                [lable removeFromSuperview];
        }];
        
    });


    
}

- (void)chanageCenter:(NSString *)urlStr
{
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.centerImg.frame];
    imgView.image = self.centerImg.image;
    imgView.clipsToBounds = YES;
    imgView.layer.cornerRadius = 150;
    
    [self.view addSubview:imgView];
    
    [UIView animateWithDuration:.5 animations:^{
        imgView.frame = CGRectMake(self.centerImg.frame.origin.x - 50,self.centerImg.frame.origin.y + 50, 200, 200);
        imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    }];
    
    [UIView animateWithDuration:1 animations:^{
        imgView.frame = CGRectMake(self.view.frame.size.width, 0, 0, 0);
        
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];
    }];
    
}
- (void)startCenterAnimation
{
    
    CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
    monkeyAnimation.duration = 6;
    monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    monkeyAnimation.cumulative = NO;
    monkeyAnimation.removedOnCompletion = NO;
    monkeyAnimation.repeatCount = FLT_MAX;
    [self.centerImg.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
    [self.centerImg startAnimating];

}



- (IBAction)shareMuisc:(UIButton *)sender {

//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5630733ae0f55a2369001924"
                                      shareText:[NSString stringWithFormat:@"音乐:%@..%@",self.songNameLabel.text,self.musicModel.url]
                                     shareImage:self.centerImg.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToTencent,UMShareToDouban,nil]
                                       delegate:self];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSString *msg = response.message;
    if ([msg isEqualToString:@"no error"] ) {
       [self customAlterView:@"分享成功"];
    }
   
}

- (IBAction)downLoadMusic:(UIButton *)sender {
    
  
    [self.musicPlayerController downLoadMusic:self.musicModel];
    
    
}

- (IBAction)collect:(UIButton *)sender {

    
    if ([self.musicPlayerController collection:self.musicModel]) {
        [self customAlterView:@"收藏成功.."];
    }else
    {
        [self customAlterView:@"歌曲已存在.."];
    }
    
}

- (IBAction)circulation:(UIButton *)sender {
    
    static int i = -1;
    
    i++;

    if (i == 0) {
        self.musicPlayerController.isCirculation = NO;
        [self customAlterView:@"随机播放"];
        
        [sender setTitle:@"随机播放" forState:UIControlStateNormal];
        
    }else if(i == 1)
    {
        self.musicPlayerController.isCirculation = YES;
        self.musicPlayerController.isOneCirculation = NO;
        [self customAlterView:@"顺序播放"];
          [sender setTitle:@"顺序播放" forState:UIControlStateNormal];
   
 sender.imageView.image = [UIImage imageNamed:@"shuxu"];
    }else
    {
        self.musicPlayerController.isCirculation = YES;
        self.musicPlayerController.isOneCirculation = YES;
        i = -1;
        [self customAlterView:@"单曲循环"];
        [sender setTitle:@"单曲循环" forState:UIControlStateNormal];
    }
    

}

- (void)flushing:(NSNotification *)notification
{
    [self.timer setFireDate:[NSDate date]];
    [self.player play];
}


- (void)musicChanage:(NSNotification *)notification
{
    
    MusicModel *model = notification.object;
    [self chanageCenter:self.musicModel.url];
    self.musicModel = model;
    
    self.songNameLabel.text = model.albunName ? model.albunName :model.name;
    [self.centerImg sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
   

    [self.timer setFireDate:[NSDate date]];
    if (!self.centerImg.isAnimating) {

        [self startCenterAnimation];
    }
    self.playSong.selected = NO;
    
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
            if (self.musicList.count) {
                self.musicModel = self.musicList[0];
                self.player.url = [NSURL URLWithString:self.musicModel.url];
                [self.player play];
            }
            
            [self changMusicForMusicPlayerController];
        }else{
          [self.musicList removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}


- (void)chanageValue:(UISlider *)slider
{

    
    [self.player.streamer seekToTime:self.slider.value];

    
    [self.player play];
   
    
    
}
- (void)progess:(NSTimer *)timer

{
    if([self.player.streamer isFinishing])
{
//    [timer setFireDate:[NSDate distantFuture]];
 
    self.endTimelabel.text = @"00:00";
}else{
    
  
    
   [timer setFireDate:[NSDate date]];
    
    self.slider.value = self.player.streamer.progress  / self.player.streamer.duration;
    self.currentTimeLabel.text = self.player.streamer.currentTime;
   self.endTimelabel.text = self.player.streamer.totalTime;
       
}
}
- (IBAction)dissButtonAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)lastSongAction:(UIButton *)sender {
    if (self.musicList.count >0) {
    
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
    
}


- (IBAction)playActopn:(UIButton *)sender {
    
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player.streamer pause];
        
        CFTimeInterval pausedTime = [self.centerImg.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.centerImg.layer.speed = 0.0;
        self.centerImg.layer.timeOffset = pausedTime;
        
        
       [self.playSong.imageView setImage:[UIImage imageNamed:@"stopButton"]];
        
        
        [self.centerImg stopAnimating];
    } else{
        
       [self.playSong.imageView setImage:[UIImage imageNamed:@"playButton"]];
        
        [self.player play];
        
        self.centerImg.layer.speed = 1;
        self.centerImg.layer.beginTime = 0.0;
        CFTimeInterval pausedTime = [self.centerImg.layer timeOffset];
        CFTimeInterval timeSincePause = [self.centerImg.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.centerImg.layer.beginTime = timeSincePause;
        
        [self.centerImg startAnimating];
       
    }
    
    
    
}
- (IBAction)nextAction:(UIButton *)sender {
    
    
    if (self.musicList.count >0) {
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
    
}

- (void)changMusicForMusicPlayerController
{
    
    self.musicPlayerController.musicList = self.musicList;
    self.musicPlayerController.musicModel = self.musicModel;
    
}




- (void)setMusicPlayer
{
   self.musicPlayerController = [MusicPlayerController shareMusicPlayerController];
    self.musicList = self.musicPlayerController.musicList;
    self.musicModel = self.musicPlayerController.musicModel;
    self.avPlayer = self.musicPlayerController.avPlayer;
    self.player = self.musicPlayerController.player;
    self.centerImg.layer.cornerRadius = 150;
    self.centerImg.clipsToBounds = YES;
    [self.centerImg sd_setImageWithURL:[NSURL URLWithString:_musicModel.picUrl] placeholderImage:[UIImage imageNamed: @"disk"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

}
- (IBAction)songListAction:(UIButton *)sender {
    

        if (self.tableViewLeft.constant == self.view.frame.size.width) {
            self.tableViewLeft.constant = 100;
            
            [self.tableView setNeedsUpdateConstraints];
            [UIView animateWithDuration:0.5f animations:^{
                [self.tableView layoutIfNeeded];
            }];

        }else {
            self.tableViewLeft.constant = self.view.frame.size.width;
            [self.tableView setNeedsUpdateConstraints];
            [UIView animateWithDuration:0.5f animations:^{
                [self.tableView layoutIfNeeded];
            }];
        }

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
