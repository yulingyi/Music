//
//  TwoCollectionViewCell.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TwoCollectionViewCell.h"
#import "SortTableViewController.h"

@interface TwoCollectionViewCell ()
@property (nonatomic, strong) SortTableViewController *sortVC;
@end


@implementation TwoCollectionViewCell
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        self.sortVC = [story instantiateViewControllerWithIdentifier:@"SORT"];
        
        [self addSubview:self.sortVC.view];
    }
    return self;
}

- (void)addchildVC:(UIViewController *)vc
{
    [vc addChildViewController:self.sortVC];
}

@end
