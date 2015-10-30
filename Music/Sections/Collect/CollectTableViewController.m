//
//  CollectTableViewController.m
//  Music
//
//  Created by laouhn on 15/10/26.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "CollectTableViewController.h"
#import "MusicPlayerController.h"
#import "MusicModel.h"
@interface CollectTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) MusicPlayerController *musicPlayerController;
@end

@implementation CollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"我的收藏";
    self.musicPlayerController = [MusicPlayerController shareMusicPlayerController];
    self.dataSource = self.musicPlayerController.musicList;
}


- (IBAction)deleteAction:(UIBarButtonItem *)sender {
    
    if (self.tableView.isEditing) {
        self.tableView.editing = NO;
        sender.title = @"管理";
        
    }else
    {
        self.tableView.editing = YES;
        sender.title = @"取消";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MusicModel *model = self.dataSource[indexPath.row];
    
    NSString *str = (model.name ? model.name :model.albunName) ? (model.name ? model.name :model.albunName) :model.song_name;
    
    (id)str != [NSNull null] ?  cell.textLabel.text = str : nil;
    (id)model.singerName != [NSNull null] ? cell.detailTextLabel.text = model.singerName : nil;
    

    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicModel  *model = self.dataSource[indexPath.row];
    if (self.musicPlayerController.musicModel != model) {
        if (self.musicPlayerController.player.isProcessing) {
            [self.musicPlayerController.player stop];
        }
        
        self.musicPlayerController.musicModel = model;
        
        
        self.musicPlayerController.player.url =[NSURL URLWithString:model.url];
        [self.musicPlayerController.player play];
    }

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        [self.musicPlayerController removeFromSQLWith:self.dataSource[indexPath.row]];
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
