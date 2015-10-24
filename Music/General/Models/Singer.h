//
//  Singer.h
//  Music
//
//  Created by laouhn on 15/10/24.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Singer : NSManagedObject

@property (nonatomic) int64_t singer_id;
@property (nonatomic, retain) NSString * pic_url;
@property (nonatomic, retain) NSString * singer_name;

@end
