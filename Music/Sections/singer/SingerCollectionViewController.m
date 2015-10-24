//
//  SingerCollectionViewController.m
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "SingerCollectionViewController.h"
#import "SingerCollectionViewCell.h"
#import "AFNetworking.h"
#import "SingerOneCollectionViewController.h"
@interface SingerCollectionViewController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SingerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"歌手分类";
    self.dataSource = [@[] mutableCopy];
    [self getDataSourceFromServer];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}

- (void)getDataSourceFromServer
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = @"http://v1.ard.tj.itlily.com/ttpod?a=getnewttpod&id=46&app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%2C2&f=f320&s=s310&imsi=&hid=&splus=8.4.1&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=";
    
    __block typeof(self) myType =  self;
    
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [myType handleData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}



- (void)handleData:(id)data
{
    NSArray *ary = data[@"data"];
    
    for (NSDictionary *dic in ary) {
        SingerModel *model = [[SingerModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        [self.dataSource addObject:model];
        
    }
    
    
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    SingerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_singer"
                                                                           forIndexPath:indexPath];
    

    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width / 2 - 10, 150);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


-  (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SingerCollectionViewCell * cell = sender;
    SingerOneCollectionViewController *oneSinger = segue.destinationViewController;
    SingerModel *model = cell.model;
    NSIndexPath *index = [self.collectionView indexPathForCell:cell];
    
    if (index.row == 0) {
        
        oneSinger.urlStr = @"http://api.dongting.com/misc/singer/top?app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%2C2&f=f320&s=s310&imsi=&hid=&splus=8.4.1&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=";
        
        
    }else if(index.row == 1)
    {
        oneSinger.urlStr = @"http://api.dongting.com/misc/singer/hot?app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%2C2&f=f320&s=s310&imsi=&hid=&splus=9.0&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=";
    }
    oneSinger.urlStr = [NSString stringWithFormat:@"http://v1.ard.tj.itlily.com/ttpod?a=getnewttpod&id=%@&size=1000&page=1&app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%%2C2&f=f320&s=s310&imsi=&hid=&splus=8.4.1&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=", model.singerID];
    
    
    
}

#pragma mark <UICollectionViewDelegate>




/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
