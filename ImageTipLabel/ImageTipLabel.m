//
//  ImageTipLabel.m
//  ImageTipLabel
//
//  Created by 周国勇 on 15/2/5.
//  Copyright (c) 2015年 Huaban. All rights reserved.
//

#import "ImageTipLabel.h"

@interface ImageTipLabel()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;// 包含除了pointImageView的所有view
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tipTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;
@property (nonatomic) ImageTipLabelDirection direction;// 标签方向，默认ImageTipLabelDirectionRight
@property (nonatomic, getter=isEditModel) BOOL editModel;// 是否为编辑模式，在编辑模式的时候可以移动和删除自身，默认NO

@property (nonatomic) CGPoint touchesBeginPoint;
@property (nonatomic) CGRect originFrame;
@end

static UIImage *backgroundImage = nil;

@implementation ImageTipLabel

#pragma mark - Public Mehod
+ (instancetype)TipLabelWithText:(NSString *)text tipImage:(UIImage *)image editModel:(BOOL)editModel
{
    return [[self class] TipLabelWithText:text tipImage:image direction:ImageTipLabelDirectionRight editModel:editModel];
}

+ (instancetype)TipLabelWithText:(NSString *)text tipImage:(UIImage *)image direction:(ImageTipLabelDirection)direction editModel:(BOOL)editModel
{
    return [[self class] TipLabelWithText:text tipImage:image backgroundImage:backgroundImage direction:direction editModel:editModel];
}

+ (instancetype)TipLabelWithText:(NSString *)text tipImage:(UIImage *)tipImage backgroundImage:(UIImage *)bgImage direction:(ImageTipLabelDirection)direction editModel:(BOOL)editModel
{
    ImageTipLabel *tipLabel = [[NSBundle mainBundle] loadNibNamed:@"ImageTipLabel" owner:self options:nil].lastObject;
    [tipLabel renderViewWithText:text tipImageName:tipImage backgroundImage:tipImage direction:direction editModel:editModel];
    return tipLabel;
}

+ (void)configTipLabelWithBackgroundImage:(UIImage *)bgImage
{
    backgroundImage = bgImage;
}

- (void)addTipLabelToView:(UIView *)view tipX:(float)X tipY:(float)Y
{
    // 2. 根据X,Y计算出tipView的真实x,y
    CGRect pointBounds = self.pointImageView.frame;
    // 2.1 X*width - originX - 0.5*sizeW
    CGFloat realX = X*view.bounds.size.width - pointBounds.origin.x - 0.5*pointBounds.size.width;
    CGFloat realY = Y*view.bounds.size.height - pointBounds.origin.y - 0.5*pointBounds.size.height;
    // TODO:2.2 规避使整体view超出superview边界的X,Y
    
    // 3. 将计算好fame的tipView添加到view上
    CGRect frame = self.frame;
    frame.origin.x = realX;
    frame.origin.y = realY;
    self.frame = frame;
    [view addSubview:self];
}

#pragma mark - Properties
- (void)setDirection:(ImageTipLabelDirection)direction
{
    if (_direction == direction) {
        return;
    }
    _direction = direction;
    // 1.1 contentView整体停靠方向变化
    CGRect frame = self.contentView.frame;
    frame.origin.x = self.frame.size.width - frame.origin.x - frame.size.width;
    self.contentView.frame = frame;
    // 1.2 label整体停靠方向变化
    frame = self.tipLabel.frame;
    frame.origin.x = self.contentView.frame.size.width - frame.origin.x - frame.size.width;
    self.tipLabel.frame = frame;
    // 1.3 图标整体停靠方向变化
    frame = self.tipTypeImageView.frame;
    frame.origin.x = self.contentView.frame.size.width - frame.origin.x - frame.size.width;
    self.tipTypeImageView.frame = frame;
    // 1.4 白色的点整体停靠方向变化
    frame = self.pointImageView.frame;
    frame.origin.x = self.frame.size.width - frame.origin.x - frame.size.width;
    self.pointImageView.frame = frame;
    // 1.5 背景图翻转
    self.backgroundImageView.transform = CGAffineTransformMakeScale(-1, 1);
}

