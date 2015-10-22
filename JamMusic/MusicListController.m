
//
//  MusicListController.m
//  JamMusic
//
//  Created by 24k on 15/7/12.
//  Copyright (c) 2015年 24k. All rights reserved.
//  歌单

#import "MusicListController.h"
#import "LionTable.h"
#import "musicModel.h"
#import <UIImageView+AFNetworking.h>
#import "MusicPlayController.h"
#import "UIView+Addition.h"
@interface MusicListController ()

@end

@implementation MusicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放列表";
    CGRect rect = self.view.frame;
    rect.size.height -= 64;
    _table = [[LionTable alloc]initWithFrame:rect style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.scrollEnabled = YES;
    [self.view addSubview:_table];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(void)setData:(NSMutableArray *)data{
    if (!data) {
        return;
    }
    if (!_data) {
        _data = [[NSMutableArray alloc]initWithArray:[data copy]];
    }
    [_table reloadData];
}


//-(void)setImgData:(NSMutableArray *)imgData{
//    if (imgData) {
//        return;
//    }
//    if (!_imgData) {
//        _imgData = [[NSMutableArray alloc]initWithArray:[imgData copy]];
//    }
//    [self reloadData];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellReuse=@"Mytable";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellReuse];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuse];
    }
    //    从网上加载数据
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.data) {
        cell.text = @"aa";
    }else{
        musicModel *model = [_data objectAtIndex:indexPath.row];
        
        cell.text = [model getAttribute:@"songname"];
        [cell.imageView.layer setCornerRadius:5.0];
        NSString *urlStr = [model getAttribute:@"albumpic_small"];
        __weak UITableViewCell *requestCell = cell;
        
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [requestCell.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"0002.jpeg"]success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [requestCell setNeedsLayout];
            [requestCell.imageView setImage:image];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

        }];
        
        /*去文档查找是否存在同名歌曲，创建新文件夹，文件夹存放model,音乐文件,相关图片*/
    }
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect rect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:rect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushToPlayerControllerWithIndex:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
    [view setBackgroundColor:[UIColor grayColor]];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [button addTarget:self action:@selector(pushToPlayerControllerWithIndex:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Lion's List" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [view addSubview:button];
    
    return view;
}
-(void)pushToPlayerControllerWithIndex:(NSInteger)index{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    MusicPlayController *music = [[MusicPlayController alloc] init];
    if (self.data) {
        [music setDataArray:self.data];
    }
    
    [music setIndex:index];
    [[Player SharedPlayer] playAtIndex:index];
    [[Player SharedPlayer] PlayingInfo];
    
    [self.navigationController pushViewController:music animated:YES];
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
