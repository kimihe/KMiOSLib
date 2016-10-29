//
//  KMNineBoxView.m
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#define USE_DEBUG 0
#define USE_DRAWRECT 0

#define kCircleStrokeColorNormal  colorFromRGBA(0x89CFF0,   1.0).CGColor
#define kCircleStrokeColorTouched colorFromRGBA(0xAACFFF,   1.0).CGColor
#define kCircleStorkeColorInvalid [UIColor                  redColor].CGColor

#define kCircleLineWidthNormal                              1.0f
#define kCircleLineWidthTouched                             2.0f
#define kCircleLineWidthInvalid                             1.0f

#define kPointFillColorNormal  [UIColor                     clearColor].CGColor
#define kPointFillColorTouched colorFromRGBA(0xAACFFF,      1.0).CGColor
#define kPointFillColorInvalid [UIColor                     redColor].CGColor

#define kConnectionLineColorTouched colorFromRGBA(0xAACFFF, 1.0).CGColor
#define kConnectionLineColorInvalid [UIColor                redColor].CGColor
#define kConnectionLineWidth                                3.0f

#define kCircleLayer @"circleLayer"
#define kPointLayer  @"pointLayer"
#define kBoxCenter   @"boxCenter"

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
    

    NSArray *_nineCirclesArr;               //!< 保存9个circleLayer的数组，继initWithFrame后就长期保存直到view销毁
    NSMutableArray *_sequenceArr;           //!< 保存九宫格序列的数组
    KMNineBoxState _nineBoxState;           //!< 九宫格底状态，主要关注普通和失败两种状态
    
    //连线相关
    NSMutableArray *_connectionLinesArr;    //!< 保存连线的数组
    CGPoint _currentBoxCenter;              //!< 现在这个中心点
    CGPoint _previousBoxCenter;             //!< 之前那个中心点
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupBoundsAndFrame];
        [self drawNineBox];
    }
    return self;
}

