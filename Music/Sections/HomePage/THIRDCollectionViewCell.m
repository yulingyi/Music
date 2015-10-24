//
//  THIRDCollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "THIRDCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface THIRDCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation THIRDCollectionViewCell


- (void)setModel:(MusicModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self.img sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        self.desc.text = _model.name;
        
    }
    
}
@end
