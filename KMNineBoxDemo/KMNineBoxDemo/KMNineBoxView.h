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
- (void)nineBoxDidFinishWithState:(KMNineBoxState)state passSequence:(NSString *)passSequence;

@end

@interface KMNineBoxView : UIView

@property (weak, nonatomic  ) id <KMNineBoxViewDelegate> delegate;
//@property (strong, nonatomic) UIColor               *circleStrokeColor;
//@property (assign, nonatomic) KMNineBoxState        nineBoxState;
@property (strong, nonatomic) NSString *predefinedPassSeq;

- (instancetype)initWithFrame:(CGRect)frame;
@end
