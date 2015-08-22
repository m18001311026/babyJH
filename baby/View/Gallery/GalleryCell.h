//
//  GalleryCell.h
//  baby
//
//  Created by zhang da on 14-3-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVoiceInfoView.h"


@protocol GalleryCellDelegate <NSObject>
@required
- (void)deleteGallery:(long)galleryId;
- (void)shareGallery:(long)galleryId;
@end


@class UIImageButton;
@class ImageView;

@interface GalleryCell : UITableViewCell <UIScrollViewDelegate, UIAlertViewDelegate> {
    
    UIScrollView *galleryHolder;
    NSMutableArray *pictureViews;
    NSMutableArray *pictures;
    UIPageControl *paging;

    UserVoiceInfoView *user, *commentator;
    UILabel *topic;
    UILabel *timestampLabel;
    UIImageButton *likeBtn, *commentBtn, *shareBtn, *deleteBtn;
    
}

@property (nonatomic, assign) id<GalleryCellDelegate> delegate;
@property (nonatomic, assign) long galleryId;
@property (nonatomic, assign) id<UserVoiceInfoViewDelegate> userInfoDelegate;
@property (nonatomic, assign) bool playingIntro;
@property (nonatomic, assign) bool playingComment;
@property (nonatomic, assign) int currentIndex;

- (void)updateLayout;
- (void)loadFullGallery;
+ (float)cellHeight:(NSString *)content;

@end
