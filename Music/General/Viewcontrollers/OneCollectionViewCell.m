//
//  OneCollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "OneCollectionViewCell.h"
#import "HomeCollectionViewController.h"
#import "HomeTableViewController.h"
@interface OneCollectionViewCell ()

@property (nonatomic, strong) HomeTableViewController *homeVC;

@end


@implementation OneCollectionViewCell


- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.homeVC = [story instantiateViewControllerWithIdentifier:@"HOME"];
        
        CGRect rect = self.homeVC.view.frame;
        
        self.homeVC.view.frame =  CGRectMake(0, 0, rect.size.width, rect.size.height);
        [self addSubview:self.homeVC.view];
    }
    return self;
}

- (void)addchildVC:(UIViewController *)vc
{
    [vc addChildViewController:self.homeVC];
}

@end
