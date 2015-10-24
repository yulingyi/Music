//
//  RedioModel.h
//  Music
//
//  Created by laouhn on 15/10/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedioModel : NSObject

@property (nonatomic, copy) NSString *large_pic_url;
@property (nonatomic, copy) NSString *pic_url_240_200;
@property (nonatomic, copy) NSString *small_pic_url;
@property (nonatomic, copy) NSString *tag_name;
@property (nonatomic, strong) NSNumber *listen_count;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *tag_id;

@end
