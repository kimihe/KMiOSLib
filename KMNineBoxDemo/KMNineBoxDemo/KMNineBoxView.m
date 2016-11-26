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
    CGFloat _selfFrameSquareWidth;          //!< 如果frame不是正方形，则取短边构造内置正方形
    
    CGFloat _unitLength;                    //!< 计算所需的单位长度，为KMNineBoxView幕宽度的八分之一
    CGFloat _marginWidth;                   //!< 页边距
    CGFloat _boxWidth;                      //!< 九宫格实际正方形底的边长，为页边距地两倍
    CGFloat _circleRadius;                  //!< 圆的半径，为0.7单位长度
    
    // 九宫格绘图相关
    NSMutableArray *_nineCirclesArr;        //!< 保存9个circleLayer的数组会随frame变化
    NSArray *_boxCentersArr;                //!< 保存9个中心点的位置，会随frame变化
    
    // 跟踪九宫格状态
    NSMutableArray *_sequenceArr;           //!< 保存九宫格序列的数组，会随触摸手势变化
    KMNineBoxState _nineBoxState;           //!< 九宫格底状态，主要关注普通和失败两种状态
    
    //连线相关
    NSMutableArray *_connectionLinesArr;    //!< 保存连线的数组，会随触摸手势变化
    CGPoint _currentBoxCenter;              //!< 现在这个中心点，两点确定一条线
    CGPoint _previousBoxCenter;             //!< 之前那个中心点，两点确定一条线
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
    
    _nineCirclesArr = [NSMutableArray arrayWithCapacity:9];
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
    
    CGPoint boxCneter0 = CGPointMake(_unitLength+_unitLength *1, _unitLength+_unitLength *1);
    CGPoint boxCneter1 = CGPointMake(_unitLength+_unitLength *3, _unitLength+_unitLength *1);
    CGPoint boxCneter2 = CGPointMake(_unitLength+_unitLength *5, _unitLength+_unitLength *1);
    CGPoint boxCneter3 = CGPointMake(_unitLength+_unitLength *1, _unitLength+_unitLength *3);
    CGPoint boxCneter4 = CGPointMake(_unitLength+_unitLength *3, _unitLength+_unitLength *3);
    CGPoint boxCneter5 = CGPointMake(_unitLength+_unitLength *5, _unitLength+_unitLength *3);
    CGPoint boxCneter6 = CGPointMake(_unitLength+_unitLength *1, _unitLength+_unitLength *5);
    CGPoint boxCneter7 = CGPointMake(_unitLength+_unitLength *3, _unitLength+_unitLength *5);
    CGPoint boxCneter8 = CGPointMake(_unitLength+_unitLength *5, _unitLength+_unitLength *5);
    _boxCentersArr = @[[NSValue valueWithCGPoint:boxCneter0],
                       [NSValue valueWithCGPoint:boxCneter1],
                       [NSValue valueWithCGPoint:boxCneter2],
                       [NSValue valueWithCGPoint:boxCneter3],
                       [NSValue valueWithCGPoint:boxCneter4],
                       [NSValue valueWithCGPoint:boxCneter5],
                       [NSValue valueWithCGPoint:boxCneter6],
                       [NSValue valueWithCGPoint:boxCneter7],
                       [NSValue valueWithCGPoint:boxCneter8]
                       ];
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
    
    for (NSValue *aValue in _boxCentersArr) {
        CGPoint aBoxCenter = [aValue CGPointValue];
        NSMutableDictionary *aCircleLayerDic = [self drawCircleAtPoint:aBoxCenter withRadius:_circleRadius];
        [_nineCirclesArr addObject:aCircleLayerDic];
        
        CAShapeLayer *circleLayer = [aCircleLayerDic objectForKey:kCircleLayer];
        CAShapeLayer *pointLayer = [aCircleLayerDic objectForKey:kPointLayer];
        [self.layer addSublayer:circleLayer];
        [self.layer addSublayer:pointLayer];
    }
}

