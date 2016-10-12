//
//  KMJellyView.m
//  BezierCurve_Test
//
//  Created by nali on 16/8/11.
//  Copyright © 2016年 Kimi. All rights reserved.
//

#define USE_DEBUG 0
#define USE_DRAWRECT 0

#define kDuration_restoreBezierCurve 0.1
#define kFlexibilityThreshold 200.0

#import "KMJellyView.h"
#import "KMMathHelper.h"

@implementation KMJellyView
{
    CGFloat _selfFrameX;
    CGFloat _selfFrameY;
    CGFloat _selfFrameWidth;
    CGFloat _selfFrameHeight;
    CGFloat _selfFrameSquareWidth;          //!< 如果frame不是正方形，则取短边构造内置正方形
    
    CGFloat _selfBoundsX;
    CGFloat _selfBoundsY;
    CGPoint _selfBoundsCircleCenter;        //!< 基本圆的中心点(圆点)
    
    CAShapeLayer *_baseCirclePathLayer;     //!< 初始的基本圆
    CGFloat _baseCircleRadius;              //!< 圆的半径
    CALayer *_centerPointPathLayer;
    
    
    
    CAShapeLayer *_bazierCurvePathLayer;    //!< 贝赛尔曲线
    BOOL _isToBlowOut;                      //!< 超过阈值则爆裂
    UIColor *_bazierFillColor;              //!< 贝塞尔曲线内部填充颜色
    //样式1的曲线相关
    CGPoint _bazierBeginPoint;              //!< 曲线起点
    CGPoint _bazierEndPoint;                //!< 曲线终点
    CGPoint _bazierControlPoint1;           //!< 控制点1
    CGPoint _bazierControlPoint2;           //!< 控制点2
    
    CADisplayLink *_restoreDL;              //!< 屏幕刷新DL
    CGPoint _touchEndPoint;                 //!< 手势最后离开点
    CGFloat _xDiff;                         //!< 曲线回复动画所需的X轴坐标差
    CGFloat _yDiff;                         //!< 曲线回复动画所需的Y轴坐标差
    
    //样式2的曲线相关
    CGPoint _bazierBeginPoint1_style2;      //!< 曲线1起点
    CGPoint _bazierEndPoint1_style2;        //!< 曲线1终点
    CGPoint _bazierBeginPoint2_style2;      //!< 曲线2起点
    CGPoint _bazierEndPoint2_style2;        //!< 曲线2终点
    CGPoint _bazierControlPoint1_style2;    //!< 两条曲线共同的控制点1
    CGPoint _bazierControlPoint2_style2;    //!< 两条曲线共同的控制点2
    
    CAShapeLayer *_newCirclePathLayer;      //!< 触摸点处新的圆

#if USE_DEBUG
    CALayer *_testLayer1;                     //!< Debug专用
    CALayer *_testLayer2;
    CALayer *_testLayer3;
    CALayer *_testLayer4;
#endif
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        _animationStyle = KMJellyViewAnimationStyle_peak;//贝塞尔曲线默认样式1
        [self setupBoundsAndFrame];
        //绘制基本圆
        [self drawBaseCircle];
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
    _baseCircleRadius =_selfFrameSquareWidth/2;
    _selfBoundsCircleCenter  = CGPointMake(_selfBoundsX + _selfFrameSquareWidth/2,
                                           _selfBoundsY + _selfFrameSquareWidth/2);
}

