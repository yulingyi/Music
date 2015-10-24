//
//  HomeTableViewController.m
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "HomeTableViewController.h"
#import "MusicModel.h"
#import "topHeaderModel.h"
#import "AFNetworking.h"
#import "TopHomeCollectionReusableView.h"
#import "ONECollectionViewCell.h"
@interface HomeTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *dataSource;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
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
    
    ((TopHomeCollectionReusableView *)self.tableView.tableHeaderView).modelAry = self.dataSource[@"top"];
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// #warning Incomplete method implementation.
    // Return the number of rows in the section.
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
        return 0;
    }
    
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_home_one" forIndexPath:indexPath];
    
    return cell;
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
