//
//  ViewController.m
//  tmpChartView
//
//  Created by 周祺华 on 15/9/10.
//  Copyright (c) 2015年 周祺华. All rights reserved.
//

#import "ViewController.h"
#import "PNLineChartView.h"
#import "PNPlot.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PNLineChartView *lineChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Y轴温度值
    NSArray* plottingDataValues1 =@[@"-29.9", @"-10.5", @"0", @"30.1", @"40", @"50", @"60", @"70", @"80", @"90", @"100"];
    
    
    //Y轴范围:最大值,最小值,分成5段,好像只能分成5段
    self.lineChartView.max = 200;
    self.lineChartView.min = -50;
    
    self.lineChartView.interval = (self.lineChartView.max-self.lineChartView.min)/5;
    
    NSMutableArray* yAxisValues = [@[] mutableCopy];
    for (int i=0; i<6; i++) {
        NSString* str = [NSString stringWithFormat:@"%.1f", self.lineChartView.min+self.lineChartView.interval*i];
        [yAxisValues addObject:str];
    }
    
    //X轴日期
    self.lineChartView.xAxisValues = @[@"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10", @"11"];
    self.lineChartView.yAxisValues = yAxisValues;
    self.lineChartView.axisLeftLineWidth = 40;
    
    
    PNPlot *plot1 = [[PNPlot alloc] init];
    plot1.plottingValues = plottingDataValues1;
    
    plot1.lineColor = [UIColor greenColor];
    plot1.lineWidth = 0.5;
    
    [self.lineChartView addPlot:plot1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
