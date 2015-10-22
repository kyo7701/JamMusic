//
//  BottomView.m
//  JamMusic
//
//  Created by 24k on 15/7/31.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "BottomView.h"
#import "Player.h"
@implementation BottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    frame.size.height = 59;
    frame.size.width = Width;
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor blueColor]];
        Player *player = [Player SharedPlayer];
        player.eventDelegate = self;
        [self _initView];
    }
    return self;
}
-(void)_initView{
    
    _progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progress setFrame:CGRectMake(0, 0, Width, 1)];
    NSLog(@"%f",_progress.frame.size.height);
    UIButton *button = [[UIButton alloc]init];
    button.tag = 5050;
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0+2, 57, 57)];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchDown];
    UIButton *playButton  = [[UIButton alloc]init];
    [playButton setBackgroundColor:[UIColor clearColor]];
    [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playButton setFrame:CGRectMake(Width-100, 58/2-20+2, 40, 40)];
    [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
    [playButton setBackgroundImage:[UIImage imageNamed:@"pause@2x.png"] forState:UIControlStateNormal];
    UIButton *nextButton  = [[UIButton alloc]init];
    [nextButton setBackgroundColor:[UIColor clearColor]];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton setFrame:CGRectMake(Width-50, 58/2-12+2, 24, 24)];
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    [nextButton setImage:[UIImage imageNamed:@"nextSong@2x.png"] forState:UIControlStateNormal];
    [_progress setTintColor:[UIColor orangeColor]];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [blurView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [blurView addSubview:_progress];
    [blurView addSubview:button];
    [blurView addSubview:playButton];
    [blurView addSubview:nextButton];
    
    [self addSubview:blurView];
    
    
}
- (void)play{
    
    [[Player SharedPlayer] playEvent];
    
    
}
-(void)next{
    
    [[Player SharedPlayer]  next];
    if ([self.delegate respondsToSelector:@selector(BottomViewShouldUpdateAlbumPic)]) {
        [self.delegate BottomViewShouldUpdateAlbumPic];
    }
}
-(void)buttonClick{
    if ([self.delegate respondsToSelector:@selector(BottomViewShouldPerformSegue)]) {
        [self.delegate BottomViewShouldPerformSegue];
    }
}
-(void)setAlbumPic:(UIImageView*)image{
    UIButton *button = (UIButton *)[self viewWithTag:5050];
    if (image) {
        [button setBackgroundImage:image.image forState:UIControlStateNormal];
    }
   
}
#pragma mark -
#pragma mark playerDelegate
-(void)progressShouldUpdateWith:(float)currentTime andTimeFormatted:(NSString *)time{
    [_progress setProgress:currentTime];
}
@end
