//
//  CommentCell.h
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULTCOMMENT_HEIGHT 60
#define DEFAULTVOICE_WIDTH 80
#define DEFAULTFONT 13

@class ImageView;
@class LCommentCell;


@protocol LCommentCellDelegate <NSObject>

@required
- (void)playVoice:(LCommentCell *)cell url:(NSString *)voicePath;
- (void)deleteComment:(long)commentId;
@end


@interface LCommentCell : UITableViewCell {

    ImageView *avatar;
    UIImageView *playIndicator;
    UILabel *contentLabel, *voiceLength;
    UIButton *voiceBtn;
    UIActivityIndicatorView *loading;
    
    UIButton *deleteBtn, *replyBtn;

}

@property (nonatomic, assign) long commentId;
@property (nonatomic, assign) bool loadingVoice;
@property (nonatomic, assign) id<LCommentCellDelegate> delegate;

- (void)updateLayout;
+ (float)height:(long)commentId;

@end
