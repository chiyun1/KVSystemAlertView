//
//  SGCheckBox.m
//  CustomIOSAlertView
//
//  Created by 马龙 on 15/10/20.
//  Copyright © 2015年 Wimagguc. All rights reserved.
//

#import "SGCheckBox.h"

typedef void (^SGCheckBoxValueChangeHandle)(BOOL newValue);
@interface SGCheckBox ()
@property (nonatomic, strong) UIImage* normalImage;
@property (nonatomic, strong) UIImage* selectImage;
@property (nonatomic, copy) SGCheckBoxValueChangeHandle valueChangeHandle;
@property (nonatomic, assign) CGFloat labelFontSize;
@end

@implementation SGCheckBox

-(id) initWithCheckboxImage:(UIImage*) image selectedCheckBoxImage:(UIImage*) imageSelected
{
    if (self = [super init]) {
        _selectImage = imageSelected;
        _normalImage = image;
        
        _checkboxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkboxBtn addTarget:self action:@selector(onCheckBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_checkboxBtn];
        [self addSubview:_titleLabel];
        
        [self setChecked:NO];
    }
    
    return self;
}

-(void) resetLabelHeightByFontSize:(CGFloat)fontSize
{
    _labelFontSize = fontSize;
    NSString* textTemp = _titleLabel.text;
    
    _titleLabel.text = @"测试";
    _titleLabel.font = [UIFont systemFontOfSize:fontSize];
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(100, MAXFLOAT)]; //
    
    _titleLabel.text = textTemp;
    CGRect frame = self.frame;
    frame.size.height = size.height;
    self.frame = frame;
    
    [self setNeedsLayout];
}

-(void) setCheckTitle:(NSString*) text
{
    _titleLabel.text = text;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = [self bounds];
    CGRect rcCheckbox = CGRectMake(0, 0, CGRectGetHeight(bounds), CGRectGetHeight(bounds));
    _checkboxBtn.frame = rcCheckbox;
    
    static NSInteger kMiddleSpace = 5;
    CGRect rcLabel = CGRectMake(CGRectGetHeight(bounds) + kMiddleSpace, 0, CGRectGetWidth(bounds) - CGRectGetHeight(bounds) - kMiddleSpace, CGRectGetHeight(bounds));
    _titleLabel.frame = rcLabel;
}

-(void) setChecked:(BOOL) checked
{
    if (checked) {
        [_checkboxBtn setTag:1];
        if (_selectImage) {
            [_checkboxBtn setBackgroundImage:_selectImage forState:UIControlStateNormal];
        }
    }else{
        [_checkboxBtn setTag:0];
        if (_normalImage) {
            [_checkboxBtn setBackgroundImage:_normalImage forState:UIControlStateNormal];
        }
    }
}

-(void) setValueChangeHandle:(void (^)(BOOL checked)) valueChangeHandle
{
    _valueChangeHandle = valueChangeHandle;
}

-(void) onCheckBoxClicked:(id) sender
{
    BOOL bSelected = (BOOL)_checkboxBtn.tag;
    [self setChecked:!bSelected];
    if (_valueChangeHandle) {
        _valueChangeHandle(!bSelected);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
