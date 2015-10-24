//
//  TWOCollectionViewCell.h
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@interface TWOCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *song;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UIButton *play;

@property (nonatomic, strong) MusicModel *model;
@end
