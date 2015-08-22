//
//  GalleryCell.m
//  baby
//
//  Created by zhang da on 14-3-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "GalleryCell.h"
#import "ImageView.h"
#import "UIImageButton.h"
#import "User.h"
#import "Gallery.h"
#import "Picture.h"
#import "GalleryPictureLK.h"
#import "ConfigManager.h"
#import "Session.h"

#import "GalleryTask.h"
#import "LKTask.h"
#import "TaskQueue.h"


#import "ImageDetailView.h"

@interface GalleryCell() {
    UIView *bg;
}

@property (nonatomic, retain) Gallery *gallery;

@end



@implementation GalleryCell

- (void)dealloc {
    self.gallery = nil;
    self.userInfoDelegate = nil;
    self.delegate = nil;
    
    [pictureViews release];
    pictureViews = nil;
    
    [super dealloc];
}

- (void)setGalleryId:(long)galleryId {
    if (_galleryId != galleryId) {
        _galleryId = galleryId;
        self.gallery = nil;
    }
}

- (void)setUserInfoDelegate:(id<UserVoiceInfoViewDelegate>)userInfoDelegate {
    if (_userInfoDelegate != userInfoDelegate) {
        _userInfoDelegate = userInfoDelegate;
        
        user.delegate = self.userInfoDelegate;
        commentator.delegate = self.userInfoDelegate;
    }
}

- (void)setPlayingComment:(bool)playingComment {
    if (_playingComment != playingComment) {
        _playingComment = playingComment;
        
        commentator.isPlaying = _playingComment;
    }
}

- (void)setPlayingIntro:(bool)playingIntro {
    if (_playingIntro != playingIntro) {
        _playingIntro = playingIntro;
        
        user.isPlaying = _playingIntro;
    }
}

- (void)setCurrentIndex:(int)currentIndex {
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
    }
}