- (void)layoutSubviews
{
    //改变frame，subviews，sublayers会跑进来
    [self setupBoundsAndFrame];
    
#if USE_DRAWRECT
    [self setNeedsDisplay];
#else
    [self reloadBaseCircle];
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



#pragma mark - Base Circle
- (void)drawBaseCircle
{
    //每次重绘前都清除之前的基本圆
    if (_baseCirclePathLayer) {
        [_baseCirclePathLayer removeFromSuperlayer];
    }
    
    CGRect frame = CGRectMake(_selfBoundsX, _selfBoundsY, _selfFrameSquareWidth, _selfFrameSquareWidth);
    //create a path: 矩形内切圆
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    //draw the path using a CAShapeLayer
    _baseCirclePathLayer = [CAShapeLayer layer];
    _baseCirclePathLayer.path = bezierPath.CGPath;
    _baseCirclePathLayer.fillColor = [UIColor redColor].CGColor;
    _baseCirclePathLayer.strokeColor = [UIColor redColor].CGColor;
    _baseCirclePathLayer.lineWidth = 1.0f;
    [self.layer addSublayer:_baseCirclePathLayer];
    
#if USE_DEBUG
        _baseCirclePathLayer.opacity = 0.6;
    
    if (_centerPointPathLayer) {
        [_centerPointPathLayer removeFromSuperlayer];
    }
    _centerPointPathLayer = [CALayer layer];
    _centerPointPathLayer.frame = CGRectMake(0, 0, 3, 3);
    _centerPointPathLayer.position = _selfBoundsCircleCenter;
    _centerPointPathLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:_centerPointPathLayer];
#endif
}

- (void)reloadBaseCircle
{
    if (!_baseCirclePathLayer) {
        return;
    }
    
    CGRect frame = CGRectMake(_selfBoundsX, _selfBoundsY, _selfFrameSquareWidth, _selfFrameSquareWidth);
    //create a path: 矩形内切圆
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    //draw the path using a CAShapeLayer
    _baseCirclePathLayer.path = bezierPath.CGPath;
    
#if USE_DEBUG
    _centerPointPathLayer.position = _selfBoundsCircleCenter;
#endif
}

- (void)setCircleFillColor:(UIColor *)circleFillColor
{
    _baseCirclePathLayer.fillColor = circleFillColor.CGColor;
    _baseCirclePathLayer.strokeColor = circleFillColor.CGColor;
    _bazierFillColor = circleFillColor;
}

#pragma mark - Bezier Curve Common Methods
- (void)setAnimationStyle:(KMJellyViewAnimationStyle)animationStyle
{
    _animationStyle = animationStyle;
}

- (void)drawBazierCurveWithControlPoint:(CGPoint)point
{
    switch (_animationStyle) {
        case KMJellyViewAnimationStyle_peak: {
            
            [self drawBazierCurveInStylePeakWithControlPoint:point];
            break;
        }
        case KMJellyViewAnimationStyle_stretch: {
            
            [self drawBazierCurveInStyleStretchWithControlPoint:point];
            break;
        }
            
        default:
            break;
    }
}

- (void)restoreBezierCurveWithTouchEndPoint:(CGPoint)point
{
    switch (_animationStyle) {
        case KMJellyViewAnimationStyle_peak: {
            
            [self restoreBezierCurveInStylePeakWithTouchEndPoint:point];
            break;
        }
        case KMJellyViewAnimationStyle_stretch: {
            
            [self restoreBezierCurveInStyleStretchWithTouchEndPoint:point];
            break;
        }
            
        default:
            break;
    }
}

- (void)removeBezierCurve
{
    if (_bazierCurvePathLayer) {
        [_bazierCurvePathLayer removeFromSuperlayer];
    }
}

- (BOOL)checkFlexibilityWithTouchPoint:(CGPoint)point
{
    CGFloat xDiff = _selfBoundsCircleCenter.x - point.x;
    CGFloat yDiff = _selfBoundsCircleCenter.y - point.y;
    double distance = sqrt(xDiff*xDiff + yDiff*yDiff);
    
    if (distance >= kFlexibilityThreshold) {
        _isToBlowOut = YES;
        return YES;
    }
    
    else {
        _isToBlowOut = NO;
        return NO;
    }
}

