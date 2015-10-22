//
//  SearchView.h
//  JamMusic
//
//  Created by 24k on 15/10/16.
//  Copyright © 2015年 24k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UISearchBar<UISearchBarDelegate>
@property (strong ,nonatomic) requestFinishBlock callBack;
@end
