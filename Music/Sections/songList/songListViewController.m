
//  songListViewController.m
//  Music
//
//  Created by laouhn on 15/10/23.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "songListViewController.h"
#import "AFNetworking.h"
#import "MusicModel.h"
#import "MusicPlayerController.h"
#import "UIImageView+WebCache.h"
#import "MusicPlayerController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHEIGHT  [UIScreen mainScreen].bounds.size.height
#import "TableHeaderView.h"
@interface songListViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate, TableHeaderViewdelegate>
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *musicList;
@property (nonatomic, strong) MusicPlayerController *musicPlayerController;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *listName;
@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, copy) NSString *descStr;
@property (nonatomic, copy) NSString *imgStr;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) UIButton *playerLabel;
@property (nonatomic, strong) UIButton *downLoadLabel;
@property (nonatomic, strong) UITableViewHeaderFooterView *header;
@end

@implementation songListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setUrlStr];
//    [self setHeadercell];
    self.musicList = [@[] mutableCopy];
//    self.navigationController.navigationBar.hidden = YES;
    
    
    
    self.musicPlayerController = [MusicPlayerController shareMusicPlayerController];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 124) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        [self headerView];
    [self.tableView registerClass:[TableHeaderView class] forHeaderFooterViewReuseIdentifier:@"header" ];
    [self getDataSourceFromServer];
    
    
    
}

- (void)setUrlStr
{
    if (_songListModel) {
        
        self.imgStr = _songListModel.pic_url;
        self.descStr = _songListModel.desc;
        self.titleStr = _songListModel.title;
    }else if(_sortModel)
    {
        self.imgStr = _sortModel.big_image;
        self.descStr = _sortModel.desc;
        self.titleStr = _sortModel.title;

    }else if(_musicModel){
        self.imgStr = _musicModel.picUrl;
        self.descStr = _musicModel.albunName;
        self.titleStr = _musicModel.name;
     
    }else
    {
        self.imgStr = _singerOneModel.pic_url;
//        self.descStr = _singerOneModel.;
        self.titleStr = _singerOneModel.singer_name;

    }
}

- (void)headerView
{
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.width / 2)];
    
    CGSize size = self.imgView.frame.size;
    
//    self.imgView.backgroundColor = [UIColor blueColor];
    
    self.listName = [[UILabel alloc] initWithFrame:CGRectMake(20, size.height - 70, size.width - 40, 40)];
//    self.listName.backgroundColor = [UIColor yellowColor];
    self.listName.textColor = [UIColor whiteColor];
    [self.listName setFont:[UIFont systemFontOfSize:20]];
    self.desc = [[UILabel alloc] initWithFrame:CGRectMake(20, size.height - 30, size.width - 40, 20)];
//    self.desc.backgroundColor = [UIColor whiteColor];
    self.desc.textColor= [UIColor whiteColor];
    [self.desc setFont:[UIFont systemFontOfSize:15]];
    
    [self.imgView addSubview:self.listName];
    [self.imgView addSubview:self.desc];
    self.tableView.tableHeaderView = self.imgView;
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(10, 20, 60,50);
//    button.backgroundColor = [UIColor clearColor];
//    [button setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(backVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
}

//- (void)backVC:(UIButton *)sender
//{   self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController popoverPresentationController];
//    
//}