- (Gallery *)gallery {
    //NSLog(@"call getter: %@, %d", _gallery, self.galleryId);
    if (!_gallery && self.galleryId > 0) {
        self.gallery = [Gallery getGalleryWithId:self.galleryId];
    }
    return _gallery;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 374)];
        bg.backgroundColor = [Shared bbRealWhite];
        [self addSubview:bg];
        [bg release];
        
        galleryHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
        galleryHolder.pagingEnabled = YES;
        galleryHolder.backgroundColor = [Shared bbRealWhite];
        galleryHolder.alwaysBounceHorizontal = YES;
        galleryHolder.delegate = self;
        galleryHolder.showsHorizontalScrollIndicator = NO;
        galleryHolder.contentSize = CGSizeMake(320, 220);
        [self addSubview:galleryHolder];
        [galleryHolder release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTaped:)];
        [galleryHolder addGestureRecognizer:tap];
        [tap release];
        
        paging = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 200, 320, 20)];
        paging.hidesForSinglePage = YES;
        paging.userInteractionEnabled = NO;
        [self addSubview:paging];
        [paging release];
        
        pictureViews = [[NSMutableArray alloc] init];
        pictures = [[NSMutableArray alloc] init];
        
        user = [[UserVoiceInfoView alloc] initWithFrame:CGRectMake(0, 220, 160, 75)];
        user.isComment = NO;
        user.backgroundColor = [Shared bbRealWhite];
        [self addSubview:user];
        [user release];
        
        commentator = [[UserVoiceInfoView alloc] initWithFrame:CGRectMake(160, 220, 160, 72)];
        commentator.isComment = YES;
        commentator.backgroundColor = [Shared bbRealWhite];
        [self addSubview:commentator];
        [commentator release];
        
        topic = [[UILabel alloc] initWithFrame:CGRectMake(10, 295, 300, 17)];
        topic.backgroundColor = [Shared bbRealWhite];
        topic.textColor = [UIColor grayColor];
        topic.font = [UIFont systemFontOfSize:16];
        topic.text = @"";
        [self addSubview:topic];
        [topic release];
        
        //        timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 200, 80, 14)];
        //        timestampLabel.backgroundColor = [UIColor clearColor];
        //        timestampLabel.font = [UIFont systemFontOfSize:12];
        //        timestampLabel.textColor = [Shared bbYellow];
        //        timestampLabel.textAlignment = NSTextAlignmentRight;
        //        [self addSubview:timestampLabel];
        //        [timestampLabel release];
        
        likeBtn = [[UIImageButton alloc] initWithFrame:CGRectMake(0, 317, 108, 55)
                                                 image:@"icon_heart.png"
                                           imageHeight:18
                                                  text:@"0"
                                              fontSize:16];
        likeBtn.backgroundColor = [Shared bbRealWhite];
        likeBtn.textNormalColor = [Shared bbYellow];
        likeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        likeBtn.layer.borderWidth = 2.0f;
        likeBtn.layer.masksToBounds = NO;
        [likeBtn addTarget:self action:@selector(likeGallery) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeBtn];
        [likeBtn release];
        
        commentBtn = [[UIImageButton alloc] initWithFrame:CGRectMake(107, 317, 107, 55)
                                                    image:@"icon_comment.png"
                                              imageHeight:18
                                                     text:@"0"
                                                 fontSize:16];
        commentBtn.backgroundColor = [Shared bbRealWhite];
        commentBtn.textNormalColor = [Shared bbYellow];
        commentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        commentBtn.layer.borderWidth = 1.0f;
        commentBtn.layer.masksToBounds = NO;
        commentBtn.userInteractionEnabled = NO;
        [self addSubview:commentBtn];
        [commentBtn release];
        
        shareBtn = [[UIImageButton alloc] initWithFrame:CGRectMake(214, 317, 107, 55)
                                                  image:@"icon_share.png"
                                            imageHeight:18
                                                   text:@""
                                               fontSize:16];
        shareBtn.backgroundColor = [Shared bbRealWhite];
        shareBtn.textNormalColor = [Shared bbYellow];
        shareBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        shareBtn.layer.borderWidth = 1.0f;
        shareBtn.layer.masksToBounds = NO;
        [shareBtn addTarget:self action:@selector(shareGallery) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        [shareBtn release];
        
        deleteBtn = [[UIImageButton alloc] initWithFrame:CGRectMake(320, 317, 80, 55)
                                                   image:@"icon_delete.png"
                                             imageHeight:18
                                                    text:@""
                                                fontSize:16];
        deleteBtn.backgroundColor = [Shared bbRealWhite];
        deleteBtn.textNormalColor = [Shared bbYellow];
        deleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        deleteBtn.layer.borderWidth = 1.0f;
        deleteBtn.layer.masksToBounds = NO;
        [deleteBtn addTarget:self action:@selector(deleteGallery) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        [deleteBtn release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (ImageView *)viewForReuse {
    ImageView *view = nil;
    for (ImageView *v in pictureViews) {
        if (![v superview]) {
            view = v;
            break;
        }
    }
    
    if (!view) {
        view = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
        view.backgroundColor = [Shared bbRealWhite];
        view.clipsToBounds = YES;
        view.userInteractionEnabled = YES;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.imagePath = self.gallery.cover;
        [pictureViews addObject:view];
        [view release];
    }
    return view;
}

- (void)updateScrollView {
    for (ImageView *v in pictureViews) {
        [v removeFromSuperview];
    }
    
    paging.numberOfPages = self.gallery.pictureCnt;
    [pictures removeAllObjects];
    
    //prepare data
    NSArray *gPictures = [GalleryPictureLK getPicturesForGallery:self.galleryId];
    //NSLog(@"gid:%d, cnt:%d detailCnt:%d", self.galleryId, self.gallery.pictureCnt, gPictures.count);
    [pictures addObjectsFromArray:gPictures];
    
    for (int i = 0 ; i < pictures.count; i ++ ) {
        ImageView *view = [self viewForReuse];
        view.frame = CGRectMake(320*i, 0, 320, 220);
        [galleryHolder addSubview:view];
        
        GalleryPictureLK *lk = [pictures objectAtIndex:i];
        Picture *pic = [Picture getPictureWithId:lk.pictureId];
        //NSLog(@"set image path in cell: %@", pic? pic.imageMid: @"");
        view.imagePath = pic? pic.imageMid: nil;
    }
    
    galleryHolder.scrollEnabled = (pictures.count != 1);
    
    galleryHolder.contentSize = CGSizeMake(320*pictures.count, 220);
    if (self.currentIndex < pictures.count) {
        galleryHolder.contentOffset = CGPointMake(320*self.currentIndex, 0);
    }
    
}

- (void)loadFullGallery {
    NSArray *gPictures = [GalleryPictureLK getPicturesForGallery:self.galleryId];
    if (!gPictures || gPictures.count == 0) {
        GalleryTask *task = [[GalleryTask alloc] initGalleryDetail:self.galleryId];
        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                int galleryId = [[(NSDictionary *)userInfo objectForKey:@"galleryId"] intValue];
                if (galleryId == self.galleryId) {
                    [self updateLayout];
                }
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
    
}

- (void)likeGallery {
    if ([[ConfigManager me] getSession]) {
        
        CallbackBlock likeBlock = ^(bool succeeded, id userInfo) {
            if (succeeded && self.gallery.liked) {
                LKTask *lkTask = [[LKTask alloc] initGalleryRelation:self.galleryId
                                                                like:![self.gallery.liked boolValue]];
                lkTask.logicCallbackBlock = ^(bool succeeded, id userInfo) {
                    if (succeeded) {
                        likeBtn.text.text = [NSString stringWithFormat:@"%ld", self.gallery.likeCnt];
                    } else {
                        
                    }
                };
                [TaskQueue addTaskToQueue:lkTask];
                [lkTask release];
            }
        };
        
        if (!self.gallery.liked) {
            GalleryTask *task = [[GalleryTask alloc] initGalleryDetail:self.galleryId];
            task.logicCallbackBlock = likeBlock;
            [TaskQueue addTaskToQueue:task];
            [task release];
        } else {
            likeBlock(YES, nil);
        }
    }
}

- (void)deleteGallery {
    if (self.delegate && self.galleryId) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"确认删除？删除后将无法恢复!"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        [alert show];
        [alert release];
    }
}

- (void)shareGallery {
    if (self.delegate
        && self.galleryId
        && [self.delegate respondsToSelector:@selector(shareGallery:)]) {
        [self.delegate shareGallery:self.galleryId];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.delegate deleteGallery:self.galleryId];
    }
}

- (void)updateLayout {
    user.galleryId = self.galleryId;
    user.page = self.currentIndex;
    user.isComment = NO;
    if (pictures.count > self.currentIndex) {
        GalleryPictureLK *lk = [pictures objectAtIndex:self.currentIndex];
        Picture *pic = [Picture getPictureWithId:lk.pictureId];
        user.voiceLength = pic.voiceLength;
    } else {
        user.voiceLength = self.gallery.introLength;
    }
    [user updateLayout];
    
    commentator.galleryId = self.galleryId;
    commentator.isComment = YES;
    commentator.voiceLength = self.gallery.commentLength;
    [commentator updateLayout];
    
    //timestampLabel.text = [TOOL prettyStringFromUnixTime:self.gallery.createTime];
    
    CGSize textSize = [self.gallery.content sizeWithFont:[UIFont systemFontOfSize:16]
                                                forWidth:300
                                           lineBreakMode:NSLineBreakByWordWrapping];
    topic.text = self.gallery.content;
    topic.frame = CGRectMake(10, 295, 300, textSize.height);
    
    likeBtn.text.text = [NSString stringWithFormat:@"%ld", self.gallery.likeCnt];
    [likeBtn centerContent];
    
    commentBtn.text.text = [NSString stringWithFormat:@"%ld", self.gallery.commentCnt];
    [commentBtn centerContent];
    
    if (self.gallery.content.length < 1) {
        textSize.height = -3;
    }
    float y = 295 + textSize.height + 3;
    if (self.gallery.userId == [ConfigManager me].userId) {
        likeBtn.frame = CGRectMake(0, y, 81, 55);
        commentBtn.frame = CGRectMake(80, y, 80, 55);
        shareBtn.frame = CGRectMake(160, y, 80, 55);
        deleteBtn.frame = CGRectMake(240, y, 80, 55);
    } else {
        likeBtn.frame = CGRectMake(0, y, 108, 55);
        commentBtn.frame = CGRectMake(107, y, 107, 55);
        shareBtn.frame = CGRectMake(214, y, 107, 55);
        deleteBtn.frame = CGRectMake(320, y, 80, 55);
    }
    
    bg.frame = CGRectMake(0, 0, 320, y+55);
    
    [self updateScrollView];
}

+ (float)cellHeight:(NSString *)content {
    CGSize textSize = [content sizeWithFont:[UIFont systemFontOfSize:16]
                                   forWidth:300
                              lineBreakMode:NSLineBreakByWordWrapping];
    if (content.length < 1) {
        textSize.height = -3;
    }
    
    return 295 + textSize.height + 3 + 56 + 5;
}

- (void)scrollViewTaped:(UITapGestureRecognizer *)tap {
    NSLog(@"tapped");
    
    ImageDetailView *detail = [[ImageDetailView alloc] initWithFrame:delegate.window.bounds];
    detail.backgroundColor = [Shared bbRealWhite];
    
    for (UIView *view in [galleryHolder subviews]) {
        if ([view isKindOfClass:[ImageView class]]) {
            int page = (int)((view.frame.origin.x / galleryHolder.bounds.size.width));
            if (page == paging.currentPage) {
                GalleryPictureLK *lk = [pictures objectAtIndex:page];
                Picture *pic = [Picture getPictureWithId:lk.pictureId];
                [detail setImagePath:pic.imageBig];
                //[detail setImage:((ImageView *)view).image];
            }
        }
    }
    
    [delegate.window addSubview:detail];
    [detail release];
}


#pragma uiscorllview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.width > 320) {
        int newpage = (int)((galleryHolder.contentOffset.x / galleryHolder.bounds.size.width));
        if (paging.currentPage != newpage) {
            paging.currentPage = newpage;
            user.page = paging.currentPage;
            self.currentIndex = paging.currentPage;
            
            GalleryPictureLK *lk = [pictures objectAtIndex:user.page];
            Picture *pic = [Picture getPictureWithId:lk.pictureId];
            user.voiceLength = pic.voiceLength;
        }
    }
}


@end
