# ImageTipLabel
A control to help us put labels in photo,like in and nice.类似like和in的标签控件.

## Screen Shot
![Screen Shot](./ScreenShot.png)

## Installation
### Cocoapods
	pod 'ImageTipLabel', :git => 'https://github.com/jokefaker/ImageTipLabel.git'


## Usage

```
    ImageTipLabel *label1 = [ImageTipLabel TipLabelWithText:@"jokefaker" tipImage:[UIImage imageNamed:@"tip_type_label"] direction:ImageTipLabelDirectionLeft editModel:YES];
    [label1 addTipLabelToView:self.view tipX:0.3123 tipY:0.3];
    
    
    ImageTipLabel *label2 = [ImageTipLabel TipLabelWithText:@"233333333333333333" tipImage:[UIImage imageNamed:@"tip_type_label"] direction:ImageTipLabelDirectionRight editModel:NO];
    [label2 addTipLabelToView:self.view tipX:0.3 tipY:0.7];
```



