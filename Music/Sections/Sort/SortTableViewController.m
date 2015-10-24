//
//  SortTableViewController.m
//  Music
//
//  Created by laouhn on 15/10/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "SortTableViewController.h"
#import "AFNetworking.h"
#import "SortModel.h"
#import "MusicModel.h"
#import "SortTableViewCell.h"
#import "songListViewController.h"
@interface SortTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) NSArray *sectionData;
@end

@implementation SortTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"排行榜";
//    self.view.backgroundColor = [UIColor redColor];
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
   
//    [self.tableView reloadData];
     [self getDataSourceFromServer];
  
}


- (void)getDataSourceFromServer
{
    NSString *urlStr = @"http://api.songlist.ttpod.com/channels/bhb/children?app=ttpod&v=v8.0.0.2015083118&uid=&mid=iPhone7%2C2&f=f320&s=s310&imsi=&hid=&splus=8.4.1&active=1&net=2&openudid=4e46139e06b327805219f26271bcd6f069fa2160&idfa=B8142F1A-4B7D-4D41-B497-FAEB5B824D8D&utdid=VfYr7eF1pX8DAGNg94gQOAGx&alf=201200&bundle_id=com.ttpod.music&latitude=&longtitude=";
    
    AFHTTPRequestOperationManager *manage  =    [AFHTTPRequestOperationManager manager];
    
    
    __block typeof(self) myself = self;
    [manage GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [myself loadDataFromNet:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)loadDataFromNet:(id)data
{
//    self.sectionData = data;
    for (int i = 0; i < 3; i++) {
        NSArray *dataAry = data[i][@"refs"];
        NSMutableArray *dataSection = [@[] mutableCopy];
        for (NSDictionary *dic in dataAry) {
            SortModel *model = [[SortModel alloc] init];
            
            model.big_image = dic[@"big_image"][@"pic"];
            model.desc = dic[@"desc"];
            model.image = dic[@"image"][@"pic"];
            model.song_count = dic[@"song_count"];
            model.songlist_id = dic[@"songlist_id"];
            model.title = dic[@"title"];
            model.ranklist_id = dic[@"ranklist_id"];
            model.songs = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary * dicSong in dic[@"songs"]) {
                MusicModel *modelSong = [[MusicModel alloc] init];
                
                [modelSong setValuesForKeysWithDictionary:dicSong];
                [model.songs addObject:modelSong];
                
            }
            
            [dataSection addObject:model];
            
        }
        [self.dataSource addObject:dataSection];
        

    }
       [self.tableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   SortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    
    cell.model = self.dataSource[indexPath.section][indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = [self.tableView indexPathForCell:sender];
    
    songListViewController *vc = segue.destinationViewController;
    
    vc.sortModel = self.dataSource[index.section][index.row];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"官方榜";
    }
    if (section == 1){
       return @"特色榜";
    }
 
    return @"全球榜";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