- (void)getDataSourceFromServer{

AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];

    NSString *urlStr =[NSString stringWithFormat:@"http://api.songlist.ttpod.com/songlists/%@?app=ttpod&v=v8.0.1.2015091618&uid=&mid=iPhone8%%2C1&f=f320&s=s310&imsi=&hid=&splus=9.0.2&active=1&net=2&openudid=984cbc2781aa37aa9c6051f63e4ff3ac4e56b986&idfa=668C0E40-ED87-4C0A-87E6-6B7EA39E5EDC&utdid=ViJMC0D93pgDADXkd0DhpM1Y&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=", self.songListModel._id];
    
    NSString *urlSort = [NSString stringWithFormat:@"http://api.songlist.ttpod.com/ranklists/%@/current?app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%%2C2&f=f320&s=s310&imsi=&hid=&splus=8.4.1&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=", self.sortModel.ranklist_id];
    NSString *urlNew = [NSString stringWithFormat:@"http://api.songlist.ttpod.com/songlists/%@?app=ttpod&v=v8.0.1.2015091618&uid=&mid=iPhone8%%2C1&f=f320&s=s310&imsi=&hid=&splus=9.0.2&active=1&net=2&openudid=984cbc2781aa37aa9c6051f63e4ff3ac4e56b986&idfa=668C0E40-ED87-4C0A-87E6-6B7EA39E5EDC&utdid=ViJMC0D93pgDADXkd0DhpM1Y&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=", _musicModel.value];
    NSString *urlSinger = [NSString stringWithFormat:@"http://api.dongting.com/song/singer/%lld/songs?page=1&size=50&app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%%2C2&f=f320&s=s310&imsi=&hid=&splus=8.4.1&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=",_singerOneModel.singer_id];
__weak typeof(self) myType =  self;
manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];

    NSString * str = self.songListModel._id ? urlStr : urlSort;
    str = _musicModel.value ? urlNew: str;
    
    str = _singerOneModel.singer_id ? urlSinger :str;
    [manager GET: str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    

    
    
    [myType playerRadio:responseObject];
    
    
    
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%@", error);
    
}];
    
    
}
- (void)playerRadio:(NSDictionary *)data
{
    
    NSMutableArray *musicArray = [@[] mutableCopy];
    for (NSDictionary *dic in data[@"songs"] ? data[@"songs"] :data[@"data"]) {
        
        MusicModel *model = [[MusicModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.picUrl = data[@"image"][@"pic"];
        if ([dic[@"auditionList"] count]) {
            
            
            model.url = dic[@"auditionList"][0][@"url"];
            
            
        }
     
        [musicArray addObject:model];
    }
    self.musicList = musicArray;


    [self.tableView reloadData];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgStr]];
    self.listName.text = self.titleStr;
    self.desc.text = self.descStr;

}




#pragma mark -- delgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    
    MusicModel *model = self.musicList[indexPath.row];
    
    NSString *str = (model.name ? model.name :model.albunName) ? (model.name ? model.name :model.albunName) :model.song_name;
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    
    (id)str != [NSNull null] ?  cell.textLabel.text = str : nil;
    cell.detailTextLabel.text = model.singerName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicModel *model = self.musicList[indexPath.row];
    model.picUrl = self.imgStr;
    if (self.musicPlayerController.musicModel != model) {
        if (self.musicPlayerController.player.isProcessing) {
            [self.musicPlayerController.player stop];
        }
        
        self.musicPlayerController.musicModel = model;
        [self.musicPlayerController.musicList insertObject:model atIndex:0];
        NSLog(@"change model.name:%@",self.musicPlayerController.musicModel.name);
        self.musicPlayerController.player.url =[NSURL URLWithString:model.url];
        [self.musicPlayerController.player play];
    }
}


#pragma mark-- TableHeaderViewdelegate
- (void)playerAllSong
{
    
    for (int i = (int)self.musicList.count - 1; i >= 0 ; i--) {
      
        MusicModel *model = self.musicList[i];
        [self.musicPlayerController.musicList insertObject:model atIndex:0];
    }
    
    
    
    MusicModel *model = self.musicList[0];
    if (self.musicPlayerController.musicModel != model) {
        if (self.musicPlayerController.player.isProcessing) {
            [self.musicPlayerController.player stop];
        }
        
        self.musicPlayerController.musicModel = model;
    
        NSLog(@"change model.name:%@",self.musicPlayerController.musicModel.name);
        self.musicPlayerController.player.url =[NSURL URLWithString:model.url];
        [self.musicPlayerController.player play];
    }

}

- (void)downLoadAllSong
{
    self.tableView.editing = !self.tableView.isEditing;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    TableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    view.delegate = self;
    
    return view;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.musicList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
