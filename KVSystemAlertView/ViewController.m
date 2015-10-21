//
//  ViewController.m
//  KVSystemAlertView
//
//  Created by 马龙 on 15/10/21.
//  Copyright © 2015年 马龙. All rights reserved.
//

#import "ViewController.h"
#import "SGCheckBox.h"
#import "KVSystemAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Just a subtle background color
    [self.view setBackgroundColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f]];
    
    // A simple button to launch the demo
    UIButton *launchDialog = [UIButton buttonWithType:UIButtonTypeCustom];
    [launchDialog setFrame:CGRectMake(10, 30, self.view.bounds.size.width-20, 50)];
    [launchDialog addTarget:self action:@selector(launchDialog:) forControlEvents:UIControlEventTouchDown];
    [launchDialog setTitle:@"Launch Dialog" forState:UIControlStateNormal];
    [launchDialog setBackgroundColor:[UIColor whiteColor]];
    [launchDialog setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [launchDialog.layer setBorderWidth:0];
    [launchDialog.layer setCornerRadius:5];
    [self.view addSubview:launchDialog];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rc = launchDialog.frame;
    rc.origin.y = rc.origin.y + rc.size.height + 20;
    btn.frame = rc;
    [btn setTitle:@"system alert" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onSystemAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) onSystemAlert:(id) sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"购买" message:@"您已购买您已购买您已购买您已购买您已购买您已购买您已购买您已购买您已购" delegate:self cancelButtonTitle:@"购买" otherButtonTitles:@"取消",nil];
    [alert show];
}

- (void)launchDialog:(id)sender
{     KVSystemAlertView* alertView = [[KVSystemAlertView alloc] initWithTitle:@"购买" Message:@"您已购买您已购买您已购买您已购买您已购买您已购买您已购买您已购买您已购"];
    NSAssert(alertView != nil, @"alertView is nil");
    
    [alertView  setOnButtonTouchUpInside:^(KVSystemAlertView *alertView, int buttonIndex){
        NSLog(@"button index %d clicked", buttonIndex);
    }];
    [alertView addButtonTitles:@[@"购买", @"取消"]];
    
    SGCheckBox* checkBox = [[SGCheckBox alloc] initWithCheckboxImage:[UIImage imageNamed:@"checkbox_unselected.jpg"] selectedCheckBoxImage:[UIImage imageNamed:@"checkbox_selected.jpg"]];
    [checkBox setCheckTitle:@"开启自动购买自动购买自动购买"];
    [checkBox setValueChangeHandle:^(BOOL checked) {
        NSLog(@"checkbox state changed to: %d", checked);
    }];
    checkBox.frame = CGRectMake(0, 0, MAXFLOAT, 20);
    [checkBox resetLabelHeightByFontSize:13];
    [alertView addCustomView:checkBox];
    
    
    [alertView show];
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    [imageView setImage:[UIImage imageNamed:@"demo"]];
    [demoView addSubview:imageView];
    
    return demoView;
}


@end
