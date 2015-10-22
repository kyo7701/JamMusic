//
//  LionTable.h
//  JamMusic
//
//  Created by 24k on 15/7/27.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LionTable : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (strong ,nonatomic)NSMutableArray *data;
@property (strong ,nonatomic)NSMutableArray *imgData;
-(void)setImgData:(NSMutableArray *)imgData;
@property (weak ,nonatomic)UIViewController *controller;
@end
