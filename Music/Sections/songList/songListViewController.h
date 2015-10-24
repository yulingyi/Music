//
//  songListViewController.h
//  Music
//
//  Created by laouhn on 15/10/23.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongListModel.h"
#import "SortModel.h"
#import "MusicModel.h"
#import "SingerOneModel.h"
@interface songListViewController : UITabBarController
@property (nonatomic, strong) SongListModel *songListModel;
@property (nonatomic, strong) SortModel *sortModel;
@property (nonatomic, strong) MusicModel *musicModel;
@property (nonatomic, strong) SingerOneModel *singerOneModel;

@end
