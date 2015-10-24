//
//  MusicModel.h
//  Music
//
//  Created by laouhn on 15/10/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic, strong) NSNumber *albumld;
@property (nonatomic, copy) NSString *albunName;
@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, strong) NSNumber *singerId;
@property (nonatomic, strong) NSNumber *songId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *song_name;
@property (nonatomic, strong) NSNumber *value;





@end
