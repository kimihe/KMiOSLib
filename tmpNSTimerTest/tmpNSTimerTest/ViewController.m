//
//  ViewController.m
//  tmpNSTimerTest
//
//  Created by 周祺华 on 15/9/11.
//  Copyright (c) 2015年 周祺华. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int tempMeasuringTimerCount;
    BOOL timeIsUPOneSecond;
    BOOL pressTempMearsuringButtonTwiceQuickly;
}

@property (nonatomic, strong)NSTimer *tempMeasuringTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self->tempMeasuringTimerCount = 0;
    self->timeIsUPOneSecond = NO;
    self->pressTempMearsuringButtonTwiceQuickly = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tempMeasuring:(id)sender
{
    //连按两次后,再按一次
    if (self->pressTempMearsuringButtonTwiceQuickly == YES)
    {
        NSLog(@"再按了一次:停止连续测量");
        //发送停止测量,重新开始
        [self tempMeasuringTimerRefresh];
        return;
    }
    
    //第一次刚按
    if (self->tempMeasuringTimerCount == 0)
    {
        [self startTempMeasuringTimer];
    }
    
    if (timeIsUPOneSecond == YES)
    {
        NSLog(@"手势判断为间隔两次:单次测量");
        [self tempMeasuringTimerRefresh];
        [self startTempMeasuringTimer];
        //发送单次测量
    }
    else //timeIsUPOneSecond == NO
    {
        if (self->tempMeasuringTimerCount != 0)
        {
            NSLog(@"手势判断为连点两次:连续测量");
            [self.tempMeasuringTimer invalidate];
            //发送连续测量
            self->pressTempMearsuringButtonTwiceQuickly = YES;
        }
        
    }
    
}

#pragma mark ---测温按钮连点两次计时器相关方法---
- (void)startTempMeasuringTimer
{
    self.tempMeasuringTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tempMeasuringTimerClock) userInfo:nil repeats:YES];
}

- (void)tempMeasuringTimerClock
{
    self->tempMeasuringTimerCount ++;
    NSLog(@"%f秒", self->tempMeasuringTimerCount*0.05);
    
    if (self->tempMeasuringTimerCount < 20)
    {
        [self.tempMeasuringTimer invalidate];
        self->timeIsUPOneSecond = NO;
        [self startTempMeasuringTimer];
    }
    else
    {
        NSLog(@"到达1秒");
        [self.tempMeasuringTimer invalidate];
        self->timeIsUPOneSecond = YES;
        
    }
    
}

- (void)tempMeasuringTimerRefresh
{
    self->tempMeasuringTimerCount = 0;
    self->timeIsUPOneSecond = NO;
    self->pressTempMearsuringButtonTwiceQuickly = NO;
}







- (IBAction)refresh:(id)sender
{
    [self tempMeasuringTimerRefresh];
}
@end
