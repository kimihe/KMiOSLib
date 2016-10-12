//
//  ViewController.m
//  KMProgressViewDemo
//
//  Created by 周祺华 on 2016/10/12.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "ViewController.h"
#import "KMProgressView.h"

@interface ViewController ()
{
    KMProgressView *_progressView;
    NSTimer *_timer;
    NSInteger _count;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickProgressCompletedBtn:(UIButton *)sender {
    _progressView = [[KMProgressView alloc] initWithCoverColor:colorFromRGBA(0xFFFFFF, 0.6)];
    [_progressView setState:KMProgressView_Begin withProgress:0];
    [_progressView showAt:self.view];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(repeatA) userInfo:nil repeats:YES];
    _count = 0;
}

- (void)repeatA
{
    _count++;
    if (_count >=100) {
        [_timer invalidate];
        
        [_progressView setState:KMProgressView_Completed withProgress:1.0];
        [_progressView remove];
        _progressView = nil;
    }
    else {
        [_progressView setState:KMProgressView_Uploading withProgress:(float)_count/100.0];
    }
}

- (IBAction)clickProgressFailedBtn:(UIButton *)sender {
    _progressView = [[KMProgressView alloc] initWithCoverColor:colorFromRGBA(0xFFFFFF, 0.6)];
    [_progressView setState:KMProgressView_Begin withProgress:0];
    [_progressView showAt:self.view];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(repeatB) userInfo:nil repeats:YES];
    _count = 0;
}

- (void)repeatB
{
    _count++;
    if (_count >= 31) {
        [_timer invalidate];
        
        //simulate more vivo
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            [_progressView setState:KMProgressView_Failed withProgress:-1.0];
            [_progressView remove];
            _progressView = nil;
        });
    }
    else {
        [_progressView setState:KMProgressView_Uploading withProgress:(float)_count/100.0];
    }
}

@end
