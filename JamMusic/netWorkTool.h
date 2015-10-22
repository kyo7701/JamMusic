//
//  netWorkTool.h
//  JamMusic
//
//  Created by 24k on 15/7/23.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@interface netWorkTool : NSObject
+(AFHTTPRequestOperationManager *)requestWithUrl:(NSString *)url andHTTPMethop:(NSString *)method requestFinishedBlock:(requestFinishBlock)block;
/*下载文件*/
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail;
@end
