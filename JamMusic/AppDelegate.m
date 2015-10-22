//
//  AppDelegate.m
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Player.h"
#import "FileWriter.h"
#import "netWorkTool.h"
#import "musicModel.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
typedef void (^requestFinishBlock)(id responseObj);
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //启动画面持续时间
//    [NSThread sleepForTimeInterval:3.0f];
    
    
    [self requestNetWork];
    Player *_player = [Player SharedPlayer];
    [_player setMode:playingModeListLoop];
    [self monitoringNetwork];
    [self setUmeng];

    return YES;
}

-(void)setUmeng{
    [UMSocialData setAppKey:@"55c20a4c67e58e29c4001958"];
    [UMSocialWechatHandler setWXAppId:@"wxd390d156a9dc90cc" appSecret:@"81f0612b438ed8120c2f8b6050b79a58" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:@"1104804074" appKey:@"uKQwy1TBH4DvULWM" url:@"http://www.umeng.com/social"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

-(void)requestNetWork{
/* https://route.showapi.com/213-1?keyword=海阔天空&page=1&showapi_appid=3374&showapi_timestamp=20150726220808&showapi_sign=c2c70d8167d8da696df5593f6824ac4d
 */
    [[Player SharedPlayer] setKeyWord:@"千古"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYYMMddHHmmSS"];
    NSString *dateStr = [format stringFromDate:date];
    NSString *secret = @"f1b7611e3abf4b5ea38e91d882c87a35";
    NSString *tempurl = [NSString stringWithFormat:@"?keyword=%@&page=1&showapi_appid=3374&showapi_timestamp=%@&showapi_sign=%@",[[Player SharedPlayer] keyWord],dateStr,secret];
    
    requestFinishBlock block= ^(id responseobj){
        for (NSString* obj in [responseobj allKeys]) {
            NSLog(@"%@",obj);
            if ([responseobj isKindOfClass:[NSMutableDictionary class]]) {
                NSMutableDictionary *dict =[responseobj objectForKey:@"showapi_res_body"];
                NSMutableDictionary *dict2 =[dict objectForKey:@"pagebean"];
                NSArray  *array = [dict2 objectForKey:@"contentlist"];
                NSMutableArray *urlStrArray = [[NSMutableArray alloc]init];
                for (NSMutableDictionary *dicton in array) {
                    musicModel *model = [[musicModel alloc]initWithDictionary:dicton];
                    [self.dataArray addObject:model];
                    [urlStrArray addObject:[model getAttribute:@"downUrl"]];
                }
                [self setPlayerDataWithData:urlStrArray];
            }
        
        }
    };
   AFHTTPRequestOperationManager *manager  = [netWorkTool requestWithUrl:tempurl andHTTPMethop:@"GET" requestFinishedBlock: block];

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



-(void)monitoringNetwork{
    /*检测网络*/
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                /*    AFNetworkReachabilityStatusUnknown          = -1,
                 AFNetworkReachabilityStatusNotReachable     = 0,
                 AFNetworkReachabilityStatusReachableViaWWAN = 1,
                 AFNetworkReachabilityStatusReachableViaWiFi = 2,*/
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"网络无连通");
                break;
                
            default:
                break;
        }
    }];
}
//-(void)nowPlayingInfo{
//    MPNowPlayingInfoCenter *playingInfoCenter =[ MPNowPlayingInfoCenter defaultCenter];
//    if (playingInfoCenter) {
//        
//        
//        NSMutableDictionary *songInfo = [ [NSMutableDictionary alloc] init];
//        
//        [ songInfo setObject: @"Audio Title" forKey:MPMediaItemPropertyTitle ];
//        [ songInfo setObject: @"Audio Author" forKey:MPMediaItemPropertyArtist ];
//        [ songInfo setObject: @"Audio Album" forKey:MPMediaItemPropertyAlbumTitle ];
//
//        [ [MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo ];
//    }
//
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
