//
//  RedioCollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RedioCollectionViewCell.h"

#import "UIImageView+WebCache.h"
@interface RedioCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation RedioCollectionViewCell

- (void)setModel:(RedioModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self.img sd_setImageWithURL:[NSURL URLWithString:_model.pic_url_240_200] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        self.name.text = _model.tag_name;
   
    }
    
}


@end