#pragma mark Style: KMJellyViewAnimationStyle_peak
- (void)initBazierCurveInStylePeakWithControlPoint:(CGPoint)point
{
    //切线，斜率，垂直，夹角，极坐标
    double gradient_PO = (point.y - _selfBoundsCircleCenter.y)/(point.x - _selfBoundsCircleCenter.x);
    if (isnan(gradient_PO)) {//斜率无限大咱就不算了
        return;
    }
    double angle_alpha = atan(gradient_PO) + M_PI_2;
    NSLog(@"angle_alpha: %fpi", angle_alpha/(M_PI));
    
    _bazierBeginPoint = CGPointMake(_selfBoundsCircleCenter.x+_baseCircleRadius*cos(angle_alpha), _selfBoundsCircleCenter.y+_baseCircleRadius*sin(angle_alpha));
    _bazierEndPoint = CGPointMake(_selfBoundsCircleCenter.x+_baseCircleRadius*cos(angle_alpha+M_PI), _selfBoundsCircleCenter.y+_baseCircleRadius*sin(angle_alpha+M_PI));
    
    
    
    _bazierControlPoint1 = CGPointMake(point.x, point.y);
    _bazierControlPoint2 = CGPointMake(point.x, point.y);
    NSLog(@"bezier curve: (%f,%f)->(%f,%f)", _bazierBeginPoint.x, _bazierBeginPoint.y, _bazierEndPoint.x, _bazierEndPoint.y);
}

- (void)drawBazierCurveInStylePeakWithControlPoint:(CGPoint)point
{
    [self removeBezierCurve];
    
    [self initBazierCurveInStylePeakWithControlPoint:point];
    
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:_bazierBeginPoint];
    [bezierPath addCurveToPoint:_bazierEndPoint controlPoint1:_bazierControlPoint1 controlPoint2:_bazierControlPoint2];
    
    //draw the path using a CAShapeLayer
    _bazierCurvePathLayer = [CAShapeLayer layer];
    _bazierCurvePathLayer.path = bezierPath.CGPath;
    UIColor *fillColor = (_bazierFillColor)? _bazierFillColor:[UIColor redColor];
    _bazierCurvePathLayer.fillColor = fillColor.CGColor;
    
#if USE_DEBUG
    _bazierCurvePathLayer.fillColor = [UIColor orangeColor].CGColor;
#endif
    
    _bazierCurvePathLayer.strokeColor = fillColor.CGColor;
    _bazierCurvePathLayer.lineWidth = 1.0f;
    [self.layer addSublayer:_bazierCurvePathLayer];
}

