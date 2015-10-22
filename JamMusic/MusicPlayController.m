//
//  MusicPlayController.m
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//  歌曲播放页面
#import "musicModel.h"
#import <UIImageView+AFNetworking.h>
#import "MusicPlayController.h"
#import "FileWriter.h"
#import "Player.h"
#import "THProgressView.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "YDSlider.h"
#import "UIView+Addition.h"
@interface MusicPlayController (){
    BOOL isPlay;
    
}

@end
@implementation MusicPlayController
@synthesize dataArray;
- (void)viewDidLoad {
    isPlay = NO;
    [super viewDidLoad];

    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self _initView];
//    dataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"rate"])
    {
        
        AVPlayerItem *item = ((AVPlayer *)object).currentItem;
        if ([item isEqual:lastItem]) {
            NSLog(@"");
        }
//        self.lblMusicName.text = ((AVURLAsset*)item.asset).URL.pathComponents.lastObject;
//        NSLog(@"New music name: %@", self.lblMusicName.text);
    }
}
-(void)_initView{
    [self setNeedScroll:NO];
    if ([dataArray count]!=0) {
        model = [dataArray objectAtIndex:_index];
    }
    _playerView = [[UIView alloc]init];
    
    [self.view addSubview:_playerView];
    _musicBackPic = [[UIView alloc]init];
    [self.view addSubview:_musicBackPic];
    [_musicBackPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(Width, 300));
    }];
    [_musicBackPic setBackgroundColor:[UIColor redColor]];

    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(_musicBackPic.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(Width, Height-300-44-20));
    }];
    NSLog(@"%f",Height-300);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _playerView.frame.size.width, _playerView.frame.size.height)];
    [image setImage:[UIImage imageNamed:@"player_view.png"]];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [blurView setFrame:CGRectMake(0, 0,image.frame.size.width,image.frame.size.height)];
    [image addSubview:blurView];
    [_playerView addSubview:image];
    [_playerView sendSubviewToBack:image];
    _currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 80, 20)];
    _restLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width - 5 -80, 25, 80, 20)];
    [_currentLabel setFont:[UIFont fontWithName:@"arial" size:13]];
    [_restLabel setFont:[UIFont fontWithName:@"arial" size:13]];
    [_restLabel setText:@"00:00:00"];
    [_restLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_playerView addSubview:_currentLabel];
    [_playerView addSubview:_restLabel];
    _slider = [[YDSlider alloc]initWithFrame:CGRectMake(10, 5, Width-20, 20)];
    [_playerView addSubview:_slider];
    [_slider setValue:[[Player SharedPlayer] getCurrentTime]];
    [_slider setThumbTintColor:[UIColor magentaColor]];
    [_slider setMiddleTrackTintColor:[UIColor grayColor]];
    [_slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventTouchUpInside];
