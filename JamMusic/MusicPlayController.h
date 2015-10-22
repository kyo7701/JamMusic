//
//  MusicPlayController.h
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//  歌曲播放页面

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Player.h"
@class musicModel;
@class THProgressView;
@class YDSlider;
@interface MusicPlayController : BaseViewController<AVAudioSessionDelegate,PlayerDelegate>{
     UIView *playView;
     UIView *_musicBackPic; //专辑图片
     UIView *_playerView;   //播放器背景
     UIButton *_play;       //播放
     UIButton *_next;       //下一曲
     UIButton *_previous;   //上一曲
     UIButton *_buy;        //购买
     UIButton *_love;       //喜欢
     UIButton *_playType;   //播放类型
     UILabel *_musicNameLabel;   //音乐名称
     UILabel *_singerLabel;      //作者
     UILabel *_singerExtraLabel;  //演唱者
    Player *_player;
    NSMutableArray *_playerItem;
    AVPlayerItem *lastItem;
    THProgressView *progress;
    musicModel *model;
    NSInteger _index;
}
@property (strong ,nonatomic)    UIImageView *image;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic) UILabel *currentLabel;
@property (strong ,nonatomic) UILabel *restLabel;
@property (strong ,nonatomic) YDSlider *slider;
- (void)Play;
- (void)next;
- (void)previous;
-(void)setIndex:(NSInteger )index;



@end
