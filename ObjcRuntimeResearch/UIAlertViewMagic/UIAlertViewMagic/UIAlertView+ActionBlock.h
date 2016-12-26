//
//  UIAlertView+ActionBlock.h
//  UIAlertViewMagic
//
//  Created by 周祺华 on 2016/12/26.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(UIAlertView*, NSInteger);

@interface UIAlertView (ActionBlock) <UIAlertViewDelegate>

/*
1. iOS9.0后，你应该使用UIAlertController，弃用UIAlerView！
2. 此Demo主要演示如何使用runtime的objc_associatedObject，模拟部分UIAlertController的功能，使用了category来增加一个方法，但在实际开发中，还是建议通过继承使用子类来实现。毕竟category中增加实例变量属于一种trick技巧。
3. 我们需要一个内部block来存储外部传进来的action，但是category无法在一般意义上增加实例变量， 因此可以使用runtime魔法实现。
4. 我们依旧遵照“勿在分类中声明属性”这一原则，不声明void (^block)(UIAlertView*, NSInteger)的@property，直接提供一个setup方法。
*/

/**
 设置一个ActionBlock

 @param action 需要传入的block
 */
- (void)setupActionBlock:(ActionBlock)action;

@end
