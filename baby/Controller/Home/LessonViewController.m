//
//  LessonViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonViewController.h"
#import "LessonCell.h"
#import "LessonHeader.h"
#import "Lesson.h"

#import "LessonDetailViewController.h"
#import "LessonTask.h"
#import "TaskQueue.h"

#import "CartViewController.h"

#define LESSON_PAGE_SIZE 5

@interface LessonViewController ()

@property (nonatomic, assign) long playingLessonId;

@end



@implementation LessonViewController

- (void)dealloc {
    [lessons release];
    [recLessons release];
    [lessonType release];

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        lessonType = [[SimpleSegment alloc] initWithFrame:CGRectMake(5, 5, 310, 29)
                                                    titles:@[@"绘本", @"变变变", @"儿童评书"]];
        lessonType.selectedTextColor = [UIColor whiteColor];
        lessonType.selectedBackgoundColor = [Shared bbYellow];
        lessonType.normalTextColor = [Shared bbYellow];
        lessonType.normalBackgroundColor = [UIColor whiteColor];
        lessonType.borderColor = [Shared bbYellow];
        lessonType.delegate = self;
        lessonType.layer.cornerRadius = 2;
        [lessonType updateLayout];
        
        lessonTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44 - 52)
                                                      style:UITableViewStylePlain];
        lessonTable.pullDelegate = self;
        lessonTable.delegate = self;
        lessonTable.dataSource = self;
        lessonTable.pullBackgroundColor = [Shared bbWhite];
        lessonTable.backgroundColor = [Shared bbWhite];
        [lessonTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        lessonTable.separatorColor = [UIColor whiteColor];
        [self.view addSubview:lessonTable];
        [lessonTable release];
        
        banner = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        banner.delegate = self;
        lessonTable.tableHeaderView = banner;
        [banner release];
        
        lessons = [[NSMutableArray alloc] initWithCapacity:0];
        recLessons = [[NSMutableArray alloc] initWithCapacity:0];
        
        currentPage = 1;
        [self loadLesson];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"课堂"];
    bbTopbar.backgroundColor = [Shared bbYellow];
    
    UIButton *shoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingBtn.frame = CGRectMake(kScreen_width - 40, 7, 30, 30);
    [shoppingBtn setImage:[UIImage imageNamed:@"shopping.png"] forState:UIControlStateNormal];
    [shoppingBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bbTopbar addSubview:shoppingBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ui event

- (void)btnAction {
    //    CartViewController
    
    CartViewController *dCtr = [[CartViewController alloc] init];
    [ctr pushViewController:dCtr animation:ViewSwitchAnimationSwipeR2L];
    [dCtr release];
}

- (void)segmentSelected:(int)index {
    currentPage = 1;
    lessonTable.isRefreshing = YES;
    [self loadLesson];
}

- (void)loadLesson {
    LessonTask *task = [[LessonTask alloc] initGetLesson:lessonType.selectedIndex
                                                     age:0
                                                    page:currentPage
                                                   count:LESSON_PAGE_SIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [lessons removeAllObjects];
        }
        
        if (succeeded) {
            [lessons addObjectsFromArray:(NSArray *)userInfo];
            if ([((NSArray *)userInfo) count] < LESSON_PAGE_SIZE) {
                lessonTable.hasMore = NO;
            } else {
                lessonTable.hasMore = YES;
            }
        }
        
        [lessonTable reloadData];
        [lessonTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
    
    
    LessonTask *recommentTask = [[LessonTask alloc] initRecommendLessonList];
    recommentTask.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (succeeded) {
            [recLessons removeAllObjects];
            [recLessons addObjectsFromArray:userInfo];
            
            NSMutableArray *pictures = [[NSMutableArray alloc] init];
            for (Lesson *l in recLessons) {
                [pictures addObject:l.cover];
            }
            banner.banners = pictures;
            [banner updateLayout];
            [pictures release];
        }
    };
    [TaskQueue addTaskToQueue:recommentTask];
    [recommentTask release];

}

- (void)startPlayPreview {
    if (self.playingLessonId > 0) {
        
    }
}

- (void)stopPlayPreview {

}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return lessons.count;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    LessonCell *lCell = (LessonCell *)cell;
    if (lessons.count > indexPath.row) {
        lCell.lessonId = [[lessons objectAtIndex:indexPath.row] longValue];
        [lCell updateLayout];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"lessoncell";
    LessonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[LessonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long lessonId = [[lessons objectAtIndex:indexPath.row] longValue];
    
    LessonDetailViewController *lCtr = [[LessonDetailViewController alloc] initWithLesson:lessonId];
    [ctr pushViewController:lCtr animation:ViewSwitchAnimationBounce];
    [lCtr release];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 31)];
    bg.backgroundColor = [Shared bbWhite];
    [bg addSubview:lessonType];
    return [bg autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 39;
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadLesson];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadLesson];
}


#pragma mark image player delegate
- (void)handleTouchAtIndex:(int)index {
    if (index < recLessons.count) {
        Lesson *l = [recLessons objectAtIndex:index];
        
        LessonDetailViewController *lCtr = [[LessonDetailViewController alloc] initWithLesson:l._id];
        [ctr pushViewController:lCtr animation:ViewSwitchAnimationBounce];
        [lCtr release];
    }
}


@end
