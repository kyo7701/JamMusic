//
//  MusicListController.h
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "BaseViewController.h"
@class LionTable;
@interface MusicListController : BaseViewController
@property (strong ,nonatomic)NSMutableArray *data;
@property (strong ,nonatomic)LionTable *table;
@property (weak , nonatomic)UIViewController *controller;
@end
