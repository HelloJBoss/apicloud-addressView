//
//  RedView.m
//  创建视图控制器
//
//  Created by diandiju on 16/7/7.
//  Copyright © 2016年 WZB. All rights reserved.
//

#import "RedView.h"

@interface RedView ()
@property(nonatomic,strong)UIColor *color;
@property(nonatomic,assign)CGRect viewFrame;
@end
@implementation RedView
-(instancetype)initWithFrame:(CGRect)frame andColor:(UIColor *)color
{
    
    if (self = [super initWithFrame:frame]) {
        self.color = color;
        self.viewFrame = frame;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, self.viewFrame.size.height/2.0);
    CGContextAddLineToPoint(context, self.viewFrame.size.width/2.0, self.frame.size.height);
    CGContextAddLineToPoint(context, self.viewFrame.size.width, 0);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    
    
}




@end
