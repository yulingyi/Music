//
//  TableHeaderView.h
//  Music
//
//  Created by laouhn on 15/10/24.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableHeaderViewdelegate <NSObject>

- (void)playerAllSong;
- (void)downLoadAllSong;

@end

@interface TableHeaderView : UITableViewHeaderFooterView


@property (nonatomic, strong) UIButton *playerLabel;
@property (nonatomic, strong) UIButton *downLoadLabel;
@property (nonatomic, assign) id <TableHeaderViewdelegate> delegate;

@end
