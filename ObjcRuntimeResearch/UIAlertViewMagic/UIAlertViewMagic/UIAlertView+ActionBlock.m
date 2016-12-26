//
//  UIAlertView+ActionBlock.m
//  UIAlertViewMagic
//
//  Created by 周祺华 on 2016/12/26.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "UIAlertView+ActionBlock.h"
#import <objc/runtime.h>

static const void *KMAlertViewKey = "KMAlertViewKey";

@implementation UIAlertView (ActionBlock)

- (void)setupActionBlock:(ActionBlock)action
{
    objc_setAssociatedObject(self, KMAlertViewKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.delegate = self;
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ActionBlock action = objc_getAssociatedObject(self, KMAlertViewKey);
    action(alertView, buttonIndex);
}

@end
