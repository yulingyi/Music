//
//  RadioViewController.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RadioViewController.h"
#import "AFNetworking.h"
#import "RedioCollectionViewCell.h"
#import "RedioModel.h"
#import "MusicModel.h"
#import "MusicPlayerController.h"
@interface RadioViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *sectionAry;
@property (nonatomic, assign) int click;


@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [@[] mutableCopy];
    [self getDataSourceFromServer];
    self.navigationItem.title = @"电台";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)getDataSourceFromServer
{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = @"http://fm.api.ttpod.com/radiolist?image_type=240_200&app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%2C2&f=f320&s=s310&imsi=&hid=&splus=8.4.1&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=";
    
    __block typeof(self) myType =  self;
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [myType handleData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

- (void)handleData:(id)data
{
    self.sectionAry = data[@"data"];
    NSArray *ary = data[@"data"];
    for (NSDictionary *dic in ary) {
        NSMutableArray *section = [@[] mutableCopy];
        for (NSDictionary *radioDic in dic[@"data"]) {
            RedioModel *model = [[RedioModel alloc] init];
            [model setValuesForKeysWithDictionary:radioDic];
            [section addObject:model];
            
        }
        [self.dataSource addObject:section];
    }
    
    [self.tableView reloadData];
    [self.collectionView reloadData];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---UITableViewDataSource,UITableViewDelegate,

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_tab" forIndexPath:indexPath];
    
    cell.textLabel.text = self.sectionAry[indexPath.row][@"tag_type_name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}
#pragma mark ---UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RedioCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_coll" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RedioModel *model = self.dataSource[indexPath.section][indexPath.row];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr =[NSString stringWithFormat:@"http://fm.api.ttpod.com/vipradiosong?num=150&tagid=%@&app=ttpod&v=v8.0.1.2015091618&uid=&mid=iPhone8%%2C1&f=f320&s=s310&imsi=&hid=&splus=9.0.2&active=1&net=2&openudid=984cbc2781aa37aa9c6051f63e4ff3ac4e56b986&idfa=668C0E40-ED87-4C0A-87E6-6B7EA39E5EDC&utdid=ViJMC0D93pgDADXkd0DhpM1Y&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=", model.tag_id];;
    
    __block typeof(self) myType =  self;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];

    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
        NSArray *dataArray = responseObject[@"data"];
        
        
        [myType playerRadio:dataArray picUrl:model.pic_url_240_200];
        

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}

- (void)playerRadio:(NSArray *)data picUrl:(NSString *)str
{
    NSMutableArray *musicArray = [@[] mutableCopy];
    for (NSDictionary *dic in data) {
        
        MusicModel *model = [[MusicModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.picUrl = str;
        if ([dic[@"audition_list"] count]) {
            
            
            model.url = dic[@"audition_list"][0][@"url"];
          
            
        }
        model.singerName = dic[@"singer_name"];
        model.albunName = dic[@"album_name"];
        model.songId = dic[@"song_id"];
        [musicArray addObject:model];
    }
    
    MusicPlayerController *playerController = [MusicPlayerController shareMusicPlayerController];
    
    
    
    
    if (playerController.musicList != musicArray) {
        playerController.musicList = musicArray;
        if (playerController.player.isProcessing) {
            [playerController.player stop];
        }
        
        playerController.musicModel = musicArray[0];
        
        if (playerController.musicModel.url) {
            playerController.player.url =[NSURL URLWithString:playerController.musicModel.url];
            [playerController.player play];
        }
       
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.frame.size.width / 2 - 5, 120);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSIndexPath *index = [NSIndexPath indexPathForItem:indexPath.section inSection:0];
//    
//    [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
//    
//    
//}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 30);

}
@end
