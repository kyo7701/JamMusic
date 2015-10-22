//
//  Player.h
//  JamMusic
//
//  Created by 24k on 15/7/19.
//  Copyright (c) 2015年 24k. All rights reserved.
// 上一曲 下一曲 播放 列表循环模式


#import <AVFoundation/AVFoundation.h>
@class musicModel;
typedef NS_ENUM(NSUInteger, playingMode) {
    playingModeSinglePlay = 0,
    playingModeListLoop = 1,
    playingModeRandomPlay = 1<<1,
};
@protocol PlayerDelegate <NSObject>
@optional
-(void)progressShouldUpdateWith:(float)currentTime andTimeFormatted:(NSString *)time;
-(void)shouldUpadatePicWith:(NSInteger )index;
@end
@interface Player : AVQueuePlayer{
    NSMutableArray *_data;  // 歌曲列表  存储AVPlayerItem.
    BOOL isPlaying;
    
    playingMode playerPlayingMode;
    NSMutableArray *_currentData;
    NSUInteger _index;
    float _currentTime;
    float _currentTimeNotRate;
    float _restTime;
    NSMutableDictionary *_musicList;
}
@property (weak,nonatomic)id <PlayerDelegate>eventDelegate;
@property (strong ,nonatomic)NSMutableArray *musicModels;
@property (strong ,nonatomic) NSString *keyWord;
-(void)playAtIndex:(NSUInteger)index;
-(void)playEvent;
-(void)pauseEvent;
+(id)SharedPlayer;
-(void)next;
-(void)previous;
-(void)setPlayerData:(NSMutableArray*)data;
-(void)setMode:(NSUInteger)mode;
-(float)getCurrentTime;
-(NSArray *)getMusicList;
-(void)setMusicList:(NSMutableDictionary*)dict;
-(NSInteger)getIndex;
-(void)setMusicModels:(NSMutableArray *)musicModels;
-(musicModel *)getCurrentItem;
-(void)PlayingInfo;
-(NSString *)getTimeWithformatted;
-(NSString *)getDuration;
-(void)setCurrentTimeValue:(float)time;
-(BOOL)getStatus;
-(NSString*)TimeformatFromSeconds:(int)seconds;
-(void)setPlayerDataWithData:(NSMutableArray*)array;
@end
