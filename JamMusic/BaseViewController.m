//
//  BaseViewController.m
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "BaseViewController.h"
#import "Player.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "musicModel.h"
#import "UIView+Addition.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize backgroudPic;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.scrollView setContentSize:CGSizeMake(Width, Height*2)];
    [self.view addSubview:self.scrollView];
    _needBack  = NO;
    [self setNeedBack:NO];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    }
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    // Do any additional setup after loading the view.
}
-(void)need{
//    [self setNeedBackButton:YES];
}
-(void)setNeedScroll:(BOOL)needScroll{
    _needScroll = needScroll;
    if (_needScroll) {
        [self.view addSubview:self.scrollView];
        [self.view bringSubviewToFront:self.scrollView];
    }else{
        if ([_scrollView superview]) {
            [_scrollView removeFromSuperview];
        }
    }
}

-(void)setNeedBack:(BOOL)needBack{
    _needBack = needBack;
    if (_needBack) {
        [self.view addSubview:self.backBtn];
        [self.view bringSubviewToFront:self.backBtn];
    }else{
        if ([_backBtn superview]) {
            [_backBtn removeFromSuperview];
        }
    }
    
}
-(UIButton *)backBtn{
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,20, 30, 30)];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    return _backBtn;
}
-(BOOL)setBackGroundPic:(NSString *)picName{
    if (picName.length == 0) {
        return NO;
    }
    UIImage *image = [UIImage imageNamed:picName];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    [imageView setImage:image];
    if (!backgroudPic) {
        backgroudPic = [[UIView alloc]init];

    }
    [backgroudPic addSubview:imageView];
    backgroudPic.layer.zPosition = -1.0;
    [self.view addSubview:backgroudPic];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPause:
                [[Player SharedPlayer]playEvent];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[Player SharedPlayer]previous];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [[Player SharedPlayer]next];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [[Player SharedPlayer]playEvent];
                break;
            case UIEventSubtypeRemoteControlStop:
                
                break;
            default:
                break;
        }
    }
    [[Player SharedPlayer]PlayingInfo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
