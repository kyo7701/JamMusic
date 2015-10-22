//
//  BaseViewController.h
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController{

}
@property (assign,nonatomic)BOOL needBack;
@property (assign,nonatomic)BOOL needScroll;
@property (strong ,nonatomic)UIView *backgroudPic;
@property (strong ,nonatomic)UIButton *backBtn;
@property (strong ,nonatomic) UIScrollView *scrollView;
-(BOOL)setBackGroundPic:(NSString *)picName;
-(void)setNeedScroll:(BOOL)needScroll;
@end
