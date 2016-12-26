//
//  ViewController.m
//  UIAlertViewMagic
//
//  Created by 周祺华 on 2016/12/26.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertView+ActionBlock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Title" message:@"Message" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert setupActionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSLog(@"You did click button index %ld", (long)buttonIndex);
    }];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
