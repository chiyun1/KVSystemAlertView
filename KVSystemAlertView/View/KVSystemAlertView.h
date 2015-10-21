//
//  KVSystemAlertView.h
//  CustomIOSAlertView
//
//  Created by 马龙 on 15/10/20.
//  Copyright © 2015年 Wimagguc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CustomBackgroundColor)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
@end

@implementation UIButton (CustomBackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageFromColor:backgroundColor] forState:state];
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@protocol KVSystemAlertViewDelegate
- (void) dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface KVSystemAlertView : UIView
@property (nonatomic, weak) id<KVSystemAlertViewDelegate> delegate;

- (id) initWithTitle:(NSString*) title Message:(NSString*) message;
-(void) addCustomView:(UIView*) view;
- (void) addButtonTitles:(NSArray*) titleArray;
- (void)show;

typedef void (^KVSystemAlertViewClickHandleBlock)(KVSystemAlertView *alertView, int buttonIndex);
- (void)setOnButtonTouchUpInside:(KVSystemAlertViewClickHandleBlock)onButtonTouchUpInside;

@end
