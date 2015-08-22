//
//  GalleryTask.m
//  baby
//
//  Created by zhang da on 14-3-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "GalleryTask.h"
#import "Gallery.h"
#import "Picture.h"
#import "User.h"
#import "GComment.h"
#import "MemContainer.h"
#import "GalleryPictureLK.h"
#import "ConfigManager.h"

#import "Session.h"

#import "GalleryTask.h"
#import "TaskQueue.h"

@implementation GalleryTask

- (void)dealloc {
    
    [super dealloc];
}

- (id)initGalleryList:(bool)singlePage page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"gallery_query"];
        [self addParameter:@"single_page" value:singlePage? @"1": @"0"];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *galleries = [userInfo objectForKey:@"galleries"];
                
                if (galleries && galleries.count > 0) {
                    NSMutableArray *galleryIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *galleryDict in galleries) {
                        NSDictionary *userDict = [galleryDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        
                        NSDictionary *commDict = [galleryDict objectForKey:@"commentator"];
                        [[MemContainer me] instanceFromDict:commDict clazz:[User class]];
 
                        Gallery *g = (Gallery *)[[MemContainer me] instanceFromDict:galleryDict clazz:[Gallery class]];
                        [galleryIds addObject:@(g._id)];
                    }
                    [self doLogicCallBack:YES info:[galleryIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:dict];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initRecommendGalleryList {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"gallery_Recommend"];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *galleries = [userInfo objectForKey:@"galleries"];
                
                if (galleries && galleries.count > 0) {
                    NSMutableArray *galleryList = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *galleryDict in galleries) {
                        NSDictionary *userDict = [galleryDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        
                        NSDictionary *commDict = [galleryDict objectForKey:@"commentator"];
                        [[MemContainer me] instanceFromDict:commDict clazz:[User class]];

                        Gallery *g = (Gallery *)[[MemContainer me] instanceFromDict:galleryDict clazz:[Gallery class]];
                        [galleryList addObject:g];
                    }
                    [self doLogicCallBack:YES info:[galleryList autorelease]];
                } else {
                    [self doLogicCallBack:YES info:dict];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initTopicGalleryList:(long)topicId page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"gallery_hot"];
        [self addParameter:@"topic_id" value:[NSString stringWithFormat:@"%ld", topicId]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSArray *galleries = [userInfo objectForKey:@"galleries"];
                
                if (galleries && galleries.count > 0) {
                    NSMutableArray *galleryIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *galleryDict in galleries) {
                        NSDictionary *userDict = [galleryDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        
                        NSDictionary *commDict = [galleryDict objectForKey:@"commentator"];
                        [[MemContainer me] instanceFromDict:commDict clazz:[User class]];

                        Gallery *g = (Gallery *)[[MemContainer me] instanceFromDict:galleryDict clazz:[Gallery class]];
                        [galleryIds addObject:@(g._id)];
                    }
                    [self doLogicCallBack:YES info:[galleryIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initCityGalleryList:(int)cityId page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"gallery_hot"];
        [self addParameter:@"city_id" value:[NSString stringWithFormat:@"%d", cityId]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSArray *galleries = [userInfo objectForKey:@"galleries"];
                
                if (galleries && galleries.count > 0) {
                    NSMutableArray *galleryIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *galleryDict in galleries) {
                        NSDictionary *userDict = [galleryDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        
                        NSDictionary *commDict = [galleryDict objectForKey:@"commentator"];
                        [[MemContainer me] instanceFromDict:commDict clazz:[User class]];
                        
                        Gallery *g = (Gallery *)[[MemContainer me] instanceFromDict:galleryDict clazz:[Gallery class]];
                        [galleryIds addObject:@(g._id)];
                    }
                    [self doLogicCallBack:YES info:[galleryIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initUserGalleryList:(long)userId page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"gallery_query"];
        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%ld", userId]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *galleries = [dict objectForKey:@"galleries"];
                
                if (galleries && galleries.count > 0) {
                    NSMutableArray *galleryIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *galleryDict in galleries) {
                        NSDictionary *userDict = [galleryDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        
                        Gallery *g = (Gallery *)[[MemContainer me] instanceFromDict:galleryDict clazz:[Gallery class]];
                        [galleryIds addObject:@(g._id)];
                    }
                    [self doLogicCallBack:YES info:[galleryIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initLikeGalleryListAtPage:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"gallery_Like"];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *galleries = [dict objectForKey:@"galleries"];
                
                if (galleries && galleries.count > 0) {
                    NSMutableArray *galleryIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *galleryDict in galleries) {
                        NSDictionary *userDict = [galleryDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        
                        Gallery *g = (Gallery *)[[MemContainer me] instanceFromDict:galleryDict clazz:[Gallery class]];
                        [galleryIds addObject:@(g._id)];
                    }
                    [self doLogicCallBack:YES info:[galleryIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}


- (id)initDeleteGallery:(long)galleryId {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"gallery_delete"];
        [self addParameter:@"gallery_id" value:[NSString stringWithFormat:@"%ld", galleryId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                [self doLogicCallBack:YES info:nil];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initGCommentList:(long)galleryId page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"gcomment_Query"];
        [self addParameter:@"gallery_id" value:[NSString stringWithFormat:@"%ld", galleryId]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *comments = [dict objectForKey:@"comments"];
                
                if (comments && comments.count > 0) {
                    NSMutableArray *commentIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *commentDict in comments) {
                        NSDictionary *userDict = [commentDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];

                        GComment *g = (GComment *)[[MemContainer me] instanceFromDict:commentDict clazz:[GComment class]];
                        [commentIds addObject:@(g._id)];
                    }
                    [self doLogicCallBack:YES info:[commentIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initGCommentList:(long)userId {
//    self = [super initWithUrl:SERVERURL method:POST];
    self = [super initWithUrl:SERVERURL method:GET session:[[ConfigManager me] getSession].session];
    if (self) {
        NSLog(@"%ld", userId);
        [self addParameter:@"action" value:@"gcomment_query1"];
        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%d", userId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *comments = [dict objectForKey:@"comments"];
                
                if (comments && comments.count > 0) {
                    NSMutableArray *commentIds = [[NSMutableArray alloc] initWithCapacity:0];
                    
                    for (NSDictionary *commentDict in comments) {
                        NSDictionary *userDict = [commentDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        
                        GComment *g = (GComment *)[[MemContainer me] instanceFromDict:commentDict clazz:[GComment class]];
                        [commentIds addObject:g];

                    }
                    
                    [self doLogicCallBack:YES info:[commentIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initGalleryDetail:(long)galleryId {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"gallery_query"];
        [self addParameter:@"gallery_id" value:[NSString stringWithFormat:@"%ld", galleryId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                
                if ([dict objectForKey:@"liked"]) {
                    Gallery *g = [Gallery getGalleryWithId:galleryId];
                    g.liked = [dict objectForKey:@"liked"];
                }
                
                NSDictionary *gallery = [dict objectForKey:@"gallery"];
                NSArray *LKs = [gallery objectForKey:@"pictures"];
                
                if (LKs && LKs.count > 0) {
                    for (NSDictionary *pictureLKDict in LKs) {
                        [[MemContainer me] instanceFromDict:pictureLKDict clazz:[GalleryPictureLK class]];
                        if ([pictureLKDict objectForKey:@"picture"]) {
                            [[MemContainer me] instanceFromDict:[pictureLKDict objectForKey:@"picture"]
                                                          clazz:[Picture class]];
                        }
                    }
                    [self doLogicCallBack:YES info:@{@"galleryId": @(galleryId)}];
                } else {
                    [self doLogicCallBack:YES info:dict];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initDeleteGComment:(long)commentId {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"gcomment_delete"];
        [self addParameter:@"comment_id" value:[NSString stringWithFormat:@"%ld", commentId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                [self doLogicCallBack:YES info:nil];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}


@end
