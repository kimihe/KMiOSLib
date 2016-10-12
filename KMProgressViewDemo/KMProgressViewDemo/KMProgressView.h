//
//  KMProgressView.h
//  KMProgressViewDemo
//
//  Created by 周祺华 on 2016/10/12.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMUIKitMacro.h"

@interface KMProgressView : UIView

typedef NS_ENUM(NSInteger, KMProgressViewState)
{
    KMProgressView_Begin,
    KMProgressView_Uploading,
    KMProgressView_Completed,
    KMProgressView_Failed
};

/**
 *  普通init，无背景遮罩
 *
 *  @return KMUploadProgressView
 */
- (instancetype)init;


/**
 *  init有背景遮罩
 *
 *  @param color 遮罩的颜色
 *
 *  @return KMUploadProgressView
 */
- (instancetype)initWithCoverColor:(UIColor *)color;

/**
 *  显示进度弹窗
 *
 *  @param view 将会在这个view上弹出
 */
- (void)showAt:(UIView *)view;

/**
 *  设置进度弹窗的状态标题和进度数值
 *
 *  @param state    枚举状态显示预置标题
 *  @param progress 进度数值：0上传开始；0-1.0上传中；>1.0上传完成；<1.0上传失败。只有在枚举状态为KMUploadProgress_Uploading时，才需要传progress，否则传了也不会生效
 */
- (void)setState:(KMProgressViewState)state withProgress:(float)progress;

/**
 *  移除进度弹窗
 */
- (void)remove;

@end
