//
//  SortTableViewCell.m
//  Music
//
//  Created by laouhn on 15/10/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "SortTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface SortTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *songOne;
@property (weak, nonatomic) IBOutlet UILabel *songTwo;
@property (weak, nonatomic) IBOutlet UILabel *songThird;
@property (weak, nonatomic) IBOutlet UILabel *sort;

@end

@implementation SortTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(SortModel *)model
{
    if (_model != model) {
        _model = model;
        
        [self.icon sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        self.songOne.text = [NSString stringWithFormat:@"1.%@", [(MusicModel *)_model.songs[0] name]];
        self.songTwo.text = [NSString stringWithFormat:@"2.%@", [(MusicModel *)_model.songs[1] name]];
        
        self.songThird.text = [NSString stringWithFormat:@"3.%@", [(MusicModel *)_model.songs[2] name]];
        
        self.sort.text = _model.title;
        
        
        
    }
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
