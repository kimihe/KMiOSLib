//
//  ViewController.m
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#define kPassSeq  @"123654789"

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
            self.passSeqLabel.text = [NSString stringWithFormat:@"Seq: %@", passSequence];
            break;
        }
            
        case KMNineBoxStateFailed: {
            self.titlelabel.text = @"Incorrect!";
            self.titlelabel.textColor = [UIColor redColor];
            self.passSeqLabel.text = [NSString stringWithFormat:@"Seq: %@", passSequence];
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
    
    self.nineBoxView = [[KMNineBoxView alloc] initWithFrame:CGRectMake(0, 200, 200, 200)];
    self.nineBoxView.delegate = self;
    self.nineBoxView.predefinedPassSeq = kPassSeq;

    [self.view addSubview:self.nineBoxView];
    
    self.nineBoxView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH);
    self.nineBoxView.center = self.view.center;
}

@end
