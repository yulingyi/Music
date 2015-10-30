//
//  WindowViewController.m
//  Music
//
//  Created by laouhn on 15/10/28.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "WindowViewController.h"
#import "LeftViewController.h"
#import "RootViewController.h"
@interface WindowViewController ()

@end

@implementation WindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LeftViewController *leftVC = [story instantiateViewControllerWithIdentifier:@"leftVC"];
    leftVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width / 3 * 2, self.view.frame.size.height);
    
    RootViewController *rootVC= [story instantiateViewControllerWithIdentifier:@"rootVC"];
    rootVC.view.frame = self.view.frame;
    [self addChildViewController:leftVC];
    [self addChildViewController:rootVC];
    
    [self.view addSubview:leftVC.view];
    [self.view addSubview:rootVC.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
