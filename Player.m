//
//  Player.m
//  JamMusic
//
//  Created by 24k on 15/7/19.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "Player.h"
#import "musicModel.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
@implementation Player
#pragma mark -
#pragma mark 单例方法
static Player *player = nil;
-(id)init{
    
    if (self = [super init]) {
//        初始化的时候将数据加载到player中
        _index = 0;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *setCategoryError = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        NSError *activationError = nil;
        [session setActive:YES error:&activationError];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
                NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
                [runloop run];
            });
            
        });
    }
    return self;
    
}
+(id)SharedPlayer{
   static dispatch_once_t once;
    dispatch_once(&once, ^{
        
            player = [[self alloc]init];
        
        
        
    });
   
    return player;
}
+(id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        
        if (!player) {
            
            player = [super allocWithZone:zone]; //确保使用同一块内存地址
            
            return player;
            
        }
        
        return nil;
    }
}
-(id)copy{
    return player;
}





- (id)copyWithZone:(NSZone *)zone;{
    
    return self; //确保copy对象也是唯一
    
}
#pragma mark -
#pragma mark 播放控制
//播放器加载播放内容
-(void)setPlayerData:(NSMutableArray *)data{
    if (!data) {
        return;
    }
    if (_data != data) {
        _data = data;
    }
    [self removeAllItems];
    AVPlayerItem *item = nil;
    for (AVPlayerItem *obj in _data) {
        if ([self canInsertItem:obj afterItem:item]) {
            [self insertItem:obj afterItem:item];
        }
        
        item = obj;
    }
}
//下一曲
-(void)next{
    if ([_data count]!=0) {
        
    
    if (_index < [_data count]) {
        _index++;
    }else{
        _index = 0;
    }
    switch (playerPlayingMode) {
            //单曲播放
        case playingModeSinglePlay:
            
            break;
            //列表循环
        case playingModeListLoop:
            [self playAtIndex:_index];
            
            
            break;
            //随机播放
        default:
            break;
    }
    /*通知代理更换专辑图片*/
    if ([self.eventDelegate respondsToSelector:@selector(shouldUpadatePicWith:)]) {
        [self.eventDelegate shouldUpadatePicWith:_index];
    }
    [self PlayingInfo];
    
    }
}
//上一曲
-(void)previous{
    if ([_data count]!=0) {
        
    
    if (index >0) {
        _index--;
    }else{
        _index = [_data count]-1;
    }
    switch (playerPlayingMode) {
            //单曲播放
        case playingModeSinglePlay:
            
            break;
            //列表循环
        case playingModeListLoop:
            [self playAtIndex:_index];
            break;
            //随机播放
        default:
            break;
    }
     /*通知代理更换专辑图片*/
    if ([self.eventDelegate respondsToSelector:@selector(shouldUpadatePicWith:)]) {
        [self.eventDelegate shouldUpadatePicWith:_index];
    }
    [self PlayingInfo];
    }
}
//播放指定Index的歌曲
-(void)playAtIndex:(NSUInteger)index{
    
    _index = index;
    
    if (index >[_data count]) {
        index = index%[_data count];
    }
    _currentData =[_data mutableCopy];
    AVPlayerItem *item = nil;
    for (int i =0; i< index; i++) {
        item = [_currentData objectAtIndex:0];
        [_currentData removeObjectAtIndex:0 ];
        [_currentData addObject:item];
    }
    [self removeAllItems];
    item = nil;
    for (AVPlayerItem *obj  in _currentData) {
        [obj seekToTime:kCMTimeZero];
        if ([self canInsertItem:obj afterItem:item]) {
            [self insertItem:obj afterItem:item];
        }
        item =obj;
    }
    [self play];
    isPlaying = YES;
}
-(void)setMusicModels:(NSMutableArray *)musicModels{
    if (_musicModels) {
        _musicModels = [[NSMutableArray alloc]init];
        
    }
    _musicModels = [musicModels mutableCopy];
}
-(musicModel *)getCurrentItem{
    if (_musicModels) {
        return [_musicModels objectAtIndex:_index];
    }
    return nil;
}
//-(NSMutableArray *)musicModels{
//    return  _musicModels;
//}
//播放
-(void)playEvent{
    if ([_data count]!= 0) {
        
    
    isPlaying = !isPlaying;
    if (isPlaying) {
        [self play];
    }else{
        [self pause];
    }
    [self PlayingInfo];
    }
}
-(void)pauseEvent{
        if ([_data count]!= 0) {
    [self pause];
        }
}
-(void)setMode:(NSUInteger)mode{
    self->playerPlayingMode = mode;
}

