//
//  KMNineBoxView.h
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMNineBoxViewDelegate <NSObject>

@optional
- (void)nineBoxDidFinishWithSequence:(NSString *)sequenceStr;

@end

@interface KMNineBoxView : UIView

@property (weak, nonatomic) id <KMNineBoxViewDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame;
@end
