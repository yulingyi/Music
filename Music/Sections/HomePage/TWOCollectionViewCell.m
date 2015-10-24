//
//  TWOCollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TWOCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface TWOCollectionViewCell ()

@end

@implementation TWOCollectionViewCell

- (void)setModel:(MusicModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self.img sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        self.play.layer.cornerRadius = 15;
        self.song.text = _model.name;
        self.singer.text =[NSString stringWithFormat:@"%@ ❤️ %d千", _model.singerName, (arc4random()% 15644321 +15455) /1000];
    }
    
}

@end