//    CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateImage)];
//    [display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    /*启动播放器之后先从本地文件检查json*/
    /*从服务器端取数据*/
        _play = [[UIButton alloc]init];
        _next = [[UIButton alloc]init];
        _previous = [[UIButton alloc]init];
        _buy = [[UIButton alloc]init];
        _love = [[UIButton alloc]init];
        _playType = [[UIButton alloc]init];
    [_playerView setBackgroundColor:[UIColor blueColor]];
        [_playerView addSubview:_play];
        [_playerView addSubview:_next];
        [_playerView addSubview:_previous];
        [_playerView addSubview:_buy];
        [_playerView addSubview:_love];
        [_playerView addSubview:_playType];
    [_play mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_playerView).with.offset(Width/2 - 30);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.bottomMargin.equalTo(_playerView.mas_bottom).with.offset(-20);
            
        }];
    [_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_play.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.equalTo(_play).with.offset(-15);
        
    }];
    [_previous mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_play.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.equalTo(_next);
        
    }];
    [_buy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_playerView).with.offset(40);
        make.left.mas_equalTo(_playerView).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [_love mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_playerView).with.offset(-40);
        make.top.mas_equalTo(_buy);
        make.size.mas_equalTo(_buy);
        
        
    }];
    [_playType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_previous.mas_left).with.offset(-40);
        make.top.mas_equalTo(_previous).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        
        
    }];
    
    [_play addTarget:self action:@selector(Play) forControlEvents:UIControlEventTouchDown];
    [_next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    [_previous addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchDown];
    [_play setBackgroundImage:[UIImage imageNamed:@"pause@2x.png"] forState:UIControlStateNormal];
    
    [_next setBackgroundImage:[UIImage imageNamed:@"nextSong@2x.png"] forState:UIControlStateNormal];
    
    [_previous setBackgroundImage:[UIImage imageNamed:@"lastSong@2x.png"] forState:UIControlStateNormal];
    
    [_buy setBackgroundImage:[UIImage imageNamed:@"buy@2x.png"] forState:UIControlStateNormal];
    
    [_love setBackgroundImage:[UIImage imageNamed:@"collection@2x.png"] forState:UIControlStateNormal];
    
    [_playType setBackgroundImage:[UIImage imageNamed:@"cycle@2x.png"] forState:UIControlStateNormal];
    isPlay = NO;
    FileWriter *writer = [[FileWriter alloc]init];

    [writer createDir:@"music"];
    lastItem = [_playerItem lastObject];
//    [self performSelector:@selector(timerAction) withObject:nil afterDelay:0.01];
    _player = [Player SharedPlayer];
    _player.eventDelegate = self;
     /*专辑图片*/
    _image = [[UIImageView alloc]init];
    _image.tag = 5000;
    [_musicBackPic addSubview:_image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_musicBackPic).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
        make.top.equalTo(_musicBackPic).with.offset(5);
    }];
    [_image setBackgroundColor:[UIColor redColor]];
    _musicNameLabel = [[UILabel alloc]init];
    [_playerView addSubview:_musicNameLabel];
    [_musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playerView).with.offset(Width/2-60);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.top.mas_equalTo(_playerView).with.offset(80);
    }];
    [_musicNameLabel setText:[model getAttribute:@"songname"]];
    _musicNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
   [self requestPicWithIndex:_index];
}
-(void)requestPicWithIndex:(NSInteger )index{
    if ([dataArray count]!=0) {
        model = [dataArray objectAtIndex:index];
    }
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if ([manager isReachable]) {
        /*AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
         if ([manager isReachable]) {
         }*/
        UIImageView *imageView = _image;
        
    NSURL *url = [NSURL URLWithString:[model getAttribute:@"albumpic_big"]];
    [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imageView setImage:image];
    }];
        [_musicNameLabel setText:[model getAttribute:@"songname"]];
    }
}
//-(void)timerAction{
//    for (int i =5000; i< 5004; i++) {
//        UIButton *button = (UIButton *)[self.view viewWithTag:i];
//        CGRect rect = button.frame;
//        rect.origin.y -=40;
//        [button setFrame:rect];
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)Play{
    [_player playEvent];
    
}

- (void)next{
    [_player next];
}

- (void)previous{
    [_player previous];

}
-(void)progressShouldUpdateWith:(float)currentTime andTimeFormatted:(NSString *)time{
    [_slider setValue:currentTime];
    [_currentLabel setText:time];
    [_restLabel setText:[_player getDuration]];
}
-(void)shouldUpadatePicWith:(NSInteger )index{
    _index = index;
    [self requestPicWithIndex:_index];
}
-(void)setIndex:(NSInteger )index{
    _index = index;

}
-(void)valueChanged{
    if ([[Player SharedPlayer]getStatus]) {
        [[Player SharedPlayer]playEvent];
        [[Player SharedPlayer]setCurrentTimeValue:_slider.value];
        [self performSelector:@selector(event) withObject:nil afterDelay:0.02];
     
    }else{
        [[Player SharedPlayer]setCurrentTimeValue:_slider.value];
    }
}
-(void)event{
    [[Player SharedPlayer]playEvent];
}
-(void)updateImage{
    [self.slider setNeedsDisplay];
}
@end
