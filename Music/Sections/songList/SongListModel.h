//
//  SongListModel.h
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongListModel : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSNumber *listen_count;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, copy) NSString *song_list;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, strong) NSNumber *create_at;
@property (nonatomic, strong) NSNumber *quan_id;
@end
