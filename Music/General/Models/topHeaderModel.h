//
//  topHeaderModel.h
//  Music
//
//  Created by laouhn on 15/10/20.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface topHeaderModel : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSNumber *musicID;
@property (nonatomic, strong) NSNumber *listenCount;
@property (nonatomic, copy)  NSString *name;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, strong) NSNumber *comments;


@end
