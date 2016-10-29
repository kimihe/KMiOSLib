//
//  KMMathHelper.h
//  BezierCurve_Test
//
//  Created by nali on 16/8/20.
//  Copyright © 2016年 Kimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KMMathHelper : NSObject
/**
 *  求二维空间两点的中点
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 中点
 */
+ (CGPoint)getMiddleFromPoint1:(CGPoint)point1 point2:(CGPoint)point2;

/**
 *  求二维空间两点的几何距离
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 距离
 */
+ (double)getDistanceBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2;

/**
 *  根据位移和方向角求新的点
 *
 *  @param currentPoint 当前点
 *  @param offset       位移(位移为负时其实为反方向)
 *  @param angle        方向角
 *
 *  @return 新的点
 */
+ (CGPoint)getNewPointFromCurrentPoint:(CGPoint)currentPoint offset:(double)offset angle:(double)angle;

/**
 *  已知直线上起点和终点，根据位移比例求运动点
 *
 *  @param startPoint 起点
 *  @param endPoint   终点
 *  @param rate       比例
 *
 *  @return 运动点
 */
+ (CGPoint)getNewPointFromStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint rate:(double)rate;

/**
 *  求两点的斜率亦梯度
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 斜率(以点1->点2为正方向)，可能会因斜率无限大返回NAN，NAN请用isnan(k)来判断
 */
+(double)getGradientFromPoint1:(CGPoint)point1 point2:(CGPoint)point2;

/**
 *  判断两个CGPoint是否相同
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 相同返回YES，不同返回NO
 */
+ (BOOL)point1:(CGPoint)point1 EqualToPoint2:(CGPoint)point2;
@end
