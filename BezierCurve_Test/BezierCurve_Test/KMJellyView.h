//
//  KMJellyView.h
//  BezierCurve_Test
//
//  Created by nali on 16/8/11.
//  Copyright © 2016年 Kimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KMJellyViewAnimationStyle) {
    KMJellyViewAnimationStyle_peak = 1,
    KMJellyViewAnimationStyle_stretch
};

@protocol KMJellyViewDelegate <NSObject>
@optional
- (void)jellyViewWillBlowOutAt:(CGPoint)point;
@end

@interface KMJellyView : UIView

@property (weak,   nonatomic) id <KMJellyViewDelegate>  delegate;
@property (strong, nonatomic) UIColor                   *circleFillColor;
@property (assign, nonatomic) KMJellyViewAnimationStyle animationStyle;

- (instancetype)initWithFrame:(CGRect)frame;


@end
