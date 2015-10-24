//
//  ONECollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ONECollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface ONECollectionViewCell ()

@end


@implementation ONECollectionViewCell

- (void)setModel:(MusicModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self.img sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        self.name.text = _model.name;

    }
    
 }
    

@end
