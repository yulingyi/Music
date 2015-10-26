
//  ViewController.m
//  Music
//
//  Created by laouhn on 15/10/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ViewController.h"
#import "TopHomeCollectionReusableView.h"
#import "HeaderCollectionReusableView.h"
#import "AFNetworking.h"
#import "topHeaderModel.h"
#import "MusicModel.h"
#import "ONECollectionViewCell.h"
#import "TWOCollectionViewCell.h"
#import "THIRDCollectionViewCell.h"
#import "MusicPlayerController.h"
#import "RootViewController.h"
#import "songListViewController.h"
#import "MBProgressHUD.h"
@interface ViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) NSMutableDictionary *dataSource;
@property (nonatomic, strong) NSArray *sectionArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    
    
    [self.collectionView reloadData];
    
    NSLog(@"%@", self);
    self.sectionArray = @[@"大家在听 (每小时更新)", @"热门歌单", @"静静听你怀恋一抹淡淡的旋律", @"每日十首"];
    
    [self.collectionView registerClass:[TopHomeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topHeader"];
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
    self.dataSource = [NSMutableDictionary dictionaryWithCapacity:1];
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
        }else if (i == 1)
        {
             NSMutableArray *Ary = [@[] mutableCopy];
            for (NSDictionary *dic in ary[1][@"data"]) {
                MusicModel *model = [[MusicModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [Ary addObject:model];
            }
            
            [self.dataSource setValue:Ary forKey:@"one"];
            
            
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
        }else if (i == 3)
        {
            
            
            NSMutableArray *Ary = [@[] mutableCopy];
            for (NSDictionary *dic in ary[i][@"data"]) {
                
                
                MusicModel *model = [[MusicModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                model.value = dic[@"action"][@"value"];
                
                [Ary addObject:model];
            }
            [self.dataSource setObject:Ary forKey:@"third"];
        }if (i == 4)
        {
            
            
            NSMutableArray *Ary = [@[] mutableCopy];
            for (NSDictionary *dic in ary[i][@"data"]) {
                
                
                MusicModel *model = [[MusicModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                model.value = dic[@"action"][@"value"];

                
                [Ary addObject:model];
            }
            [self.dataSource setObject:Ary forKey:@"four"];
        }


    }
    
    
    
    [self.collectionView reloadData];
    [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    
    if (section == 1) {
    return 3;
}else if( section == 2)
{
    return 6;
}else if(section == 3)
{
    return 3;
}else if (section == 0)
{
    return 4;
}
    
    
    return 0;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ONECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_one" forIndexPath:indexPath];
        cell.model = self.dataSource[@"one"][indexPath.row];
        return cell;
    }else if(indexPath.section == 1)
    {

   TWOCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_two" forIndexPath:indexPath];
        
        cell.model = self.dataSource[@"two"][indexPath.row];
        
        return cell;
    }else if(indexPath.section == 2 || indexPath.section == 3){
     
        THIRDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_third" forIndexPath:indexPath];
        if (indexPath.section == 2) {
            cell.model = self.dataSource[@"third"][indexPath.row];
            
            return  cell;
        }
        cell.model = self.dataSource[@"four"][indexPath.row];
        return  cell;
       
    
    }
    
      UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_third" forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         TopHomeCollectionReusableView *top =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topHeader" forIndexPath:indexPath];
        top.modelAry = self.dataSource[@"top"];
        return top;
    }
    HeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    header.nameLabel.text = self.sectionArray[indexPath.section- 1];
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0  ) {
        [self performSegueWithIdentifier:@"SortShow" sender:nil];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"SongListShow" sender:nil];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        [self performSegueWithIdentifier:@"RadioShow" sender:nil];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        [self performSegueWithIdentifier:@"SingerShow" sender:nil];
    }
    if (indexPath.section == 1) {
        MusicPlayerController *player = [MusicPlayerController shareMusicPlayerController];
        
        TWOCollectionViewCell *cell = (TWOCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (player.musicModel != cell.model) {
            if (player.player.isProcessing) {
                      [player.player stop];
            }
      
            player.musicModel = cell.model;
            
            if (![player.musicList containsObject:cell.model]) {
            
                [player.musicList insertObject:cell.model atIndex:0];;
            }
     
            NSLog(@"change model.name:%@",player.musicModel.name);
            player.player.url =[NSURL URLWithString:cell.model.url];
            [player.player play];
        }
        
        
        
    
        RootViewController * root = (RootViewController *)self.parentViewController.parentViewController;
        root.model = cell.model;
    
//        [root performSegueWithIdentifier:@"musicPlay" sender:nil];
    }
    
   
    
    

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       return  CGSizeMake([UIScreen mainScreen].bounds.size.width / 4,100);
      
    }else if (indexPath.section == 2 || indexPath.section == 3){
    
        return CGSizeMake([UIScreen mainScreen].bounds.size.width / 3 - 5, 140);
    
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSIndexPath *index = [self.collectionView indexPathForCell:sender];
    if ([sender isKindOfClass:[THIRDCollectionViewCell class]]) {
        songListViewController *vc = segue.destinationViewController;
        
        vc.musicModel = ((THIRDCollectionViewCell *)sender).model;

    }
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 180);

    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 60);

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
