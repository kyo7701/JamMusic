//
//  BottomView.h
//  JamMusic
//
//  Created by 24k on 15/7/31.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
@protocol BottomViewDelegate <NSObject>

@required
-(void)BottomViewShouldPerformSegue;
-(void)BottomViewShouldUpdateAlbumPic;
@end

@interface BottomView : UIView<PlayerDelegate>
@property (weak ,nonatomic) id <BottomViewDelegate>delegate;
@property (strong ,nonatomic) UIProgressView *progress;

-(void)setAlbumPic:(UIImageView*)image;

@end
