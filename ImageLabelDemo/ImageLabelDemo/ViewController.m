//
//  ViewController.m
//  ImageLabelDemo
//
//  Created by 周国勇 on 15/2/9.
//  Copyright (c) 2015年 Huaban. All rights reserved.
//

#import "ViewController.h"
#import "ImageTipLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // config the background for once
    [ImageTipLabel configTipLabelWithBackgroundImage:[UIImage imageNamed:@"tip_text_bg"]];
    
    // after config the background, you just need to call TipLabelWithText: tipImage: direction: editModel: if you do not want to get a label with different background
    ImageTipLabel *label1 = [ImageTipLabel TipLabelWithText:@"jokefaker" tipImage:[UIImage imageNamed:@"tip_type_label"] direction:ImageTipLabelDirectionLeft editModel:YES];
    [label1 addTipLabelToView:self.view tipX:0.3123 tipY:0.3];
    
    // set editModel to no to disable dragging and other gestures
    ImageTipLabel *label2 = [ImageTipLabel TipLabelWithText:@"233333333333333333" tipImage:[UIImage imageNamed:@"tip_type_label"] direction:ImageTipLabelDirectionRight editModel:NO];
    [label2 addTipLabelToView:self.view tipX:0.3 tipY:0.7];
    
    NSLog(@"%f %f", label1.tipX, label1.tipY);
    NSLog(@"%f %f", label2.tipX, label2.tipY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
