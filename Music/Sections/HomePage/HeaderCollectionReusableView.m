//
//  HeaderCollectionReusableView.m
//  Music
//
//  Created by laouhn on 15/10/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
        
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end
