//
//  KMProgressView.m
//  KMProgressViewDemo
//
//  Created by 周祺华 on 2016/10/12.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#define kboxImageView_width                            280.0
#define kboxImageView_height                           150.0

#define kboxTitleLabel_x        (kboxImageView_width - kboxTitleLabel_width)/2  //60
#define kboxTitleLabel_y                               40.0
#define kboxTitleLabel_width                           160.0
#define kboxTitleLabel_height                          20.0

#define kboxNumberlabel_x                              kboxProgressView_x       //20
#define kboxNumberlabel_y                              75.0
#define kboxNumberlabel_width                          36.0
#define kboxNumberlabel_height                         26.0

#define kboxProgressView_x      (kboxImageView_width - kboxProgressView_width)/2//20
#define kboxProgressView_y                             106.0
#define kboxProgressView_width                         240.0
#define kboxProgressView_height                        14.0

#import "KMProgressView.h"

@implementation KMProgressView
{
    UIView         *_boxCoverView;    //!< 进度弹窗的底色遮罩
    UIImageView    *_boxImageView;    //!< 进度弹窗的背景图
    UILabel        *_boxTitleLabel;   //!< 进度弹窗的标题
    UILabel        *_boxNumberlabel;  //!< 进度数值标题
    UIProgressView *_boxProgressView; //!< 进度弹窗的进度条
}

//此处没有重写initWithFrame方法，因为progressView类似于alert，其大小不需要人为再去设定
- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kboxImageView_width, kboxImageView_height)];
    if (self) {
        [self drawProgressViewWithFrame:CGRectMake(0, 0, kboxImageView_width, kboxImageView_height)];
    }
    return self;
}

- (instancetype)initWithCoverColor:(UIColor *)color
{
    self = [super initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    if (self) {
        [self drawCoverView];
        [self drawProgressViewWithFrame:CGRectMake(0, 0, kboxImageView_width, kboxImageView_height)];
    }
    return self;
}

- (void)drawCoverView
{
    //底色遮罩
    _boxCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _boxCoverView.backgroundColor = [UIColor blackColor];
    _boxCoverView.alpha = 0.8;
    [self insertSubview:_boxCoverView atIndex:0];
}

- (void)drawProgressViewWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor clearColor];
    
    //背景图
    _boxImageView = [[UIImageView alloc] initWithFrame:frame];
    _boxImageView.backgroundColor = colorFromRGBA(0xFFFFFF, 1.0);
    _boxImageView.image = [UIImage imageNamed:@"YourPicture"];
    _boxImageView.center = self.center;
    _boxImageView.layer.cornerRadius = 5.0;
    _boxImageView.layer.masksToBounds = YES;
    [self addSubview:_boxImageView];
    
    //标题
    _boxTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kboxTitleLabel_x, kboxTitleLabel_y, kboxTitleLabel_width, kboxTitleLabel_height)];
    _boxTitleLabel.textColor = colorFromRGBA(0x333333, 1.0);
    _boxTitleLabel.font = [UIFont systemFontOfSize:18.0];
    _boxTitleLabel.text = @"Your Title";
    _boxTitleLabel.textAlignment = NSTextAlignmentCenter;
    _boxTitleLabel.adjustsFontSizeToFitWidth = YES;
    [_boxImageView addSubview:_boxTitleLabel];
    
    //进度数值
    _boxNumberlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kboxNumberlabel_width, kboxNumberlabel_height)];
    _boxNumberlabel.textColor = [UIColor whiteColor];
    _boxNumberlabel.backgroundColor = colorFromRGBA(0xFC5832, 1.0);
    _boxNumberlabel.text = @"0%";
    _boxNumberlabel.textAlignment = NSTextAlignmentCenter;
    _boxNumberlabel.layer.cornerRadius = 4.0;
    _boxNumberlabel.layer.masksToBounds = YES;
    _boxNumberlabel.adjustsFontSizeToFitWidth = YES;
    _boxNumberlabel.layer.anchorPoint = CGPointMake(0.5, 0.0);
    _boxNumberlabel.layer.position = CGPointMake(kboxNumberlabel_x, kboxNumberlabel_y);
    [_boxImageView addSubview:_boxNumberlabel];
    
    //进度条
    _boxProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(kboxProgressView_x, kboxProgressView_y, kboxProgressView_width, kboxProgressView_height)];
    _boxProgressView.progressViewStyle = UIProgressViewStyleDefault;
    _boxProgressView.trackTintColor = colorFromRGBA(0xCFCFCF, 1.0);
    _boxProgressView.progressTintColor = colorFromRGBA(0xFC5832, 1.0);
    [_boxImageView addSubview:_boxProgressView];
}

- (void)setState:(KMProgressViewState)state withProgress:(float)progress
{
    switch (state)
    {
        case KMProgressView_Begin:
        {
            [self setTitle:@"Progress Start"];
            [self setProgress:0];
            break;
        }
        case KMProgressView_Uploading: {
            [self setTitle:@"Progressing..."];
            
            if (progress >= 0) {
                [self setProgress:progress];
            }
            
            break;
        }
        case KMProgressView_Completed: {
            [self setTitle:@"Progress Completed"];
            [self setProgress:1.0];
            break;
        }
        case KMProgressView_Failed: {
            [self setTitle:@"Progress Failed"];
            [self setProgress:-1.0];
            break;
        }
            
        default:
            break;
    }
}

- (void)setProgress:(float)progress
{
    if (progress < 0) {
        _boxNumberlabel.hidden = YES;
        [_boxProgressView setProgress:0 animated:NO];
    }
    else if (progress > 1.0) {
        _boxNumberlabel.text = @"100%";
        CGFloat offset = kboxProgressView_width * 1.0;
        _boxNumberlabel.layer.position = CGPointMake(kboxNumberlabel_x + offset, kboxNumberlabel_y);
        [_boxProgressView setProgress:progress animated:NO];
    }
    else {
        _boxNumberlabel.text = [NSString stringWithFormat:@"%ld%@", (NSInteger)(progress*100), @"%"];
        CGFloat offset = kboxProgressView_width * progress;
        _boxNumberlabel.layer.position = CGPointMake(kboxNumberlabel_x + offset, kboxNumberlabel_y);
        [_boxProgressView setProgress:progress animated:NO];
    }
}

- (void)setTitle:(NSString *)title
{
    _boxTitleLabel.text = title;
}

- (void)showAt:(UIView *)view
{
    self.center = view.window.center;
    self.alpha = 0;
    [view.window addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)remove
{
    //延迟1秒再消失
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
