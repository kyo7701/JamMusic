//
//  musicModel.m
//  JamMusic
//
//  Created by 24k on 15/7/14.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "musicModel.h"
#import <AFNetworking.h>
#import <UIImageView+AFNetworking.h>
@implementation musicModel
-(id)initWithDictionary:(NSMutableDictionary *)dict{
    if (self = [super  init]) {
        _author = [dict objectForKey:@"singername"];
        _songName = [dict objectForKey:@"songname"];
        _backPicUrl = [dict objectForKey:@"albumpic_big"];
        _backPicSmallUrl = [dict objectForKey:@"albumpic_small"];
        _albumName = [dict objectForKey:@"albumname"];
        self.dataDict = [dict mutableCopy];
    }
    return self;
}
-(NSString *)getAttribute:(NSString *)name{
    return [self.dataDict objectForKey:name];
}
-(UIImageView *)getBackPic{
    if (!_backPic) {
        return nil;
    }
    return _backPic;
}
-(void)getImage{

}
@end
