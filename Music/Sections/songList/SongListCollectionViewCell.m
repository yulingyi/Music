//
//  SongListCollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "SongListCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface SongListCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *count;
@end

@implementation SongListCollectionViewCell
- (void)setModel:(SongListModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self.img sd_setImageWithURL:[NSURL URLWithString:_model.pic_url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        self.name.text = _model.title;
        self.count.text = [NSString stringWithFormat:@"🎧%@",_model.listen_count];
        
    }
    
    
    
    
}
@end