- (float)tipX
{
    CGRect pointBounds = self.pointImageView.frame;
    float X = (self.frame.origin.x + pointBounds.origin.x + 0.5*pointBounds.size.width)/self.superview.frame.size.width;
    return X;
}

- (float)tipY
{
    CGRect pointBounds = self.pointImageView.frame;
    float Y = (self.frame.origin.y + pointBounds.origin.y + 0.5*pointBounds.size.height)/self.superview.frame.size.height;
    return Y;
}

#pragma mark - Private Method
- (void)renderViewWithText:(NSString *)text tipImageName:(UIImage *)tipImage backgroundImage:(UIImage *)bgImage direction:(ImageTipLabelDirection)direction editModel:(BOOL)editModel;
{
    // 1. 设置默认的背景
    if (bgImage) {
        bgImage = [UIImage imageNamed:@"tip_text_bg"];
    }
    // 2. 更新文字以及图片
    self.tipLabel.text = text;
    self.backgroundImageView.image = bgImage;
    self.tipTypeImageView.image = tipImage;
    // 3. 背景适配label宽度
    [self.tipLabel sizeToFit];
    CGRect frame = self.backgroundImageView.frame;
    frame.size.width = self.tipLabel.frame.origin.x + self.tipLabel.frame.size.width - self.backgroundImageView.frame.origin.x + 8;
    self.backgroundImageView.frame = frame;
    // 4. contentView的宽度适配
    frame = self.contentView.frame;
    frame.size.width = self.backgroundImageView.frame.origin.x + self.backgroundImageView.frame.size.width;
    self.contentView.frame = frame;
    // 5. 整个view适配label宽度
    frame = self.frame;
    frame.size.width = self.contentView.frame.origin.x + self.contentView.frame.size.width;
    self.frame = frame;
    // 6. 其他属性设置
    self.direction = direction;
    self.editModel = editModel;
    // 7. 如果是编辑模式那就添加手势
    if (editModel) {
        // 7.1. 长按删除手势
        UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressGestureTriggered:)];
        [self.contentView addGestureRecognizer:longpressGesture];
        // 7.2. 点击变换方向手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTriggered:)];
        [self.contentView addGestureRecognizer:tapGesture];
    }

}

#pragma mark - Action
- (void)longpressGestureTriggered:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您要删除当前标签吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)tapGestureTriggered:(UITapGestureRecognizer *)gesture
{
    self.direction = self.direction == ImageTipLabelDirectionRight?ImageTipLabelDirectionLeft:ImageTipLabelDirectionRight;
}

#pragma mark - Life Cycle
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _direction = ImageTipLabelDirectionRight;
    }
    return self;
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self removeFromSuperview];
    }
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (!self.editModel) {
        return;
    }
    // 记录开始移动的位置
    UITouch *touch = [[event allTouches] anyObject];
    self.touchesBeginPoint = [touch locationInView:self.superview];
    self.originFrame = self.frame;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (!self.editModel) {
        return;
    }
    // 1.计算当前位置
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchMovedPoint = [touch locationInView:self.superview];
    // 2.计算差值
    CGFloat deltaX = touchMovedPoint.x - self.touchesBeginPoint.x;
    CGFloat deltaY = touchMovedPoint.y - self.touchesBeginPoint.y;
    // 3.重新制定frame
    CGRect frame = self.frame;
    // 3.1.限制超出边界的值
    frame.origin.x = self.originFrame.origin.x + deltaX;
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
    }
    if (frame.origin.x > self.superview.frame.size.width-self.frame.size.width) {
        frame.origin.x = self.superview.frame.size.width-self.frame.size.width;
    }
    frame.origin.y = self.originFrame.origin.y + deltaY;
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
    }
    if (frame.origin.y > self.superview.frame.size.height-self.frame.size.height) {
        frame.origin.y = self.superview.frame.size.height-self.frame.size.height;
    }

    self.frame = frame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
