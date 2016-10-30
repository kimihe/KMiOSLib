//
//  KMNineBoxView.h
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KMNineBoxState) {
    KMNineBoxStateNormal  = 0,
    KMNineBoxStateTouched = 1<<0,
    KMNineBoxStatePassed  = 1<<1,
    KMNineBoxStateFailed  = 1<<2
};

@protocol KMNineBoxViewDelegate <NSObject>

@optional
/**
 *  在手势密码绘制完成后，此接口会返回验证信息
 *
 *  @param state        手势密码的验证结果
 *  @param passSequence 用户绘制的手势密码的序列
 */
- (void)nineBoxDidFinishWithState:(KMNineBoxState)state passSequence:(NSString *)passSequence;

@end

@interface KMNineBoxView : UIView

@property (weak, nonatomic  ) id <KMNineBoxViewDelegate> delegate;

/**
 *  预先设置好正确的密码序列，之后会与用户绘制的手势密码进行比较
 */
@property (strong, nonatomic) NSString *predefinedPassSeq;

- (instancetype)initWithFrame:(CGRect)frame;
@end
