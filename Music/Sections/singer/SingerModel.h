//
//  SingerModel.h
//  Music
//
//  Created by laouhn on 15/10/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingerModel : NSObject

@property (nonatomic, copy) NSString *big_pic_url;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *singerID;
@property (nonatomic, strong) NSNumber *style;
@property (nonatomic, strong) NSNumber *type;
@end
