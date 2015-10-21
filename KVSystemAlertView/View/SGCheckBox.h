//
//  SGCheckBox.h
//  CustomIOSAlertView
//
//  Created by 马龙 on 15/10/20.
//  Copyright © 2015年 Wimagguc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGCheckBox : UIView
@property (nonatomic, strong) UIButton* checkboxBtn;
@property (nonatomic, strong) UILabel* titleLabel;

-(id) initWithCheckboxImage:(UIImage*) image selectedCheckBoxImage:(UIImage*) imageSelected;
-(void) setCheckTitle:(NSString*) text;
-(void) setChecked:(BOOL) checked;
-(void) setValueChangeHandle:(void (^)(BOOL checked)) valueChangeHandle;
-(void) resetLabelHeightByFontSize:(CGFloat)fontSize;
@end
