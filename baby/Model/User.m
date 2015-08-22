//
//  User.m
//  baby
//
//  Created by zhang da on 14-2-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "User.h"
#import "MemContainer.h"


@implementation User

@dynamic _id;
@dynamic name;
@dynamic nickName;
@dynamic avatarBig;
@dynamic avatarMid;
@dynamic avatarSmall;
@dynamic homeCover;
@dynamic fanCnt;
@dynamic friendCnt;
@dynamic galleryCnt;
@dynamic cityId;
@dynamic creatTime;
@dynamic birthday;
@dynamic gender;
@dynamic qq;
@dynamic isTeacher;
@dynamic weixin;
@dynamic commentMessage;
@dynamic aMessage;
@dynamic friendMessage;
@dynamic activityMessage;
@dynamic systemMessage;

@synthesize following;

+ (NSString *)primaryKey {
    return @"_id";
}

+ (NSDictionary *)mapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
                @"_id": @"id",
                } retain];
    }
    return map;
}

+ (User *)getUserWithId:(long)_id {
    return (User *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                          clazz:[User class]];
}

- (NSString *)showName {
    return self.nickName? self.nickName: self.name;
}

- (int)age {
    if (self.birthday) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)self.birthday/1000];
        return ([[NSDate date] timeIntervalSinceDate:date])/(60*60*24*365);
    }
    return 0;
}

@end
