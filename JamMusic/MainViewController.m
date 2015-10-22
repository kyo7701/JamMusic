//
//  MainViewController.m
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//  主界面
#import "SearchView.h"
#import "MainViewController.h"
#import "AMBlurView.h"
#import "MusicPlayController.h"
#import <AVFoundation/AVFoundation.h>
#import "FileWriter.h"
#import "LionTable.h"
#import <AFNetworking.h>
#import "musicModel.h"
#import "netWorkTool.h"
#import "MeController.h"
#import <UIImageView+WebCache.h>
#import "FFScrollView.h"
#import "BottomView.h"
typedef void (^requestFinishBlock)(id responseObj);
@interface MainViewController (){
    AVAudioPlayer *_audioPlayer;
    BOOL isPlay;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(_initView) withObject:self afterDelay:0.01f];
    
//    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view.
}
- (void)_initView{
    _flag = NO;
    SearchView *search = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, Width , 40)];
    search.placeholder = @"歌曲名称/作者名";
    
    requestFinishBlock callBack = ^(id responseobj){
        if (responseobj) {
            [self dealWithData:responseobj];
        }
    };
    search.callBack = callBack;

    _imgArray = [[NSMutableArray alloc]init];
    NSMutableArray *urlArray = [[NSMutableArray alloc]init];
    for (int i =0; i<4; i++) {
        NSString *urlstr  = @"http://img1.36706.com/lipic/allimg/20140217/139262Y12030-193105.jpg";
        NSURL *url = [NSURL URLWithString:urlstr];
        [urlArray addObject:url];
    }
    FFScrollView *radioView = [[FFScrollView alloc]initPageWithFrame:CGRectMake(0, 0, Width, 200) urls:urlArray];
    [self.scrollView addSubview:radioView];
    //listView
    
//
    
    UIView *listView  = [[UIView alloc]initWithFrame:CGRectMake(0, 200, Width, Height-44-200-64)];
    [listView setBackgroundColor:[UIColor redColor]];
    self.table = [[LionTable alloc]initWithFrame:CGRectMake(0, 0, listView.frame.size.width, listView.frame.size.height) style:UITableViewStylePlain];
    self.table.controller = self;
//    _progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    
    [listView addSubview:self.table];
    [self.scrollView addSubview:listView];
    self.titieView.backgroundColor = self.navigationController.navigationBar.backgroundColor;
    
    self.dataArray = [[NSMutableArray alloc]init];
    /*底部播放控制*/
    
    

    _bottom = [[BottomView alloc]initWithFrame:CGRectMake(0, Height-64-59, Width, 59)];

    
    
    [_progress setFrame:CGRectMake(0, _bottom.frame.origin.y-1, Width, 1)];
    _bottom.delegate = self ;
    [self.view addSubview:_bottom];
//    [_progress setTintColor:[UIColor orangeColor]];
//    [self.scrollView addSubview:_progress];
    [self requestNetWork];
//    Player *player = [Player SharedPlayer];
//    UIImageView *img;
    [self.scrollView addSubview:search];
}



