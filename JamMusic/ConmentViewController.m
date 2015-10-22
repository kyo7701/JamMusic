//
//  ConmentViewController.m
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "ConmentViewController.h"
#import "UMSocial.h"
@interface ConmentViewController ()

@end

@implementation ConmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    [self _initView];
    [self setNeedBack:YES];
//    [self setNeedBackButton:YES];
    // Do any additional setup after loading the view.
}
-(void)_initView{
    
    UIButton *share = [UIButton new];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchDown];
    [share setTitle:@"share" forState:UIControlStateNormal];
    [share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:share];
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@120);
        make.left.mas_equalTo(@50);
        make.top.mas_equalTo(@50);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    UIButton *shareToQZone = [UIButton new];
    [shareToQZone addTarget:self action:@selector(shareToQzone) forControlEvents:UIControlEventTouchDown];
    [shareToQZone setTitle:@"shareToQzone" forState:UIControlStateNormal];
    [shareToQZone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:shareToQZone];
    [shareToQZone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@120);
        make.left.mas_equalTo(@50);
        make.top.mas_equalTo(@80);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    
}
-(void)share{
//    NSLog(@"%@",NSStringFromSelector(_cmd));

    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55c20a4c67e58e29c4001958" shareText:@"友盟分享组件" shareImage:nil shareToSnsNames:   [NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession, nil] delegate:nil];
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
}
-(void)shareToQzone{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55c20a4c67e58e29c4001958" shareText:@"友盟分享组件" shareImage:[UIImage imageNamed:@"1_1.png"] shareToSnsNames:   [NSArray arrayWithObjects:UMShareToQzone,UMShareToQQ, nil] delegate:nil];
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

@end
