//
//  MeController.m
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//  个人信息

#import "MeController.h"
#import "BottomView.h"
@interface MeController ()

@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [[NSMutableArray alloc]init];
    self.view.backgroundColor  = [UIColor whiteColor];
    [self _initView];
    [self setNeedBack:YES];
    
//        [self performSelector:@selector(dosth) withObject:nil afterDelay:0.01];
    // Do any additional setup after loading the view.
}
//-(void)dosth{
//    [self setNeedBack:NO];
//}
-(void)_initView{
    _userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width , 210)];
    [_userView setBackgroundColor:[UIColor colorWithRed:43.0/255 green:38.0/255 blue:111.0/255 alpha:1]];
    UIImageView *userHead = [[UIImageView alloc] initWithFrame:CGRectMake(Width/2-40, 200/2-40, 80, 80)];
    UIImage *image = [UIImage imageNamed:@"default@2x.png"];
    [userHead setImage:image];
//    userHead.layer.cornerRadius = 5;
    [_userView addSubview:userHead];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((Width-120)/2, 200/2-40+80+5, 120, 20)];
    [nameLabel setText:@"Mary Jo Lisa"];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    nameLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    [nameLabel setFont:[UIFont fontWithName:@"arial" size:17]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [_userView addSubview:nameLabel];
    [self.view addSubview:_userView];
    UILabel *userInfo = [[UILabel alloc]initWithFrame:CGRectMake((Width-200)/2, 200/2-40+80+5+20+5, 200, 20)];
    [userInfo setText:@"90后狮子座 不时神经质"];
    [userInfo setTextAlignment:NSTextAlignmentCenter];
    [userInfo setFont:[UIFont fontWithName:@"arial" size:15]];
    [userInfo setTextColor:[UIColor whiteColor]];
    [_userView addSubview:userInfo];
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, _userView.frame.size.height, Width, Height-_userView.frame.size.height-58-1)];
    [_centerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_centerView];
    _bottom = [[BottomView alloc]initWithFrame:CGRectMake(0, Height-59, Width, 58)];
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"userInfoView" owner:self options:nil];
    UIView *userInfoView = [array objectAtIndex:0];
    /*加载假数据*/
    for (int i = 6000; i<6003; i++) {
        UILabel *label = (UILabel *)[userInfoView viewWithTag:i];
        [label setText:[NSString stringWithFormat:@"%d",arc4random()%1000]];
    }
    [_centerView addSubview:userInfoView];
    UIView *lovedView = [[UIView alloc]initWithFrame:CGRectMake(5, userInfoView.frame.origin.y+userInfoView.frame.size.height, Width/2-10, 120)];
    UIView *boughtView = [[UIView alloc]initWithFrame:CGRectMake(Width/2+5, userInfoView.frame.origin.y+userInfoView.frame.size.height, Width/2-10, 120)];
    [lovedView setBackgroundColor:[UIColor redColor]];
    [boughtView setBackgroundColor:[UIColor cyanColor]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(boughtView.frame.size.width/2-20, boughtView.frame.size.height/2-20, 40, 40)];
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(boughtView.frame.size.width/2-20, boughtView.frame.size.height/2-20, 40, 40)];
    [lovedView addSubview:imageView];
    [boughtView addSubview:imageView2];
    [imageView setImage:[UIImage imageNamed:@"collection@2x.png"]];
    [imageView2 setImage:[UIImage imageNamed:@"buy@2x.png"]];
   
    UILabel *collectText = [[UILabel alloc]initWithFrame:CGRectMake(5, lovedView.frame.size.height-25, 40, 20)];
    [collectText setText:@"收藏"];
    UILabel *collect = [[UILabel alloc]initWithFrame:CGRectMake(5+40, lovedView.frame.size.height-25, 40, 20)];
    [collect setText:@"16"];
    UILabel *boughtText = [[UILabel alloc]initWithFrame:CGRectMake(5, boughtView.frame.size.height-25, 60, 20)];
    [boughtText setText:@"已购买"];
    UILabel *bought = [[UILabel alloc]initWithFrame:CGRectMake(5+60, boughtView.frame.size.height-25, 60, 20)];
    [bought setText:@"225"];
    [collect setTextColor:[UIColor whiteColor]];
        [collectText setTextColor:[UIColor whiteColor]];
        [boughtText setTextColor:[UIColor whiteColor]];
        [bought setTextColor:[UIColor whiteColor]];
    [lovedView addSubview:collectText];
    [lovedView addSubview:collect];
    [boughtView addSubview:bought];
    [boughtView addSubview:boughtText];
    [_centerView addSubview:lovedView];
    [_centerView addSubview:boughtView];
    [self.view addSubview:_bottom];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setArray:(NSMutableArray *)array{
    if (array) {
        _array = array;
        
    }
    
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