-(void)buttonClick{

    
    MusicPlayController *music = [[MusicPlayController alloc] init];
    if (self.dataArray) {
        [music setDataArray:self.dataArray];
    }
    [music setIndex:[[Player SharedPlayer] getIndex]];

    
    
    [self.navigationController pushViewController:music animated:YES];
}
-(void)radioClick{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)nextPage{
    
    UIScrollView *radioView = (UIScrollView *)[self.scrollView viewWithTag:5009];
    CGFloat pageWidth = radioView.frame.size.width;
    int currentPage = radioView.contentOffset.x/pageWidth;
    if (currentPage == 0) {
        _page.currentPage = 0;
    }
    else if (currentPage == 3) {
        _page.currentPage = 0;
    }
    else {
//        _page.currentPage = currentPage-1;
    }
    long currPageNumber = _page.currentPage ;
    CGSize viewSize = radioView.frame.size;
    CGRect rect = CGRectMake((currPageNumber+2)*pageWidth, 0, viewSize.width, viewSize.height);
    [radioView scrollRectToVisible:rect animated:YES];
    currPageNumber++;
    if (currPageNumber == 4) {
        CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [radioView scrollRectToVisible:newRect animated:NO];
        currPageNumber = 0;
    }
    _page.currentPage = currPageNumber;
}
-(void)dealWithData:(NSMutableDictionary *)responseobj{
    NSMutableArray *urlStrArray = [[NSMutableArray alloc]init];
    if (!responseobj||[responseobj count] == 0) {
        NSLog(@"%@数据为空",NSStringFromSelector(_cmd));
        return;
    }
    if ([responseobj isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *dict =[responseobj objectForKey:@"showapi_res_body"];
        NSMutableDictionary *dict2 =[dict objectForKey:@"pagebean"];
        NSArray  *array = [dict2 objectForKey:@"contentlist"];
        
        if (_flag) {
            [self.dataArray removeAllObjects];
            [_imgArray removeAllObjects];
        }
        if ([array count]!=0) {
        for (NSMutableDictionary *dicton in array) {
           musicModel *model = [[musicModel alloc]initWithDictionary:dicton];
            [urlStrArray addObject: [model getAttribute:@"downUrl"]];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
                [self.dataArray addObject:model];
            [img sd_setImageWithURL:[NSURL URLWithString:[model getAttribute:@"albumpic_small"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [img setImage:image];
                    [_imgArray addObject:img];
            }];
            
        }
            [[Player SharedPlayer] setPlayerDataWithData:urlStrArray];
            [self updatePic];
            
            [self.table setData:self.dataArray];
            [self.table setImgData:_imgArray];
            _flag = YES;
            [[Player SharedPlayer]setMusicModels:self.dataArray];
        }
        
        
    }
}
-(void)requestNetWork{
    /* https://route.showapi.com/213-1?keyword=海阔天空&page=1&showapi_appid=3374&showapi_timestamp=20150726220808&showapi_sign=c2c70d8167d8da696df5593f6824ac4d
     */
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYYMMddHHmmSS"];
    NSString *dateStr = [format stringFromDate:date];
    NSString *secret = @"f1b7611e3abf4b5ea38e91d882c87a35";
    NSString *tempurl = [NSString stringWithFormat:@"?keyword=%@&page=1&showapi_appid=3374&showapi_timestamp=%@&showapi_sign=%@",[[Player SharedPlayer] keyWord],dateStr,secret];
    
    requestFinishBlock block= ^(id responseobj){
        
        
        [self dealWithData:responseobj];
            
        
    };
    [netWorkTool requestWithUrl:tempurl andHTTPMethop:@"GET" requestFinishedBlock: block];
    
    
}
-(void)updatePic{
    if ([_imgArray count] != 0) {
        [_bottom setAlbumPic:[_imgArray objectAtIndex:0]];
    }
}
-(void)requestImage:(NSMutableArray *)modelArray{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pageNum= scrollView.contentOffset.x /Width;
    [_page setCurrentPage:pageNum];
}


- (IBAction)Me:(id)sender {
    MeController *me = [[MeController alloc]init];
    [me setArray:_imgArray];
    [self presentViewController:me animated:YES completion:^{
        
    }];
}
-(void)BottomViewShouldPerformSegue{
    [self buttonClick];
}
-(void)BottomViewShouldUpdateAlbumPic{
     NSInteger index = [[Player SharedPlayer]getIndex];
    
    if (_imgArray ) {
        [_bottom setAlbumPic:[_imgArray objectAtIndex:index]];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSInteger index = [[Player SharedPlayer]getIndex];
    
    if ([_imgArray count]!=0) {
        [_bottom setAlbumPic:[_imgArray objectAtIndex:index]];
        Player *player = [Player SharedPlayer];
        player.eventDelegate = _bottom;
    }
    
}


@end
