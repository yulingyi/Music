
//
//  TableHeaderView.m
//  Music
//
//  Created by laouhn on 15/10/24.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TableHeaderView.h"

@implementation TableHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
    
        self.playerLabel = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 100, 40)];
//        self.playerLabel.backgroundColor = [UIColor yellowColor];
        [self.playerLabel setTitle:@"播放全部" forState:UIControlStateNormal];
        [self.playerLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.playerLabel.titleLabel setTextAlignment:NSTextAlignmentLeft];
        self.downLoadLabel = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100 , 10, 100, 40)];

        [self.downLoadLabel setTitle:@"管理全部" forState:UIControlStateNormal] ;
        
        [self addSubview:self.playerLabel];
        [self addSubview:self.downLoadLabel];
        [self.downLoadLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        [self.playerLabel addTarget:self action:@selector(playerAllSong:) forControlEvents:UIControlEventTouchUpInside];
        [self.downLoadLabel addTarget:self action:@selector(downLoadAllSong:) forControlEvents:UIControlEventTouchUpInside];
      


    }
    return self;
    
}

- (void)playerAllSong:(UIButton *)sender
{
    [self.delegate playerAllSong];
}

- (void)downLoadAllSong:(UIButton *)sender
{
    [self.delegate downLoadAllSong];
}
@end
