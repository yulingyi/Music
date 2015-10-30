//
//  Left_twoTableViewCell.m
//  Music
//
//  Created by laouhn on 15/10/28.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "Left_oneTableViewCell.h"

@implementation Left_oneTableViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}
- (IBAction)valueChanged:(UISwitch *)sender {
    
    if (!sender.on) {
        self.window.alpha = 0.5;
    }else
    {
        self.window.alpha = 1;
    }
}



@end
