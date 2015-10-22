//
//  MeController.h
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//  个人信息

#import "BaseViewController.h"
@class BottomView;
@interface MeController : BaseViewController
@property (strong ,nonatomic) UIView *userView;
@property (strong ,nonatomic) UIView *centerView;
@property (strong ,nonatomic) BottomView *bottom;
@property (strong ,nonatomic) NSMutableArray *array;
-(void)setArray:(NSMutableArray *)array;
@end
