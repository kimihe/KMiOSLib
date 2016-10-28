//
//  KMNineBoxView.m
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#define USE_DEBUG 0
#define USE_DRAWRECT 0

#import "KMNineBoxView.h"
#import "KMUIKitMacro.h"
#import "KMMathHelper.h"

typedef NS_ENUM(NSInteger, KMNineBoxIndex) {
    KMNineBoxIndexNone = 0,
    
    KMNineBoxIndex1 = 1<<0,
    KMNineBoxIndex2 = 1<<1,
    KMNineBoxIndex3 = 1<<2,
    KMNineBoxIndex4 = 1<<3,
    KMNineBoxIndex5 = 1<<4,
    KMNineBoxIndex6 = 1<<5,
    KMNineBoxIndex7 = 1<<6,
    KMNineBoxIndex8 = 1<<7,
    KMNineBoxIndex9 = 1<<8
};

@implementation KMNineBoxView
{
    CGFloat _selfBoundsX;
    CGFloat _selfBoundsY;
    
    CGFloat _selfFrameX;
    CGFloat _selfFrameY;
    CGFloat _selfFrameWidth;
    CGFloat _selfFrameHeight;
    CGFloat _selfFrameSquareWidth;      //!< 如果frame不是正方形，则取短边构造内置正方形
    
    CGFloat _unitLength;                //!< 计算所需的单位长度，为KMNineBoxView幕宽度的八分之一
    CGFloat _marginWidth;               //!< 页边距
    CGFloat _boxWidth;                  //!< 九宫格实际正方形底的边长，为页边距地两倍
    CGFloat _circleRadius;              //!< 圆的半径，为0.7单位长度
    
    CGPoint _boxCneter1;
    CGPoint _boxCneter2;
    CGPoint _boxCneter3;
    CGPoint _boxCneter4;
    CGPoint _boxCneter5;
    CGPoint _boxCneter6;
    CGPoint _boxCneter7;
    CGPoint _boxCneter8;
    CGPoint _boxCneter9;
    
    CAShapeLayer *_circleLayer1;
    CAShapeLayer *_circleLayer2;
    CAShapeLayer *_circleLayer3;
    CAShapeLayer *_circleLayer4;
    CAShapeLayer *_circleLayer5;
    CAShapeLayer *_circleLayer6;
    CAShapeLayer *_circleLayer7;
    CAShapeLayer *_circleLayer8;
    CAShapeLayer *_circleLayer9;
    
    NSMutableArray *_sequenceArr;
    NSInteger _stepCount;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
#if USE_DEBUG
        self.backgroundColor = [UIColor grayColor];
#endif
        _sequenceArr = [NSMutableArray arrayWithCapacity:9];
        [self setupBoundsAndFrame];
        [self drawNineBox];
    }
    return self;
}

- (void)setupBoundsAndFrame
{
    _selfBoundsX      = self.bounds.origin.x;
    _selfBoundsY      = self.bounds.origin.y;
    
    _selfFrameX       = self.frame.origin.x;
    _selfFrameY       = self.frame.origin.y;
    _selfFrameWidth   = self.frame.size.width;
    _selfFrameHeight  = self.frame.size.height;
    _selfFrameSquareWidth = (_selfFrameWidth<=_selfFrameHeight)? _selfFrameWidth : _selfFrameHeight;
    
    _unitLength = _selfFrameSquareWidth /8;
    _marginWidth = _unitLength;
    _boxWidth = _unitLength *2;
    _circleRadius = _unitLength *0.7;
    
    _boxCneter1 = CGPointMake(_unitLength+_unitLength *1, _unitLength+_unitLength *1);
    _boxCneter2 = CGPointMake(_unitLength+_unitLength *3, _unitLength+_unitLength *1);
    _boxCneter3 = CGPointMake(_unitLength+_unitLength *5, _unitLength+_unitLength *1);
    _boxCneter4 = CGPointMake(_unitLength+_unitLength *1, _unitLength+_unitLength *3);
    _boxCneter5 = CGPointMake(_unitLength+_unitLength *3, _unitLength+_unitLength *3);
    _boxCneter6 = CGPointMake(_unitLength+_unitLength *5, _unitLength+_unitLength *3);
    _boxCneter7 = CGPointMake(_unitLength+_unitLength *1, _unitLength+_unitLength *5);
    _boxCneter8 = CGPointMake(_unitLength+_unitLength *3, _unitLength+_unitLength *5);
    _boxCneter9 = CGPointMake(_unitLength+_unitLength *5, _unitLength+_unitLength *5);
}

