//
//  FileWriter.m
//  JamMusic
//
//  Created by 24k on 15/7/16.
//  Copyright (c) 2015年 24k. All rights reserved.
//  文件管理类

#import "FileWriter.h"

@implementation FileWriter
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
    
}
-(NSString *)DocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *Document = [paths objectAtIndex:0];
    
    return Document;
}
//创建文件夹
-(BOOL)createDir:(NSString *)dir{
    NSString *documentsPath =[self DocumentPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dir];
    // 创建目录
    BOOL isDir = NO;
   BOOL fileExist= [fileManager fileExistsAtPath:testDirectory isDirectory:&isDir];
    if (!fileExist) {
        BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            return YES;
        }else
            return NO;
    }
    return NO;
}
    
//
-(BOOL)createFile:(NSString *)file At:(NSString *)path{
    NSString *documentsPath =[self DocumentPath];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:file];
    BOOL res=[fileManager createFileAtPath:testPath contents:nil attributes:nil];
    if (res) {
        return YES;
    }else
        return NO;
}
-(BOOL)createData:(NSData *)data At:(NSString*)path{
    NSMutableData *musicData = [[NSMutableData alloc]initWithData:data];
    NSString *documentPath =[self DocumentPath];
    NSString *tempPath = [documentPath stringByAppendingString:path];
    [musicData writeToFile:tempPath atomically:YES];
    return YES;
}
-(BOOL)createMp3:(NSString *)mp3 At:(NSString*)path{
    NSString *musicPath = [[NSBundle mainBundle]pathForResource:mp3 ofType:@"mp3"];
    NSFileManager *manager = [NSFileManager defaultManager];

//    musicPath = [musicPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:musicPath];
    NSData *data = [NSData dataWithContentsOfFile:musicPath];
    NSString *tempSavepath = [DocumentsPath stringByAppendingPathComponent:@"music"];
    NSString *savePath = [tempSavepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",mp3]];
    [savePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager removeItemAtPath:savePath error:nil];
    
    BOOL flag = [data writeToFile:savePath atomically:YES];
//    NSString *tempSavepath = [DocumentsPath stringByAppendingPathComponent:@"music"];
//    NSString *savePath = [tempSavepath stringByAppendingPathComponent:[NSString stringWithFormat:@"1.mp3"]];
    if (![manager fileExistsAtPath:savePath]) {
        BOOL create = [manager createFileAtPath:savePath contents:data attributes:nil];
        if (create){
            NSLog(@"保存成功");
                return YES;
        }
    }
    
    return NO;

}
-(NSArray *)readFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    NSString *musicDir = [documentDir stringByAppendingPathComponent:@"music"];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:musicDir error:&error];
    
    return fileList;
}
-(NSData *)readDataWith:(NSString *)dir{
    
    
    NSString *documentPaths = [self DocumentPath];
    NSString *musicPath = [documentPaths stringByAppendingPathComponent:dir];
    NSData *data = [[NSData alloc]initWithContentsOfFile:musicPath];
    return data;
}
-(NSMutableDictionary *)readMusicUrl{
    NSArray *array = [self readFile];
    NSString *path = [DocumentsPath stringByAppendingPathComponent:@"music"];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (NSString *obj in array) {
        NSString *musicPath = [path stringByAppendingPathComponent:obj];
        [dataArray addObject:musicPath];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjects:dataArray forKeys:array];
    return dict;
}
-(void)createFileWithFileUrl:(NSURL *)url andName:(NSString *)name{
     BOOL flag = [self createDir:name];
    if (!flag) {
        NSLog(@"文件夹创建失败");
        return;
    }
    
    
}

@end
