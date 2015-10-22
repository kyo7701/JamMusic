//
//  LionTable.m
//  JamMusic
//
//  Created by 24k on 15/7/27.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "LionTable.h"
#import "musicModel.h"
#import <UIImageView+AFNetworking.h>
#import "MusicListController.h"
#import "UIView+Addition.h"
#import <MJExtension.h>
@implementation LionTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
//        self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
        
        [self setBackgroundView:nil];
        
        
        UIImageView *back = [[UIImageView alloc]initWithFrame:frame];
        [back setImage:[UIImage imageNamed:@"table_background.png"]];
        UIVisualEffectView *effect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [effect setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [back addSubview:effect];
        [self setBackgroundView:back];
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled =NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
-(void)setData:(NSMutableArray *)data{
    if (!data) {
        return;
    }
    if (!_data) {
        _data = [[NSMutableArray alloc]initWithArray:[data copy]];
    }else{
       _data = [data copy];
    }
    
    [self reloadData];
}

    
-(void)setImgData:(NSMutableArray *)imgData{
    if (imgData) {
        return;
    }
    if (!_imgData) {
        _imgData = [[NSMutableArray alloc]initWithArray:[imgData copy]];
    }
    [self reloadData];
}
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

        [cell.textLabel setText: @"aa"];
    }else{
        
        musicModel *model = [_data objectAtIndex:indexPath.row];
        [cell.textLabel setText: [model getAttribute:@"songname" ]];
        [cell.imageView.layer setCornerRadius:5.0];
        NSString *urlStr = [model getAttribute:@"albumpic_small"];
        __weak UITableViewCell *requestCell = cell;
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
//        requestCell.imageView.clipsToBounds = YES;

        [requestCell.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"0002.jpeg"]success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [requestCell setNeedsLayout];
            [requestCell.imageView setImage:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        if (self.imgData) {
            [cell.imageView setImage:[_imgData objectAtIndex:indexPath.row]];
            [cell setNeedsLayout];
        }
        /*去文档查找是否存在同名歌曲，创建新文件夹，文件夹存放model,音乐文件,相关图片*/
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushToListWithIndex:indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
    [view setBackgroundColor:[UIColor grayColor]];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [button addTarget:self action:@selector(pushToListWithIndex:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Lion's List" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [view addSubview:button];
    
    return view;
}
-(void)pushToListWithIndex:(NSInteger)index{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    MusicListController *list = [[MusicListController alloc]init];
    list.controller = _controller;
    list.data = self.data;
    UIViewController *controller = [self getViewController];
    if (list) {
        [controller.navigationController pushViewController:list animated:YES];
    }
    
}
@end
