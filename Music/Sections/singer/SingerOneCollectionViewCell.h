//
//  SingerOneCollectionViewCell.h
//  Music
//
//  Created by laouhn on 15/10/24.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingerOneModel.h"
@interface SingerOneCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic, strong) SingerOneModel *singer;
@end