- (void)initData
{
#if USE_DEBUG
    self.backgroundColor = [UIColor grayColor];
#endif
    
    _sequenceArr = [NSMutableArray arrayWithCapacity:9];// 9个点最多序列长度为9
    _connectionLinesArr = [NSMutableArray arrayWithCapacity:8];// 9个点最多也就8根线
    self.predefinedPassSeq = @"#########";
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

#pragma mark -  Set Nine Box
- (void)drawNineBox
{
    // 消除一切sublayer
    if ([self.layer.sublayers count] > 0) {
        self.layer.sublayers = nil;
    }
    
    // 粗暴易懂的绘制
    NSDictionary *circleLayerDic1 = [self drawCircleAtPoint:_boxCneter1 withRadius:_circleRadius];
    NSDictionary *circleLayerDic2 = [self drawCircleAtPoint:_boxCneter2 withRadius:_circleRadius];
    NSDictionary *circleLayerDic3 = [self drawCircleAtPoint:_boxCneter3 withRadius:_circleRadius];
    NSDictionary *circleLayerDic4 = [self drawCircleAtPoint:_boxCneter4 withRadius:_circleRadius];
    NSDictionary *circleLayerDic5 = [self drawCircleAtPoint:_boxCneter5 withRadius:_circleRadius];
    NSDictionary *circleLayerDic6 = [self drawCircleAtPoint:_boxCneter6 withRadius:_circleRadius];
    NSDictionary *circleLayerDic7 = [self drawCircleAtPoint:_boxCneter7 withRadius:_circleRadius];
    NSDictionary *circleLayerDic8 = [self drawCircleAtPoint:_boxCneter8 withRadius:_circleRadius];
    NSDictionary *circleLayerDic9 = [self drawCircleAtPoint:_boxCneter9 withRadius:_circleRadius];
    
    
    _nineCirclesArr = @[circleLayerDic1,
                        circleLayerDic2,
                        circleLayerDic3,
                        circleLayerDic4,
                        circleLayerDic5,
                        circleLayerDic6,
                        circleLayerDic7,
                        circleLayerDic8,
                        circleLayerDic9];
    
    for (NSDictionary *aDic in _nineCirclesArr) {
        CAShapeLayer *circleLayer = [aDic objectForKey:kCircleLayer];
        CAShapeLayer *pointLayer = [aDic objectForKey:kPointLayer];
        [self.layer addSublayer:circleLayer];
        [self.layer addSublayer:pointLayer];
    }
}

- (void)reloadNineBox
{
    // need improve
    return;
    // reload sublayers 只需要调整位置
    // 千万不能改变大小，调整层级，或者增删层级！
    // 千万不能改变大小，调整层级，或者增删层级！
    // 千万不能改变大小，调整层级，或者增删层级！
    // 重要的事说三遍
    if ([_nineCirclesArr count] != 9) {
        return;
    }
    
    for (NSDictionary *aDic in _nineCirclesArr) {
        CAShapeLayer *circleLayer = [aDic objectForKey:kCircleLayer];
        CAShapeLayer *pointLayer = [aDic objectForKey:kPointLayer];
        CGPoint boxCenter = [[aDic objectForKey:kBoxCenter] CGPointValue];
        
        circleLayer.anchorPoint = CGPointMake(0.5, 0.5);
        pointLayer.anchorPoint = CGPointMake(0.5, 0.5);
        
        circleLayer.position = boxCenter;
        pointLayer.position = boxCenter;
    }

}

- (void)resetNineBox
{
    // 恢复响应用户手势
    self.userInteractionEnabled = YES;
    
    [self setNineBoxState:KMNineBoxStateNormal];
    
    // 上一步设置完普通状态后，再销毁这两个数组
    [_sequenceArr removeAllObjects];
    [_connectionLinesArr removeAllObjects];
}

- (NSDictionary *)drawCircleAtPoint:(CGPoint)center withRadius:(CGFloat)radius
{
    // 画圆圈
    CGRect frameCircle = CGRectMake(center.x-_circleRadius, center.y-_circleRadius, _circleRadius *2, _circleRadius *2);
    //create a path: 矩形内切圆
    UIBezierPath *bezierPathCircle = [UIBezierPath bezierPathWithOvalInRect:frameCircle];
    //draw the path using a CAShapeLayer
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = bezierPathCircle.CGPath;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = kCircleStrokeColorNormal;
    circleLayer.lineWidth = kCircleLineWidthNormal;
    
    // 画中心的圆点
    CGRect framePoint = CGRectMake(center.x-_circleRadius/4, center.y-_circleRadius/4, _circleRadius /4*2, _circleRadius /4*2);
    //create a path: 矩形内切圆
    UIBezierPath *bezierPathPoint = [UIBezierPath bezierPathWithOvalInRect:framePoint];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pointLayer = [CAShapeLayer layer];
    pointLayer.path = bezierPathPoint.CGPath;
#if USE_DEBUG
    pointLayer.fillColor = [UIColor greenColor].CGColor;
    pointLayer.strokeColor = [UIColor greenColor].CGColor;
#else
    pointLayer.fillColor = kPointFillColorNormal;
    pointLayer.strokeColor = kPointFillColorNormal;
#endif
    pointLayer.lineWidth = kCircleLineWidthNormal;

    // 圆心位置
    NSValue *boxCenter = [NSValue valueWithCGPoint:center];
    
    //保存圆圈，圆点和圆心位置
    NSDictionary *circleLayerDic = @{
                                     kCircleLayer : circleLayer,
                                     kPointLayer  : pointLayer,
                                     kBoxCenter   : boxCenter
                                     };
    
    return circleLayerDic;
}

- (void)setNineBoxState:(KMNineBoxState)nineBoxState
{
    _nineBoxState = nineBoxState;
    
    switch (nineBoxState) {
        case KMNineBoxStateNormal: {
            // 设置9个圆圈为普通状态
            for (NSDictionary *aDic in _nineCirclesArr) {
                CAShapeLayer *circleLayer = [aDic objectForKey:kCircleLayer];
                CAShapeLayer *pointLayer = [aDic objectForKey:kPointLayer];
                
                circleLayer.strokeColor = kCircleStrokeColorNormal;
                circleLayer.lineWidth = kCircleLineWidthNormal;
                
                pointLayer.fillColor = kPointFillColorNormal;
                pointLayer.strokeColor = kPointFillColorNormal;
            }
            
            //消除红色连线
            for (int i = 0; i < [_connectionLinesArr count]; i++) {
                CAShapeLayer *aLinelayer = _connectionLinesArr[i];
                [aLinelayer removeFromSuperlayer];
            }
            
            break;
        }
            
        case KMNineBoxStateTouched: {
            
            break;
        }
            
        case KMNineBoxStatePassed: {
            
            break;
        }
            
        case KMNineBoxStateFailed: {
            // 设置触摸过的圆圈为红色
            for (int i = 0; i < [_sequenceArr count]; i++) {
                // 取出序列的每一个单步
                NSInteger circleIndex = [_sequenceArr[i] integerValue] -1; // 减1
                // 找出对应的circleLayerDic
                NSDictionary *aDic = _nineCirclesArr[circleIndex];
                CAShapeLayer *circleLayer = [aDic objectForKey:kCircleLayer];
                CAShapeLayer *pointLayer = [aDic objectForKey:kPointLayer];
                
                circleLayer.strokeColor = kCircleStorkeColorInvalid;
                circleLayer.lineWidth = kCircleLineWidthInvalid;
                
                pointLayer.fillColor = kPointFillColorInvalid;
                pointLayer.strokeColor = kPointFillColorInvalid;
            }
            
            //设置连线为红色
            for (int i = 0; i < [_connectionLinesArr count]; i++) {
                CAShapeLayer *aLinelayer = _connectionLinesArr[i];
                aLinelayer.fillColor = kConnectionLineColorInvalid;
                aLinelayer.strokeColor = kConnectionLineColorInvalid;
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)decorateCircleWithBoxIndex:(KMNineBoxIndex)index
{
    if (index == KMNineBoxIndexNone) {
        return;
    }
    
    NSInteger circleIndex = log2(index);
//    NSLog(@"circleIndex: %ld", (long)circleIndex);
    
    NSDictionary *aDic = _nineCirclesArr[circleIndex];
    CAShapeLayer *circleLayer = [aDic objectForKey:kCircleLayer];
    CAShapeLayer *pointLayer = [aDic objectForKey:kPointLayer];
    
    circleLayer.strokeColor = kCircleStrokeColorTouched;
    circleLayer.lineWidth = kCircleLineWidthTouched;
    
    pointLayer.fillColor = kPointFillColorTouched;
    pointLayer.strokeColor = kPointFillColorTouched;
    
    NSString *checkStr = [NSString stringWithFormat:@"%ld", circleIndex+1];//加1
    if (![self checkString:checkStr isInArray:_sequenceArr]) {
        [_sequenceArr addObject:checkStr];
    }
    
    [self drawConnectionLine];
}

- (void)drawConnectionLine
{
    NSInteger count = [_sequenceArr count];
    if (count > 1) {
        // 只有一个圆被触摸的时候不用画连接线
        NSInteger currentIndex = [[_sequenceArr lastObject] integerValue]-1;//减1
        NSInteger previousIndex = [[_sequenceArr objectAtIndex:(count-2)] integerValue]-1;//减1
        
        NSDictionary *currentCircleLayerDic = _nineCirclesArr[currentIndex];
        NSDictionary *previousCircleLayerDic = _nineCirclesArr[previousIndex];
        
        CGPoint currentBoxCenter = [[currentCircleLayerDic objectForKey:kBoxCenter] CGPointValue];
        CGPoint previousBoxCenter = [[previousCircleLayerDic objectForKey:kBoxCenter] CGPointValue];
        
        // 新的两点连线，才继续画
        if ([KMMathHelper point1:currentBoxCenter EqualToPoint2:_currentBoxCenter]) {
            return;
        }
        if ([KMMathHelper point1:previousBoxCenter EqualToPoint2:_previousBoxCenter]) {
            return;
        }
        // 保存最近的两个点
        _currentBoxCenter = currentBoxCenter;
        _previousBoxCenter = previousBoxCenter;
        
        
        
        // 画线
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint: previousBoxCenter];
        [linePath addLineToPoint: currentBoxCenter];
        lineLayer.path = linePath.CGPath;
        lineLayer.fillColor = kConnectionLineColorTouched;
        lineLayer.strokeColor = kConnectionLineColorTouched;
        lineLayer.lineWidth = kConnectionLineWidth;
        
        [self.layer addSublayer:lineLayer];
        
        [_connectionLinesArr addObject:lineLayer];
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
//    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"ended point: (%f,%f)", point.x, point.y);
    
    
    
    
    
    NSString *sequenceStr = @"";
    for (int i = 0; i < [_sequenceArr count]; i++) {
        NSString *tmp = [NSString stringWithFormat:@"%@", _sequenceArr[i]];
        sequenceStr = [NSString stringWithFormat:@"%@%@", sequenceStr, tmp];
    }
    NSLog(@"Seq: %@", sequenceStr);
    
    if ([self.predefinedPassSeq isEqualToString:sequenceStr]) {
        [self setNineBoxState:KMNineBoxStatePassed];
    }
    else {
        [self setNineBoxState:KMNineBoxStateFailed];
    }
    
    [self.delegate nineBoxDidFinishWithState:_nineBoxState passSequence:sequenceStr];
    
    // 再重置前不再响应用户触摸
    self.userInteractionEnabled = NO;

    //延迟1秒再重置
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [self resetNineBox];
    });
}





@end
