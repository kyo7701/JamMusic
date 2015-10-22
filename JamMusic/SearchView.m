//
//  SearchView.m
//  JamMusic
//
//  Created by 24k on 15/10/16.
//  Copyright © 2015年 24k. All rights reserved.
//

#import "SearchView.h"
#import "netWorkTool.h"
#import "UIView+Addition.h"
#import "Player.h"
@implementation SearchView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.keyboardType = UIKeyboardTypeDefault;
        self.delegate = self;
        self.showsScopeBar = YES;
        
    }
    return self;
}
-(void)loadData{
    
}
-(void)doSearch{
    if ([self.text isEqualToString:@""]) {
        return;
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYYMMddHHmmSS"];
    NSString *dateStr = [format stringFromDate:date];
    NSString *secret = @"f1b7611e3abf4b5ea38e91d882c87a35";
    
    NSString *tempurl = [NSString stringWithFormat:@"?keyword=%@&page=1&showapi_appid=3374&showapi_timestamp=%@&showapi_sign=%@",self.text,dateStr,secret];
    [[Player SharedPlayer]setKeyWord:self.text];
    requestFinishBlock block = ^(id dict){
        
        _callBack(dict);
        
    };
    [netWorkTool requestWithUrl:tempurl andHTTPMethop:@"GET" requestFinishedBlock:block];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self doSearch];
    [self resignFirstResponder];
}

@end
