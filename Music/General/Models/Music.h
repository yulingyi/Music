//
//  Music.h
//  Music
//
//  Created by laouhn on 15/10/24.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Music : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * albumld;
@property (nonatomic, retain) NSString * albunName;
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSString * singerName;
@property (nonatomic) int64_t singerId;
@property (nonatomic) int64_t songId;
@property (nonatomic) int64_t url;
@property (nonatomic, retain) NSString * song_name;
@property (nonatomic) int64_t value;

@end
