//
//  ImageTipLabel.h
//  ImageTipLabel
//
//  Created by 周国勇 on 15/2/5.
//  Copyright (c) 2015年 Huaban. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageTipLabelDirection) {
    ImageTipLabelDirectionLeft,
    ImageTipLabelDirectionRight,
};

@interface ImageTipLabel : UIView

#pragma mark - Public Mehod
+ (instancetype)TipLabelWithText:(NSString *)text tipImage:(UIImage *)image editModel:(BOOL)editModel;

+ (instancetype)TipLabelWithText:(NSString *)text tipImage:(UIImage *)image direction:(ImageTipLabelDirection)direction editModel:(BOOL)editModel;

+ (instancetype)TipLabelWithText:(NSString *)text tipImage:(UIImage *)tipImage backgroundImage:(UIImage *)bgImage direction:(ImageTipLabelDirection)direction editModel:(BOOL)editModel;

+ (void)configTipLabelWithBackgroundImage:(UIImage *)bgImage;

- (void)addTipLabelToView:(UIView *)view tipX:(float)X tipY:(float)Y;

#pragma mark - Properties
// 这里的X,Y是标签左上角（或者右上角）的原点的中心的坐标，范围是0~1.0，左上角是原点;
@property (nonatomic, readonly) float tipX;
@property (nonatomic, readonly) float tipY;

@end