- (void)reloadNineBox
{
    // need improve
//    return;
    // reload sublayers 只需要调整位置
    // 千万不能改变大小，调整层级，或者增删层级！
    // 千万不能改变大小，调整层级，或者增删层级！
    // 千万不能改变大小，调整层级，或者增删层级！
    // 重要的事说三遍
    
    if ([_nineCirclesArr count] != 9) {
        return;
    }
    
    for (int i = 0; i < [_nineCirclesArr count]; i++) {
        NSDictionary *aDic = _nineCirclesArr[i];
        CAShapeLayer *circleLayer = [aDic objectForKey:kCircleLayer];
        CAShapeLayer *pointLayer = [aDic objectForKey:kPointLayer];
        
        CGPoint boxCenter = [_boxCentersArr[i] CGPointValue];
        // 这里及时重设字典中圆心位置的信息
        [_nineCirclesArr[i] setObject:[NSValue valueWithCGPoint:boxCenter] forKey:kBoxCenter];
        
        
        
        // 画圆圈
        CGRect frameCircle = CGRectMake(boxCenter.x-_circleRadius, boxCenter.y-_circleRadius, _circleRadius *2, _circleRadius *2);
        //create a path: 矩形内切圆
        UIBezierPath *bezierPathCircle = [UIBezierPath bezierPathWithOvalInRect:frameCircle];
        //draw the path using a CAShapeLayer
        circleLayer.path = bezierPathCircle.CGPath;
        
        
        // 画中心的圆点
        CGRect framePoint = CGRectMake(boxCenter.x-_circleRadius/4, boxCenter.y-_circleRadius/4, _circleRadius /4*2, _circleRadius /4*2);
        //create a path: 矩形内切圆
        UIBezierPath *bezierPathPoint = [UIBezierPath bezierPathWithOvalInRect:framePoint];
        //draw the path using a CAShapeLayer
        pointLayer.path = bezierPathPoint.CGPath;
        
//////////////////////////////////////////////////////////////////////////////////////////////////////
        //有点迷，这里的position
//        circleLayer.position = CGPointMake(2, 2);
//////////////////////////////////////////////////////////////////////////////////////////////////////
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

- (NSMutableDictionary *)drawCircleAtPoint:(CGPoint)center withRadius:(CGFloat)radius
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
    NSMutableDictionary *circleLayerDic = [NSMutableDictionary dictionary];
    [circleLayerDic setObject:circleLayer forKey:kCircleLayer];
    [circleLayerDic setObject:pointLayer forKey:kPointLayer];
    [circleLayerDic setObject:boxCenter forKey:kBoxCenter];
    
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
                NSInteger circleIndex = [_sequenceArr[i] integerValue];
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
    
    NSString *checkStr = [NSString stringWithFormat:@"%ld", circleIndex];
    if (![self checkString:checkStr isInArray:_sequenceArr]) {
        // 不允许重复添加
        [_sequenceArr addObject:checkStr];
    }
    
    [self drawConnectionLine];
}

- (void)drawConnectionLine
{
    NSInteger count = [_sequenceArr count];
    if (count > 1) {
        // 只有一个圆被触摸的时候不用画连接线
        NSInteger currentIndex = [[_sequenceArr lastObject] integerValue];
        NSInteger previousIndex = [[_sequenceArr objectAtIndex:(count-2)] integerValue];
        
        NSDictionary *currentCircleLayerDic = _nineCirclesArr[currentIndex];
        NSDictionary *previousCircleLayerDic = _nineCirclesArr[previousIndex];
        
        CGPoint currentBoxCenter = [[currentCircleLayerDic objectForKey:kBoxCenter] CGPointValue];
        CGPoint previousBoxCenter = [[previousCircleLayerDic objectForKey:kBoxCenter] CGPointValue];
        
        // 新的两点连线，才继续画
        if ([KMMathHelper point1:currentBoxCenter EqualToPoint2:_currentBoxCenter] &&
            [KMMathHelper point1:previousBoxCenter EqualToPoint2:_previousBoxCenter]) {
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
    NSMutableArray *distanceArr = [NSMutableArray arrayWithCapacity:9];
    for (int i = 0; i < [_nineCirclesArr count]; i++) {
        NSDictionary *aDic = _nineCirclesArr[i];
        CGPoint aBoxCenter = [[aDic objectForKey:kBoxCenter] CGPointValue];
        double distance = [KMMathHelper getDistanceBetweenPoint1:touchPoint point2:aBoxCenter];
        [distanceArr addObject:[NSNumber numberWithDouble:distance]];
    }
    
    double minD = [distanceArr[0] doubleValue]; // 最短的距离
    int index = 0;    // 最短距离对应的序号
    for (int i = 0; i<[distanceArr count]; i++) {
        double d = [distanceArr[i] doubleValue];
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
        
        //程序员从0计数，这里需要转换成用户习惯从1开始，如果不需要考虑这一点，那么直接取出用即可
        NSString *tmp = [NSString stringWithFormat:@"%ld", [_sequenceArr[i] integerValue] +1];
        sequenceStr = [NSString stringWithFormat:@"%@%@", sequenceStr, tmp];
    }
    NSLog(@"Seq: %@", sequenceStr);
    
    if ([self.predefinedPassSeq isEqualToString:sequenceStr]) {
        [self setNineBoxState:KMNineBoxStatePassed];
    }
    else {
        [self setNineBoxState:KMNineBoxStateFailed];
    }
    
    if ([self.delegate respondsToSelector:@selector(nineBoxDidFinishWithState:passSequence:)]) {
        [self.delegate nineBoxDidFinishWithState:_nineBoxState passSequence:sequenceStr];
    }
    
    // 再重置前不再响应用户触摸
    self.userInteractionEnabled = NO;

    //延迟1秒再重置
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [self resetNineBox];
    });
}

@end
