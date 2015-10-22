//
//  FileWriter.h
//  JamMusic
//
//  Created by 24k on 15/7/16.
//  Copyright (c) 2015年 24k. All rights reserved.
//  文件管理类

#import <Foundation/Foundation.h>

@interface FileWriter : NSObject
-(NSString *)DocumentPath;
-(NSMutableDictionary *)readMusicUrl;
-(NSArray *)readFile; // 返回Documents下的文件
-(BOOL)createFile:(NSString *)file At:(NSString *)path;
-(BOOL)createDir:(NSString *)dir;
-(BOOL)createData:(NSData *)data At:(NSString*)path;
-(BOOL)createMp3:(NSString *)mp3 At:(NSString*)path;
-(NSData *)readDataWith:(NSString *)dir;
@end