- (void)layoutSubviews
{
    //改变frame，subviews，sublayers会跑进来
    [self setupBoundsAndFrame];
    
#if USE_DRAWRECT
    [self setNeedsDisplay];
#else
    [self reloadNineBox];
#endif
}

#if USE_DRAWRECT
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //     [[UIColor clearColor] setFill];  // changes are here
    //     UIRectFill(rect);
    [self reloadBaseCircle];
}
#endif

#pragma mark - Nine Box
- (void)drawNineBox
{
//    for (CAShapeLayer *aCircleLayer in self.layer.sublayers) {
//        [aCircleLayer removeFromSuperlayer];
//    }
    
    if ([self.layer.sublayers count] > 0) {
        self.layer.sublayers = nil;
    }
    
    // 粗暴易懂的绘制
    _circleLayer1 = [self drawCircleAtPoint:_boxCneter1 withRadius:_circleRadius];
    _circleLayer2 = [self drawCircleAtPoint:_boxCneter2 withRadius:_circleRadius];
    _circleLayer3 = [self drawCircleAtPoint:_boxCneter3 withRadius:_circleRadius];
    _circleLayer4 = [self drawCircleAtPoint:_boxCneter4 withRadius:_circleRadius];
    _circleLayer5 = [self drawCircleAtPoint:_boxCneter5 withRadius:_circleRadius];
    _circleLayer6 = [self drawCircleAtPoint:_boxCneter6 withRadius:_circleRadius];
    _circleLayer7 = [self drawCircleAtPoint:_boxCneter7 withRadius:_circleRadius];
    _circleLayer8 = [self drawCircleAtPoint:_boxCneter8 withRadius:_circleRadius];
    _circleLayer9 = [self drawCircleAtPoint:_boxCneter9 withRadius:_circleRadius];
    
    // 粗暴易懂的添加
    [self.layer addSublayer:_circleLayer1];
    [self.layer addSublayer:_circleLayer2];
    [self.layer addSublayer:_circleLayer3];
    [self.layer addSublayer:_circleLayer4];
    [self.layer addSublayer:_circleLayer5];
    [self.layer addSublayer:_circleLayer6];
    [self.layer addSublayer:_circleLayer7];
    [self.layer addSublayer:_circleLayer8];
    [self.layer addSublayer:_circleLayer9];
}

- (void)reloadNineBox
{
    [self drawNineBox];
}

- (CAShapeLayer *)drawCircleAtPoint:(CGPoint)center withRadius:(CGFloat)radius
{
    CGRect frame = CGRectMake(center.x-_circleRadius, center.y-_circleRadius, _circleRadius *2, _circleRadius *2);
    //create a path: 矩形内切圆
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    //draw the path using a CAShapeLayer
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = bezierPath.CGPath;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = colorFromRGBA(0x89CFF0, 1.0).CGColor;
    circleLayer.lineWidth = 1.0f;
    
    return circleLayer;
}

