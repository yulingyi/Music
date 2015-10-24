//
//  SortModel.h
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortModel : NSObject


@property (nonatomic, copy) NSString *big_image;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSNumber *songlist_id;
@property (nonatomic, copy) NSNumber *song_count;
@property (nonatomic, strong) NSMutableArray *songs;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *ranklist_id;


@end
