
//
//  SingerOneCollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/24.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "SingerOneCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation SingerOneCollectionViewCell



- (void)setSinger:(SingerOneModel *)singer
{
    if (_singer != singer) {
        _singer = singer;
        

        [self.img sd_setImageWithURL:[NSURL URLWithString:_singer.pic_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        self.name.text = _singer.singer_name;
    }
}

@end
