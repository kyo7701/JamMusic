//
//  MainViewController.h
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//  主界面

#import "BaseViewController.h"
#import "BottomView.h"
#import "Player.h"
@class LionTable;
@class BottomView;
@interface MainViewController : BaseViewController<UIScrollViewDelegate,BottomViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *titieView;
@property (weak, nonatomic) IBOutlet UIButton *Music;
- (IBAction)Me:(id)sender;

@property (nonatomic) BOOL flag;
@property(strong ,nonatomic)LionTable *table;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)UIPageControl *page;
@property (strong ,nonatomic)NSMutableArray *imgArray;
@property (strong ,nonatomic) BottomView *bottom;
@property (strong ,nonatomic) UIProgressView *progress;
@end
