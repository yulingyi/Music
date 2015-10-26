//
//  RootViewController.m
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "MusicPlayViewController.h"
#import "MusicPlayerController.h"
#import "UIImageView+WebCache.h"
#import "MusicPlayerController.h"
#import "AudioStreamer.h"
#import "AudioPlayer.h"
#import "AppDelegate.h"
#import "Music.h"
@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MusicPlayerController *musicPlayerController;
@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *nav = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    

    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    
    self.musicPlayerController = [MusicPlayerController shareMusicPlayerController];
    
    self.model = self.musicPlayerController.musicModel;
    
    NSLog(@"model.name:%@",self.model.name);
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicChanage:) name:@"MUSICMODEL" object:nil];
    
    
    [self addTapForBottomView];
    
    // Do any additional setup after loading the view.
}




- (void)addTapForBottomView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    
    
    [self.bottomView addGestureRecognizer:tap];
    
}

- (void)tapGesture:(UIGestureRecognizer *)gesture
{
    
    
      [self performSegueWithIdentifier:@"musicPlay" sender:nil];
}


- (void)musicChanage:(NSNotification *)notification
{
    
    
      [self configuration];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
 
       [self configuration];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)configuration
{
    MusicPlayerController *musicPlayerController = [MusicPlayerController shareMusicPlayerController];
    
    self.model = musicPlayerController.musicModel;
    self.musicList = musicPlayerController.musicList;

    self.img.layer.cornerRadius = 20;
    self.img.clipsToBounds = YES;
    
  
    [self.img.imageView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:[UIImage imageNamed:@"logo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    NSString *str = (_model.name ? _model.name :_model.albunName) ? (_model.name ? _model.name :_model.albunName) :_model.song_name;
    
    (id)str != [NSNull null] ?  self.songName.text = str : nil;
    (id)_model.singerName != [NSNull null] ? self.writerName.text = _model.singerName : nil;
 
}




- (IBAction)songListButton:(UIButton *)sender {
    
    [UIView animateWithDuration:12 animations:^{

        self.VerticalSpace.constant = self.VerticalSpace.constant ?  0: -400;
    }];
        [self.tableView reloadData];
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (IBAction)playerAction:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    MusicPlayerController *player =  [MusicPlayerController shareMusicPlayerController];
    
 
    if (!player.player.streamer.isPlaying) {
        [player.player play];
    }else{
        
        [player.player.streamer pause];
    }
    
    

    
}
- (IBAction)musicVC:(UIButton *)sender {
    
     [self performSegueWithIdentifier:@"musicPlay" sender:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_root" forIndexPath:indexPath];
    
    MusicModel *model = self.musicList[indexPath.row];
   
    NSString *str = (model.name ? model.name :model.albunName) ? (model.name ? model.name :model.albunName) :model.song_name;
 
    (id)str != [NSNull null] ?  cell.textLabel.text = str : nil;
    (id)model.singerName != [NSNull null] ? cell.detailTextLabel.text = model.singerName : nil;
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.musicList removeObject:self.musicList[indexPath.row]];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model = self.musicList[indexPath.row];
    if (self.musicPlayerController.musicModel != self.model) {
        if (self.musicPlayerController.player.isProcessing) {
            [self.musicPlayerController.player stop];
        }
        
        self.musicPlayerController.musicModel = self.model;
      
//        NSLog(@"change model.name:%@",self.musicPlayerController.musicModel.name);
        self.musicPlayerController.player.url =[NSURL URLWithString:self.model.url];
        [self.musicPlayerController.player play];
    }
}

@end