- (void)restoreBezierCurveInStylePeakWithTouchEndPoint:(CGPoint)point
{
    _touchEndPoint = point;
    _xDiff = _selfBoundsCircleCenter.x - _touchEndPoint.x;
    _yDiff = _selfBoundsCircleCenter.y - _touchEndPoint.y;

    _restoreDL = [CADisplayLink displayLinkWithTarget:self selector:@selector(eachFrameInStylePeak)];
    [_restoreDL addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
}

- (void)eachFrameInStylePeak
{
    static float count = 0;
    float rate = count/(60*kDuration_restoreBezierCurve);
    if (rate <= 1.0) {
        CGFloat xOffset = _xDiff*rate;
        CGFloat yOffset = _yDiff*rate;
        CGPoint newControlPoint = CGPointMake(_touchEndPoint.x+xOffset, _touchEndPoint.y+yOffset);
//        NSLog(@"newControlPoint(%f,%f), count:%f", newControlPoint.x, newControlPoint.y,count);
        [self drawBazierCurveInStylePeakWithControlPoint:newControlPoint];
        count++;
    }
    else {
        [self removeBezierCurve];
        [_restoreDL invalidate];
        count = 0;
    }
}

#pragma mark Style: KMJellyViewAnimationStyle_stretch
- (void)initBazierCurveInStyleStretchWithControlPoint:(CGPoint)point
{
    //切线，斜率，垂直，夹角，极坐标
    double gradient_PO = (point.y - _selfBoundsCircleCenter.y)/(point.x - _selfBoundsCircleCenter.x);
    if (isnan(gradient_PO)) {//斜率无限大咱就不算了
        return;
    }
    double angle_alpha = atan(gradient_PO) + M_PI_2;
//    NSLog(@"angle_alpha: %fpi", angle_alpha/(M_PI));
    
    CGFloat xDiff = point.x - _selfBoundsCircleCenter.x;
    CGFloat yDiff = point.y - _selfBoundsCircleCenter.y;
    
    _bazierBeginPoint1_style2 = CGPointMake(_selfBoundsCircleCenter.x+_baseCircleRadius*cos(angle_alpha),
                                            _selfBoundsCircleCenter.y+_baseCircleRadius*sin(angle_alpha));
    _bazierEndPoint2_style2 = CGPointMake(_selfBoundsCircleCenter.x+_baseCircleRadius*cos(angle_alpha+M_PI),
                                          _selfBoundsCircleCenter.y+_baseCircleRadius*sin(angle_alpha+M_PI));
    
    _bazierBeginPoint2_style2 = CGPointMake(_bazierEndPoint2_style2.x+xDiff, _bazierEndPoint2_style2.y+yDiff);
    _bazierEndPoint1_style2 = CGPointMake(_bazierBeginPoint1_style2.x+xDiff, _bazierBeginPoint1_style2.y+yDiff);
    
    
    
    //动态设置控制点，根据：手指一动距离PO/爆裂阈值=控制点长度/圆半径
    double distance_PO = sqrt(xDiff*xDiff + yDiff*yDiff);
    double rate = distance_PO/kFlexibilityThreshold;
    
    CGPoint middlePoint1 = [KMMathHelper getMiddleFromPoint1:_bazierBeginPoint1_style2 point2:_bazierEndPoint1_style2];
    CGPoint middlePoint2 = [KMMathHelper getMiddleFromPoint1:_bazierBeginPoint2_style2 point2:_bazierEndPoint2_style2];
    CGPoint middlePoint_PO = [KMMathHelper getMiddleFromPoint1:point point2:_selfBoundsCircleCenter];
    
    _bazierControlPoint1_style2 = [KMMathHelper getNewPointFromStartPoint:middlePoint1 endPoint:middlePoint_PO rate:rate];
    _bazierControlPoint2_style2 = [KMMathHelper getNewPointFromStartPoint:middlePoint2 endPoint:middlePoint_PO rate:rate];;
    
#if USE_DEBUG
    if (_testLayer1) {
        [_testLayer1 removeFromSuperlayer];
    }
    _testLayer1 = [CALayer layer];
    _testLayer1.frame = CGRectMake(0, 0, 3, 3);
    _testLayer1.position = middlePoint1;
    _testLayer1.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:_testLayer1];
    
    if (_testLayer2) {
        [_testLayer2 removeFromSuperlayer];
    }
    _testLayer2 = [CALayer layer];
    _testLayer2.frame = CGRectMake(0, 0, 5, 5);
    _testLayer2.position = _bazierControlPoint1_style2;
    _testLayer2.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:_testLayer2];
    
    if (_testLayer3) {
        [_testLayer3 removeFromSuperlayer];
    }
    _testLayer3 = [CALayer layer];
    _testLayer3.frame = CGRectMake(0, 0, 3, 3);
    _testLayer3.position = middlePoint2;
    _testLayer3.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:_testLayer3];
    
    if (_testLayer4) {
        [_testLayer4 removeFromSuperlayer];
    }
    _testLayer4 = [CALayer layer];
    _testLayer4.frame = CGRectMake(0, 0, 5, 5);
    _testLayer4.position = _bazierControlPoint2_style2;
    _testLayer4.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:_testLayer4];
#endif

    
//    _bazierControlPoint1_style2 = CGPointMake((point.x+_selfBoundsCircleCenter.x)/2,
//                                              (point.y+_selfBoundsCircleCenter.y)/2);
//    _bazierControlPoint2_style2 = CGPointMake((point.x+_selfBoundsCircleCenter.x)/2,
//                                              (point.y+_selfBoundsCircleCenter.y)/2);
}

