//
//  netWorkTool.m
//  JamMusic
//
//  Created by 24k on 15/7/23.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "netWorkTool.h"
@implementation netWorkTool

//请求json
+(AFHTTPRequestOperationManager *)requestWithUrl:(NSString *)url andHTTPMethop:(NSString *)method requestFinishedBlock:(requestFinishBlock)block{
    NSString  *requestUrl;
    NSComparisonResult com1 = [method caseInsensitiveCompare:@"GET"];
    //-----------------------处理get请求----------------------------
    if (com1 == NSOrderedSame) {
        requestUrl = [baseurl stringByAppendingString:url];
    }
    /*
     https://route.showapi.com/213-1?keyword=海阔天空&page=1&showapi_appid=3374&showapi_timestamp=20150726220808&showapi_sign=c2c70d8167d8da696df5593f6824ac4d
     */
    NSString *urlStr = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = @{@"format":@"json"};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation,id responseObj){
        /*回传json数据*/
        block(responseObj);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];

    /*-----------------------处理POST请求--------------------------*/
    return manager;
}
-(void)getImageFromNetWithUrl:(NSString *)url{

    
}

+ (void)sessionDownloadWithUrl:(NSString *)urlStr andName:(NSString *)name success:(void (^)(NSURL *fileURL,NSString *fileName))success fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        
        NSString *path = DocumentsPath;
        NSString *tempPath = [path stringByAppendingPathComponent:@"music"];
        NSString *finalPath = [tempPath stringByAppendingPathComponent:name];
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        //        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:finalPath];
        
        //        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        if (success) {
            success(fileURL,name);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    
    [task resume];
}

@end
