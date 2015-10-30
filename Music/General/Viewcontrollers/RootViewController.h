//
//  RootViewController.h
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@interface RootViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *SongList;
@property (weak, nonatomic) IBOutlet UIButton *img;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *writerName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VerticalSpace;
@property (weak, nonatomic) IBOutlet UILabel *playButton;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;
@property (nonatomic, strong) MusicModel * model;
@property (nonatomic, strong) NSMutableArray *musicList;
@end
