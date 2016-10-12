//
//  ViewController.m
//  BezierCurve_Test
//
//  Created by nali on 16/8/11.
//  Copyright © 2016年 Kimi. All rights reserved.
//

#import "ViewController.h"
#import "KMJellyView.h"
#import "KMTestView.h"
#import "KMMathHelper.h"

@interface ViewController () <KMJellyViewDelegate>
@property (strong, nonatomic)KMJellyView *jellyView1;
@property (strong, nonatomic)KMJellyView *jellyView2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self test];
//    [self test2];
    
//    double k = [KMMathHelper getGradientFromPoint1:CGPointMake(20, 10) point2:CGPointMake(20, 20)];
//    if (isnan(k)) {
//        NSLog(@"k is nan");
//    }
//    NSLog(@"k: %f", k);
}

- (IBAction)clickReloadBtn:(UIButton *)sender
{
    if (self.jellyView1) {
        [self.jellyView1 removeFromSuperview];
    }
    
    self.jellyView1 = [[KMJellyView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.jellyView1.delegate = self;
    self.jellyView1.animationStyle = KMJellyViewAnimationStyle_stretch;
    [self.view addSubview:self.jellyView1];
    
    self.jellyView1.center = self.view.center;
    
    
    if (self.jellyView2) {
        [self.jellyView2 removeFromSuperview];
    }
    
    self.jellyView2 = [[KMJellyView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    self.jellyView2.circleFillColor = [UIColor greenColor];
    self.jellyView2.animationStyle = KMJellyViewAnimationStyle_peak;
    [self.view addSubview:self.jellyView2];
    
    
//    self.jellyView.frame = CGRectMake(100, 20, 50, 100);
//    self.jellyView.center = self.view.center;
//    self.jellyView.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jellyViewWillBlowOutAt:(CGPoint)point
{
    NSLog(@"要爆了");
    [self.jellyView1 removeFromSuperview];
    self.jellyView1.delegate = nil;
    
    self.jellyView1 = [[KMJellyView alloc] initWithFrame:CGRectMake(0 , 0, 40, 40)];
    self.jellyView1.center = point;
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.jellyView1.circleFillColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.jellyView1.delegate = self;
    self.jellyView1.animationStyle = KMJellyViewAnimationStyle_stretch;
    [self.view addSubview:self.jellyView1];
}

- (void)test
{
    KMTestView *view = [[KMTestView alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
    [self.view addSubview:view];
}

- (void)test2
{
    CGPoint _bazierBeginPoint1 = CGPointMake(10, 10);
    CGPoint _bazierEndPoint1 = CGPointMake(200, 10);
    CGPoint _bazierControlPoint1 = CGPointMake(105, 30);
    CGPoint _bazierControlPoint2 = CGPointMake(105, 30);
    CGPoint _bazierEndPoint2 = CGPointMake(10, 50);
    
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:_bazierBeginPoint1];
    [bezierPath addCurveToPoint:_bazierEndPoint1 controlPoint1:_bazierControlPoint1 controlPoint2:_bazierControlPoint2];
    [bezierPath addQuadCurveToPoint:CGPointMake(200, 50) controlPoint:CGPointMake(200, 50)];
    [bezierPath addCurveToPoint:_bazierEndPoint2 controlPoint1:_bazierControlPoint1 controlPoint2:_bazierControlPoint2];
    [bezierPath addQuadCurveToPoint:CGPointMake(10, 10) controlPoint:CGPointMake(10, 10)];
    
    //draw the path using a CAShapeLayer
    CAShapeLayer *_bazierCurvePathLayer = [CAShapeLayer layer];
    _bazierCurvePathLayer.path = bezierPath.CGPath;
    UIColor *fillColor = [UIColor redColor];
    _bazierCurvePathLayer.fillColor = fillColor.CGColor;
    
#if USE_DEBUG
    _bazierCurvePathLayer.fillColor = [UIColor orangeColor].CGColor;
#endif
    
    _bazierCurvePathLayer.strokeColor = fillColor.CGColor;
    _bazierCurvePathLayer.lineWidth = 1.0f;
    [self.view.layer addSublayer:_bazierCurvePathLayer];

}

@end
