//
//  ViewController.m
//  DynamicTest
//
//  Created by 周祺华 on 2016/12/22.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "ViewController.h"
#import "KMDictionary.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    KMDictionary *dic = [KMDictionary new];
    dic.string = @"Hello Dynamic";
    dic.number = @233;
    dic.dic = @{
                @"A" : @"Apple",
                @"B" : @"Bird",
                @"C" : @"Cat",
                @"D" : @"Dog"
                };
//    dic.integer = 233;
    
    [dic performSelector:@selector(showAllProperties)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
