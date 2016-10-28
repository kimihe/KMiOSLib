//
//  KMMathHelper.m
//  BezierCurve_Test
//
//  Created by nali on 16/8/20.
//  Copyright © 2016年 Kimi. All rights reserved.
//

#import "KMMathHelper.h"

@implementation KMMathHelper

+ (CGPoint)getMiddleFromPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    CGPoint middle = CGPointMake((point1.x+point2.x)/2,
                                 (point1.y+point2.y)/2);
    return middle;
}

+ (double)getDistanceBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    double xDiff = point1.x - point2.x;
    double yDiff = point1.y - point2.y;
    double distance = sqrt(xDiff*xDiff + yDiff*yDiff);
    return distance;
}

+ (CGPoint)getNewPointFromCurrentPoint:(CGPoint)currentPoint offset:(double)offset angle:(double)angle
{
    CGPoint newPoint = CGPointMake(currentPoint.x + offset*cos(angle),
                                   currentPoint.y + offset*sin(angle));
    return newPoint;
}

+ (CGPoint)getNewPointFromStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint rate:(double)rate
{
    double xDiff = endPoint.x - startPoint.x;
    double yDiff = endPoint.y - startPoint.y;
    double xOffset = xDiff*rate;
    double yOffset = yDiff*rate;
    
    CGPoint newPoint = CGPointMake(startPoint.x+xOffset, startPoint.y+yOffset);
    return newPoint;
}

+ (double)getGradientFromPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    double xDiff = point2.x - point1.x;
    double yDiff = point2.y - point1.y;
    if (xDiff == 0) {//斜率无限大咱就不算了
        return NAN;
    }
    else {
        double gradient = yDiff/xDiff;
        if (isnan(gradient)) {//斜率太大超过系统阈值
            return NAN;
        }
        return gradient;
    }
}

@end