-(void)timerAction{
    AVPlayerItem *item = [self currentItem];
    _currentTime = ((float)item.currentTime.value/item.currentTime.timescale)/(item.duration.value/item.duration.timescale);
    
    _currentTimeNotRate = (float)item.currentTime.value/item.currentTime.timescale;
    _restTime = (float)item.duration.value/item.duration.timescale -_currentTimeNotRate;
//    NSLog(@"%f",_currentTime);
    if ([self.eventDelegate respondsToSelector:@selector(progressShouldUpdateWith:andTimeFormatted:)]) {
        [self.eventDelegate progressShouldUpdateWith:_currentTime andTimeFormatted:[self getTimeWithformatted]];
    }
}
-(float)getCurrentTime{
    return _currentTime;
}
-(float)getCurrentTimeNoRate{
    return _currentTimeNotRate;
}
-(float)getRestTime{
    return _restTime;
}
-(NSString *)getDuration{
    int seconds = (int)self.currentItem.duration.value/self.currentItem.duration.timescale;
    int totalm = seconds/(60);
    int h = totalm/(60);
    int m = totalm%(60);
    int s = seconds%(60);
    if (h==0) {
        return  [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    
}
-(NSString *)getCurrentName{
    return nil;
}
-(NSArray *)getMusicList{
    if (_musicList) {
        return [_musicList allKeys];
    }
    return nil;
}
-(void)setMusicList:(NSMutableDictionary*)dict{
    if (!_musicList) {
        _musicList = [[NSMutableDictionary alloc]init];
        
    }
    if (_musicList != dict) {
        _musicList = [dict mutableCopy];
    }
}
-(NSInteger)getIndex{
    return _index;
}

-(void)PlayingInfo{
    MPNowPlayingInfoCenter *playingInfoCenter =[ MPNowPlayingInfoCenter defaultCenter];
    if (playingInfoCenter) {
        
        musicModel *music = [[Player SharedPlayer]getCurrentItem];
        if (music) {
            
        
        NSMutableDictionary *songInfo = [ [NSMutableDictionary alloc] init];
            if([music getAttribute:@"songname"]){
                [ songInfo setObject: [music getAttribute:@"songname"] forKey:MPMediaItemPropertyTitle ];
            }
            if([music getAttribute:@"singername"])
        [ songInfo setObject: [music getAttribute:@"singername"] forKey:MPMediaItemPropertyArtist ];
            if([music getAttribute:@"albumname"])
        [ songInfo setObject: [music getAttribute:@"albumname"] forKey:MPMediaItemPropertyAlbumTitle ];
        //当前播放时间
        [songInfo setObject: [NSNumber numberWithDouble:[self getCurrentTimeNoRate]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
         [songInfo setObject:[NSNumber numberWithDouble:[self getRestTime]] forKey:MPMediaItemPropertyPlaybackDuration];
        [ [MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo ];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updatePlayingInfo) userInfo:nil repeats:YES];
        });
        
    });
    }
}
-(void)updatePlayingInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter]nowPlayingInfo]];
    double restTime =[self getRestTime];
    double currentTime =[self getCurrentTimeNoRate];
    [dict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime ];
    [dict setObject:[NSNumber numberWithDouble:restTime] forKey:MPMediaItemPropertyPlaybackDuration ];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}
-(NSString *)getTimeWithformatted{
    NSString *timeStr = [self TimeformatFromSeconds:[self getCurrentTimeNoRate]];
    return timeStr;
}
-(NSString*)TimeformatFromSeconds:(int)seconds
{
    int totalm = seconds/(60);
    int h = totalm/(60);
    int m = totalm%(60);
    int s = seconds%(60);
    if (h==0) {
        return  [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
}
-(void)setCurrentTimeValue:(float)time{
    AVPlayerItem *item = self.currentItem;
    int ti =  (int)(self.currentItem.duration.value/self.currentItem.duration.timescale*time);
    if (item) {
        CMTime timer = CMTimeMake(item.duration.timescale*ti,item.duration.timescale);
        [item seekToTime:timer];
    }
    _currentTime = time;
}
-(BOOL)getStatus{
    return isPlaying;
}
-(void)setPlayerDataWithData:(NSMutableArray*)array{
    //array 里面全都是urlstr;
    NSMutableArray *urlStrArray;
    
    NSMutableArray *playerItem = [[NSMutableArray alloc]init];
    if (array) {
        urlStrArray = [array mutableCopy];
    }
    for (NSString *urlStr in urlStrArray) {
        NSURL *url = [NSURL URLWithString:urlStr];
        
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
        [playerItem addObject:item];
    }
    [[Player SharedPlayer]setPlayerData:playerItem];
    
}
@end