- (void)decorateCircleWithBoxIndex:(KMNineBoxIndex)index
{
    switch (index) {
        case KMNineBoxIndex1: {
            _circleLayer1.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer1.lineWidth = 2.0f;
            
            if (![self checkString:@"1" isInArray:_sequenceArr]) {
                [_sequenceArr addObject:@"1"];
            }
            
            break;
        }
            
        case KMNineBoxIndex2: {
            _circleLayer2.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer2.lineWidth = 2.0f;
            
            if (![self checkString:@"2" isInArray:_sequenceArr]) {
                [_sequenceArr addObject:@"2"];
            }
            
            break;
        }
            
        case KMNineBoxIndex3: {
            _circleLayer3.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer3.lineWidth = 2.0f;
            
            if (![self checkString:@"3" isInArray:_sequenceArr]) {
                [_sequenceArr addObject:@"3"];
            }
            
             break;
        }
        
        case KMNineBoxIndex4: {
            _circleLayer4.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer4.lineWidth = 2.0f;
            
            if (![self checkString:@"4" isInArray:_sequenceArr]) {
               [_sequenceArr addObject:@"4"];
            }
            

            break;
        }
        case KMNineBoxIndex5: {
            _circleLayer5.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer5.lineWidth = 2.0f;
            
            if (![self checkString:@"5" isInArray:_sequenceArr]) {
                [_sequenceArr addObject:@"5"];
                
            }
            

            break;
        }
        case KMNineBoxIndex6: {
            _circleLayer6.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer6.lineWidth = 2.0f;
            
            if (![self checkString:@"6" isInArray:_sequenceArr]) {
                [_sequenceArr addObject:@"6"];
            }
            

            break;
        }
        case KMNineBoxIndex7: {
            _circleLayer7.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer7.lineWidth = 2.0f;
            
            if (![self checkString:@"7" isInArray:_sequenceArr]) {
                [_sequenceArr addObject:@"7"];
            }
            
            break;
        }
        case KMNineBoxIndex8: {
            _circleLayer8.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer8.lineWidth = 2.0f;
            
            if (![self checkString:@"8" isInArray:_sequenceArr]) {
                [_sequenceArr addObject:@"8"];
            }
            
            break;
        }
        case KMNineBoxIndex9: {
            _circleLayer9.strokeColor = colorFromRGBA(0xAACFFF, 1.0).CGColor;
            _circleLayer9.lineWidth = 2.0f;
            
            if (![self checkString:@"9" isInArray:_sequenceArr]) {
                [_sequenceArr addObject:@"9"];
            }
            

            break;
        }
          
        default:
            break;
    }
}

#pragma mark - Support Methods
- (KMNineBoxIndex)checkLocationWithTouchPoint:(CGPoint)touchPoint
{
    // 此处可以优化
    double d1 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter1];
    double d2 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter2];
    double d3 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter3];
    double d4 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter4];
    double d5 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter5];
    double d6 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter6];
    double d7 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter7];
    double d8 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter8];
    double d9 = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:_boxCneter9];
    
    NSArray *arr = @[[NSNumber numberWithDouble:d1],
                     [NSNumber numberWithDouble:d2],
                     [NSNumber numberWithDouble:d3],
                     [NSNumber numberWithDouble:d4],
                     [NSNumber numberWithDouble:d5],
                     [NSNumber numberWithDouble:d6],
                     [NSNumber numberWithDouble:d7],
                     [NSNumber numberWithDouble:d8],
                     [NSNumber numberWithDouble:d9]
                     ];
    
    double minD = d1; // 最短的距离
    int index = 0;    // 最短距离对应的序号
    for (int i = 0; i<9; i++) {
        double d = [arr[i] doubleValue];
        if (d < minD) {
            minD = d;
            index = i;
        }
    }
    
    if (minD > _circleRadius) {
        // 触点在圆外
        return KMNineBoxIndexNone;
    }
    else {
        // 触点在圆内
        KMNineBoxIndex boxIndex = 1<<index;
        return boxIndex;
    }
}

- (BOOL)checkString:(NSString *)str isInArray:(NSMutableArray *) arr {
    for (NSString *aStr in arr) {
        if ([aStr isEqualToString:str]) {
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - Touch Events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"begin point: (%f,%f)", point.x, point.y);
    
    KMNineBoxIndex index = [self checkLocationWithTouchPoint:point];
    [self decorateCircleWithBoxIndex:index];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"moved point: (%f,%f)", point.x, point.y);
    
    KMNineBoxIndex index = [self checkLocationWithTouchPoint:point];
    [self decorateCircleWithBoxIndex:index];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"ended point: (%f,%f)", point.x, point.y);
    
    
    NSLog(@"seq: %@", _sequenceArr);
    
    NSString *sequenceStr = @"";
    for (int i = 0; i < [_sequenceArr count]; i++) {
        NSString *tmp = [NSString stringWithFormat:@"%@", _sequenceArr[i]];
        sequenceStr = [NSString stringWithFormat:@"%@%@", sequenceStr, tmp];
    }
    [self.delegate nineBoxDidFinishWithSequence:sequenceStr];
    
    [_sequenceArr removeAllObjects];
}





@end