- (void)drawBazierCurveInStyleStretchWithControlPoint:(CGPoint)point
{
    [self removeBezierCurve];
    [self initBazierCurveInStyleStretchWithControlPoint:point];
    
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:_bazierBeginPoint1_style2];
    
    [bezierPath addCurveToPoint:_bazierEndPoint1_style2
                controlPoint1:_bazierControlPoint1_style2 controlPoint2:_bazierControlPoint1_style2];
    
    [bezierPath addQuadCurveToPoint:_bazierBeginPoint2_style2 controlPoint:_bazierBeginPoint2_style2];
    
    [bezierPath addCurveToPoint:_bazierEndPoint2_style2
                controlPoint1:_bazierControlPoint2_style2 controlPoint2:_bazierControlPoint2_style2];
    
    [bezierPath addQuadCurveToPoint:_bazierBeginPoint1_style2 controlPoint:_bazierBeginPoint1_style2];
    
    //draw the path using a CAShapeLayer
    _bazierCurvePathLayer = [CAShapeLayer layer];
    _bazierCurvePathLayer.path = bezierPath.CGPath;
    UIColor *fillColor = (_bazierFillColor)? _bazierFillColor:[UIColor redColor];
    _bazierCurvePathLayer.fillColor = fillColor.CGColor;
    
#if USE_DEBUG
    _bazierCurvePathLayer.fillColor = [UIColor clearColor].CGColor;
#endif
    
    _bazierCurvePathLayer.strokeColor = fillColor.CGColor;
    _bazierCurvePathLayer.lineWidth = 1.0f;
    [self.layer addSublayer:_bazierCurvePathLayer];
    
    
    
    
    //new circle
    //每次重绘前都清除之前的圆
    if (_newCirclePathLayer) {
        [_newCirclePathLayer removeFromSuperlayer];
    }
    
    CGRect frame = CGRectMake(point.x-_selfFrameSquareWidth/2,
                              point.y-_selfFrameSquareWidth/2,
                              _selfFrameSquareWidth,
                              _selfFrameSquareWidth);
    //create a path: 矩形内切圆
    UIBezierPath *newBezierPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    //draw the path using a CAShapeLayer
    _newCirclePathLayer = [CAShapeLayer layer];
    _newCirclePathLayer.path = newBezierPath.CGPath;
    _newCirclePathLayer.fillColor = fillColor.CGColor;
    _newCirclePathLayer.strokeColor = fillColor.CGColor;
    _newCirclePathLayer.lineWidth = 1.0f;
    [self.layer addSublayer:_newCirclePathLayer];

}

- (void)restoreBezierCurveInStyleStretchWithTouchEndPoint:(CGPoint)point
{
    [self removeBezierCurve];
    
    if (_newCirclePathLayer) {
        [_newCirclePathLayer removeFromSuperlayer];
    }
}

- (void)eachFrameInStyleStretch
{
    
}

#pragma mark - Touch Events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"begin point: (%f,%f)", point.x, point.y);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"moved point: (%f,%f)", point.x, point.y);
    
    BOOL check = [self checkFlexibilityWithTouchPoint:point];
    if (check == YES) {
        if ([self.delegate respondsToSelector:@selector(jellyViewWillBlowOutAt:)]) {
            
            CGPoint outsideTouchPoint = CGPointMake(_selfFrameX+point.x, _selfFrameY+point.y);
            [self.delegate jellyViewWillBlowOutAt:outsideTouchPoint];
        }
        
        [self removeBezierCurve];
        
        return;
    }

    [self drawBazierCurveWithControlPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
//    NSLog(@"ended point: (%f,%f)", point.x, point.y);
    
    BOOL check = [self checkFlexibilityWithTouchPoint:point];
    if (check == YES) {
        return;
    }
    
    [self restoreBezierCurveWithTouchEndPoint:point];
}

@end
