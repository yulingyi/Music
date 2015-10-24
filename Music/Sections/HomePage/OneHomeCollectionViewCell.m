//
//  OneHomeCollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "OneHomeCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface OneHomeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *song;
@property (weak, nonatomic) IBOutlet UILabel *singer;


@end

@implementation OneHomeCollectionViewCell

- (void)setModel:(MusicModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self.img sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        self.song.text = _model.name;
        self.singer.text = _model.singerName;
        
        
    }
    
}

@end
