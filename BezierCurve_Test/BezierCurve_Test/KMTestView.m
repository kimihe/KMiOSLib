//
//  KMTestView.m
//  BezierCurve_Test
//
//  Created by nali on 16/8/18.
//  Copyright © 2016年 Kimi. All rights reserved.
//

#import "KMTestView.h"

@implementation KMTestView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextMoveToPoint(context, 10, 10);
//    CGContextAddLineToPoint(context, 200, 10);
//    CGContextAddLineToPoint(context, 200, 50);
//    CGContextAddLineToPoint(context, 10, 50);
//    CGContextAddLineToPoint(context, 10, 10);
    

    CGContextMoveToPoint(context, 10, 10);//设置Path的起点
    CGContextAddCurveToPoint(context,105, 30, 105, 30, 200, 10);//设置贝塞尔曲线的控制点坐标和控制点坐标终点坐标
    CGContextAddLineToPoint(context, 200, 50);
    CGContextAddCurveToPoint(context,105, 30, 105, 30, 10, 50);//设置贝塞尔曲线的控制点坐标和控制点坐标终点坐标
    CGContextAddLineToPoint(context, 10, 10);
    
    CGContextClosePath(context);//封起来
    
    //填充颜色
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    //描边颜色
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    
    //绘图
    CGContextDrawPath(context, kCGPathFillStroke);

//    CGContextStrokePath(context);
}


@end
