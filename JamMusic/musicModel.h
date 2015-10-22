//
//  musicModel.h
//  JamMusic
//
//  Created by 24k on 15/7/14.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface musicModel : NSObject{
    NSString *_author;
    NSString *_songName;
    NSString *_backPicUrl;
    UIImageView *_backPic;
    UIImageView *_backPicSmall;
    NSString *_singer;
    NSString *_backPicSmallUrl;
    NSString *_albumName;
}
@property (strong ,nonatomic) NSMutableDictionary *dataDict;
-(id)initWithDictionary:(NSMutableDictionary *)dict;
-(NSString *)getAttribute:(NSString *)name;
-(UIImageView *)getBackPic;
@end
