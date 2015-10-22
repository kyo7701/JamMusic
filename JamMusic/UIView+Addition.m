//
//  UIView+Addition.m
//  JamMusic
//
//  Created by 24k on 15/8/13.
//  Copyright (c) 2015年 24k. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)
-(UIViewController *)getViewController{ // 取得根视图控制器
    UIResponder *next ;
    next = [self nextResponder];
    do {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            break;
        }
        next = [next nextResponder];
    } while (next != nil);
    return (UIViewController *)next;
}
-(void)setOrigin:(CGPoint)point{
    [self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
}
-(void)setX:(CGFloat)x{
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}
-(void)setY:(CGFloat)y{
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}
-(void)SetWidth:(CGFloat)width{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,width, self.frame.size.height)];
}
-(void)SetHeight:(CGFloat)height{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, height)];
}
-(CGFloat)getX{
    return self.frame.origin.y;
}
-(CGFloat)getY{
    return self.frame.origin.x;
}
-(CGFloat)getWidth{
    return self.frame.size.width;
}
-(CGFloat)getHeight{
    return self.frame.size.height;
}
-(void)setSize:(CGSize)size{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,size.width, size.height)];
}
@end
