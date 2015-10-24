//
//  HomePageCollectionViewController.m
//  Music
//
//  Created by laouhn on 15/10/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "HomePageCollectionViewController.h"
#import  "TopCollectionReusableView.h"
#import "AFNetworking.h"
#import "topHeaderModel.h"
#import "MusicModel.h"
#import "HeaderCollectionReusableView.h"
#import "OneHomePageCollectionViewCell.h"
@interface HomePageCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end

@implementation HomePageCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.dataSource = [@{} mutableCopy];
    
    [self.collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self getDataSourceFromServer];
}

- (void)getDataSourceFromServer
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
   NSString *urlStr = @"http://api.dongting.com/frontpage/frontpage?location=0&version=1442195920&app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%2C2&f=f320&s=s310&imsi=&hid=&splus=8.4.1&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=";
    
    __block typeof(self) myType =  self;
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [myType handleData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"%@", error);
        
    }];
    
}



- (void)handleData:(id)data
{
    
    NSArray * ary = (NSArray *)data[@"data"];
    
    for (int i = 0; i < ary.count; i++ ) {
        if (i == 0 ) {
            
            NSMutableArray *topAry = [@[] mutableCopy];
            for (NSDictionary *dic in ary[i][@"data"]) {
                
            
            topHeaderModel *model = [[topHeaderModel alloc] init];
            
            [model setValuesForKeysWithDictionary:dic];
                
            [topAry addObject:model];
            }
            [self.dataSource setObject:topAry forKey:@"top"];
        }else if (i == 2)
        {
            
            
            NSMutableArray *topAry = [@[] mutableCopy];
            for (NSDictionary *dic in ary[i][@"data"][0][@"songs"]) {
                
                
                MusicModel *model = [[MusicModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
               
                if ([dic[@"auditionList"] count]) {
                    
                
                    model.url = dic[@"auditionList"][2][@"url"];

                }
                
                [topAry addObject:model];
            }
            [self.dataSource setObject:topAry forKey:@"two"];
        }
    }
    
   
    
    [self.collectionView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//  #warning Incomplete method implementation -- Return the number of sections
    return [self.dataSource allKeys].count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
// #warning Incomplete method implementation -- Return the number of items in the section
    
    if (section == 1) {
        return 3;
    }else if( section == 2)
    {
        return 6;
    }else if(section == 3)
    {
        return 3;
    }else if(section == 4){
    
        return 10;
        
    }else if (section == 0)
    {
        return 2;
    }
    
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OneHomePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_one" forIndexPath:indexPath];
    
    if (indexPath.section == 1) {
        
        cell.model = self.dataSource[@"two"][indexPath.row];
        
    }
 
    
    return cell;
}



#pragma mark <UICollectionViewDelegate>
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
//{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 0) {
//        TopCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topHeader" forIndexPath:indexPath];
//        
//        header.modelAry = self.dataSource[@"top"];
//        return header;
//    }
//    HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
////
//    header.nameLabel.text = @"大家在听";
//    
//    CGRect rect  = header.frame;
//    
//    rect.size = CGSizeMake([UIScreen mainScreen].bounds.size.width, rect.size.height);
//    
//    header.frame = rect;
//    
//    return header;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return section ?  CGSizeMake([UIScreen mainScreen].bounds.size.width, 40) : CGSizeMake(300, 180);
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
}

 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}



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
