# ImageTipLabel
A control to help us put labels in photo,like in and nice.

## Screen Shot
![Screen Shot](./ScreenShot.png)

## Installation
### Cocoapods
	pod 'ImageTipLabel', :git => 'https://github.com/jokefaker/ImageTipLabel.git'


## Usage

```
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
```

##Features

- [x] drag
- [x] long press to delete
- [x] tap to change direction
- [x] input/output the scale in superview 
- [x] custom tip image and background
- [ ] contentview inset
- [ ] little white point's animation