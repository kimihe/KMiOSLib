//
//  ViewController.m
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#define kpasswd  @"123654789"

#import "ViewController.h"
#import "KMNineBoxView.h"
#import "KMUIKitMacro.h"

@interface ViewController ()<KMNineBoxViewDelegate>
@property (strong, nonatomic)KMNineBoxView *nineBoxView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    if (self.nineBoxView) {
        [self.nineBoxView removeFromSuperview];
    }
    
    self.nineBoxView = [[KMNineBoxView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH)];
    self.nineBoxView.delegate = self;
//    self.nineBoxView.animationStyle = KMJellyViewAnimationStyle_stretch;
    [self.view addSubview:self.nineBoxView];
    self.nineBoxView.center = self.view.center;
    self.nineBoxView.frame = CGRectMake(0, 0, 200, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nineBoxDidFinishWithSequence:(NSString *)sequenceStr
{
    NSLog(@"NineBox Sequrnce is: %@", sequenceStr);
    if ([sequenceStr isEqualToString:kpasswd]) {
        NSLog(@"PASS!!!");
        self.label.text = @"PASS!!!";
    }
    else {
        self.label.text = @"Password incorrect!";
    }
}

- (IBAction)pressReloadBtn:(UIButton *)sender {
    
    if (self.nineBoxView) {
        self.nineBoxView.layer.sublayers = nil;
        self.nineBoxView = nil;
    }
    
    self.nineBoxView = [[KMNineBoxView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH)];
    self.nineBoxView.delegate = self;
    //    self.nineBoxView.animationStyle = KMJellyViewAnimationStyle_stretch;
    [self.view addSubview:self.nineBoxView];
    self.nineBoxView.center = self.view.center;
}

@end
