//
//  ViewController.m
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#define kPassSeq  @"123698745"

#import "ViewController.h"
#import "KMNineBoxView.h"
#import "KMUIKitMacro.h"

@interface ViewController ()<KMNineBoxViewDelegate>
@property (strong, nonatomic)KMNineBoxView *nineBoxView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *passSeqLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self pressReloadBtn:nil];
//    CAShapeLayer *line = [CAShapeLayer layer];
//    UIBezierPath *linePath = [UIBezierPath bezierPath];
//    [linePath moveToPoint: CGPointMake(10, 400)];
//    [linePath addLineToPoint: CGPointMake(200, 400)];
//    line.path = linePath.CGPath;
//    line.fillColor = [UIColor blueColor].CGColor;
//    line.strokeColor = [UIColor blueColor].CGColor;;
//    line.lineWidth = 2.0f;
//    
//    [self.view.layer addSublayer:line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nineBoxDidFinishWithState:(KMNineBoxState)state passSequence:(NSString *)passSequence;
{
    switch (state) {
        case KMNineBoxStatePassed: {
            self.titlelabel.text = @"Passed!";
            self.titlelabel.textColor = [UIColor greenColor];
            self.passSeqLabel.text = [NSString stringWithFormat:@"Steps: %@", passSequence];
            break;
        }
            
        case KMNineBoxStateFailed: {
            self.titlelabel.text = @"Incorrect!";
            self.titlelabel.textColor = [UIColor redColor];
            self.passSeqLabel.text = [NSString stringWithFormat:@"Steps: %@", passSequence];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)pressReloadBtn:(UIButton *)sender {
    
    if (self.nineBoxView) {
        [self.nineBoxView removeFromSuperview];
        self.nineBoxView = nil;
    }
    
    self.nineBoxView = [[KMNineBoxView alloc] initWithFrame:CGRectMake(0, 200, kSCREEN_WIDTH, kSCREEN_WIDTH)];
    self.nineBoxView.delegate = self;
    self.nineBoxView.predefinedPassSeq = kPassSeq;

    [self.view addSubview:self.nineBoxView];
    
    self.nineBoxView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH);
    self.nineBoxView.center = self.view.center;
}

@end
