//
//  SingerOneCollectionViewController.m
//  Music
//
//  Created by laouhn on 15/10/24.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "SingerOneCollectionViewController.h"
#import "SingerOneModel.h"
#import "SingerOneCollectionViewCell.h"
#import "AFNetworking.h"
#import "songListViewController.h"
@interface SingerOneCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>


@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SingerOneCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
        self.navigationItem.title = @"歌手";
    self.dataSource = [@[] mutableCopy];
    [ self getDataSourceFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getDataSourceFromServer
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
   
    
    __block typeof(self) myType =  self;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    
    [manager GET:_urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [myType handleData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}



- (void)handleData:(id)data
{
    NSArray *ary = data[@"data"];
    
    for (NSDictionary *dic in ary) {
        SingerOneModel *model = [[SingerOneModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dic];
        
//        model.singer_id = (int)dic[@"singer_id"];
//        model.singer_name = dic[@"singer_name"];
//        model.pic_url = dic[@"pic_url"];
        [self.dataSource addObject:model];
        
    }
    
    
    [self.collectionView reloadData];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    NSIndexPath *index = [self.collectionView indexPathForCell:sender];
    songListViewController *songVC = segue.destinationViewController;
    songVC.singerOneModel = self.dataSource[index.row];
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - 20) / 3, 150);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
// #warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
// #warning Incomplete method implementation -- Return the number of items in the section
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SingerOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.singer = self.dataSource[indexPath.row];
    
    
    
    return cell;
}



@end
