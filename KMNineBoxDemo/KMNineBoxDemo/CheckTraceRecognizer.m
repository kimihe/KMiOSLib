//
//  CheckTraceRecognizer.m
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "CheckTraceRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CheckTraceRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
//    lastPreviousPoint = point;
//    lastCurrentPoint = point;
//    lineLengthSoFar = 0.0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint previousPoint = [touch previousLocationInView:self.view];
    CGPoint currentPoint = [touch locationInView:self.view];
//    CGFloat angle = angleBetweenLines(lastPreviousPoint,
//                                      lastCurrentPoint,
//                                      previousPoint,
//                                      currentPoint);
//    if (angle >= kMinimumCheckMarkAngle && angle <= kMaximumCheckMarkAngle
//        && lineLengthSoFar > kMinimumCheckMarkLength) {
//        self.state = UIGestureRecognizerStateRecognized;
//    }
//    lineLengthSoFar += distanceBetweenPoints(previousPoint, currentPoint);
//    lastPreviousPoint = previousPoint;
//    lastCurrentPoint = currentPoint;
}

# pragma mark - Support Methods
- (BOOL)checkPoint:(CGPoint)point InRect:(CGRect)rect
{
    return NO;
}



@end
