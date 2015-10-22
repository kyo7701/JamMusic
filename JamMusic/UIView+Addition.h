//
//  UIView+Addition.h
//  JamMusic
//
//  Created by 24k on 15/8/13.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)
-(UIViewController *)getViewController;
-(void)setOrigin:(CGPoint)point;
-(void)setX:(CGFloat)x;
-(void)setY:(CGFloat)y;
-(void)SetWidth:(CGFloat)width;
-(void)SetHeight:(CGFloat)height;
-(CGFloat)getWidth;
-(CGFloat)getHeight;
-(CGFloat)getY;
-(CGFloat)getX;
-(void)setSize:(CGSize)size;
@end
