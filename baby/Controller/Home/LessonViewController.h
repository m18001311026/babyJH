//
//  LessonViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TabbarSubviewController.h"
#import "PullTableView.h"
#import "SimpleSegment.h"
#import "LessonCell.h"
#import "ImagePlayerView.h"

@class LessonHeader;

@interface LessonViewController : TabbarSubviewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate,
SimpleSegmentDelegate, UIScrollViewDelegate, LessonCellDelegate, ImagePlayerViewDelegate> {

    int currentPage;
    PullTableView *lessonTable;
    SimpleSegment *lessonType;
    ImagePlayerView *banner;

    NSMutableArray *lessons;
    NSMutableArray *recLessons;
}

@end
