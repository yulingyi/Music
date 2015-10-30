//
//  LeftViewController.m
//  Music
//
//  Created by laouhn on 15/10/28.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "LeftViewController.h"
#import "RootViewController.h"
#import "Left_oneTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CollectTableViewController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[@"我的收藏",@"清除缓存"];
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
    swip.direction =  UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:swip];
    _tableView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
}


- (void)swip:(UIGestureRecognizer *)gesture
{
     RootViewController *rootVC = self.parentViewController.childViewControllers[1];
    
    [UIView animateWithDuration:0.5 animations:^{
        rootVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        Left_oneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_one" forIndexPath:indexPath];
        cell.textLabel.text = @"夜间模式";
        return cell;
    
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_two" forIndexPath:indexPath];
    cell.textLabel.text = self.array[indexPath.row - 1];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    if (indexPath.row == 2) {
        
        float tmpSize = [[SDImageCache sharedImageCache] getSize];
        NSLog(@"RecommendSize == %f", tmpSize);
        if (tmpSize < 1024) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.fB",tmpSize];
        }else if (tmpSize >= 1024 && tmpSize <= 1024 * 1024){
           cell.detailTextLabel.text = [NSString stringWithFormat:@"%.fKB",tmpSize / 1024];
        }else{
          cell.detailTextLabel.text = [NSString stringWithFormat:@"%.fMB",tmpSize/1024/1024];
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
      
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        UIAlertView *alter =  [[UIAlertView alloc] initWithTitle:@"" message:@"缓存已经清理..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alter show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alter dismissWithClickedButtonIndex:0 animated:YES];
            
            
        });
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else if(indexPath.row == 1)
    {
        [self swip:nil];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
               CollectTableViewController * collect =[story instantiateViewControllerWithIdentifier:@"collect"];
        
        RootViewController *rootVC = self.parentViewController.childViewControllers[1];
        
        [rootVC.childViewControllers[0] pushViewController:collect animated:YES];
   
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
@end
