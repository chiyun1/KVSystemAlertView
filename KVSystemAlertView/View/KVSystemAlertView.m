//
//  KVSystemAlertView.m
//  CustomIOSAlertView
//
//  Created by 马龙 on 15/10/20.
//  Copyright © 2015年 Wimagguc. All rights reserved.
//

#import "KVSystemAlertView.h"


static CGFloat kKVSystemAlertViewTitleTopSpace;
static CGFloat kKVSystemAlertViewDialogHorizonMargin;
static CGFloat kKVSystemAlertViewTitleMessageSpace;
static CGFloat kKVSystemAlertViewMessageBottomSpace;
static CGFloat kKVSystemAlertViewContainerViewBottomSpace;
static CGFloat kKVSystemAlertViewDefaultButtonHeight;
static CGFloat kKVSystemAlertViewDefaultButtonSpacerHeight;
static CGFloat kKVSystemAlertViewCornerRadius;
static CGFloat kKVSystemAlertViewMotionEffectExtent;

static CGFloat kKVSystemAlertViewTitleFontSize;
static CGFloat kKVSystemAlertViewMessageFontSize;


@interface KVSystemAlertView ()

@property (nonatomic, strong) UIView *dialogView;    // Dialog's container view
@property (nonatomic, weak) UIView *containerView; // Container within the dialog (place your ui elements here)

@property (nonatomic, copy) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* message;

@property (nonatomic, copy) KVSystemAlertViewClickHandleBlock clickHandle;


@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* messageLabel;

@property (nonatomic, copy) NSArray* btnTitleArray;
@end

NSInteger systemMajorVersion()
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_3)
    {
        return 9;
    }
    else if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_8_3)
    {
        return 8;
    }
    else if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
    {
        return 7;
    }
    else if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_5_1 && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1)
    {
        return 6;
    }else
    {
        return 5;
    }
}

@implementation KVSystemAlertView

+ (void) load
{
    NSInteger osver = systemMajorVersion();
    switch (osver) {
        case 9:
        case 8:
        case 7:
            kKVSystemAlertViewTitleTopSpace             = 23;
            kKVSystemAlertViewDialogHorizonMargin       = 19;
            kKVSystemAlertViewTitleMessageSpace         = 11;
            kKVSystemAlertViewMessageBottomSpace        = 11;
            kKVSystemAlertViewContainerViewBottomSpace  = 11;
            kKVSystemAlertViewDefaultButtonHeight       = 43;
            kKVSystemAlertViewDefaultButtonSpacerHeight = 1;
            kKVSystemAlertViewCornerRadius              = 7;
            kKVSystemAlertViewMotionEffectExtent        = 10.0;
            
            kKVSystemAlertViewTitleFontSize = [UIFont labelFontSize];
            kKVSystemAlertViewMessageFontSize = 13.0;
            
            break;
        case 6:
        case 5:
            kKVSystemAlertViewTitleTopSpace             = 17;
            kKVSystemAlertViewDialogHorizonMargin       = 19;
            kKVSystemAlertViewTitleMessageSpace         = 13;
            kKVSystemAlertViewMessageBottomSpace        = 13;
            kKVSystemAlertViewContainerViewBottomSpace  = 13;
            kKVSystemAlertViewDefaultButtonHeight       = 43;
            kKVSystemAlertViewDefaultButtonSpacerHeight = 1;
            kKVSystemAlertViewCornerRadius              = 7;
            kKVSystemAlertViewMotionEffectExtent        = 10.0;
            
            kKVSystemAlertViewTitleFontSize = [UIFont labelFontSize];
            kKVSystemAlertViewMessageFontSize = 15.0;
            break;
        default:
            break;
    }
}

- (id) initWithTitle:(NSString*) title Message:(NSString*) message;
{
    if (self = [super init]) {
        _title = title;
        _message = message;
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        _useMotionEffects = false;
        _buttonTitles = @[@"Close"];
        
        _titleLabel = [[UILabel alloc] init];
        _messageLabel = [[UILabel alloc] init];
        
        self.titleLabel.text = self.title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:kKVSystemAlertViewTitleFontSize];
        
        
        self.messageLabel.text = self.message;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont systemFontOfSize:kKVSystemAlertViewMessageFontSize];
        self.messageLabel.numberOfLines = 0;
        
        if (systemMajorVersion() <= 6) {
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.messageLabel.backgroundColor = [UIColor clearColor];
            
            self.titleLabel.textColor = self.messageLabel.textColor = [UIColor whiteColor];
        }
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    return self;
}

-(void) addCustomView:(UIView*) view
{
    self.containerView = view;
}

- (void) addButtonTitles:(NSArray*) titleArray
{
    if (_buttonTitles != nil) {
        _buttonTitles = nil;
    }
    
    _buttonTitles = [NSArray arrayWithArray:titleArray];
}

- (void)show
{
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    _dialogView = [self createContainerView];
    _dialogView.layer.shouldRasterize = YES;
    _dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
#if (defined(__IPHONE_7_0))
    if (_useMotionEffects) {
        [self applyMotionEffects];
    }
#endif
    [self addSubview:_dialogView];
    

    // On iOS7, calculate with orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        // On iOS8, just place the dialog in the middle
    } else {
        
        CGSize screenSize = [self calcScreenSize];
        CGSize dialogSize = [self calcDialogSize];
        CGSize keyboardSize = CGSizeMake(0, 0);
        
        _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
        
    }
    
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
  
    
    _dialogView.layer.opacity = 0.5f;
    _dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         _dialogView.layer.opacity = 1.0f;
                         _dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIView*) createContainerView
{
    CGSize screenSize = [self calcScreenSize];
    CGSize dialogSize = [self calcDialogSize];
    
    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    NSAssert(dialogContainer != nil, @"dialogContainer is null");
    
    
    CALayer* dialogBackgroundLayer = nil;
    CGFloat cornerRadius = kKVSystemAlertViewCornerRadius;
    if (systemMajorVersion() >= 7) {
        CAGradientLayer* gradient = [[CAGradientLayer alloc] init];
        gradient.frame = dialogContainer.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0f] CGColor],
                           (id)[[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0f] CGColor],
                           (id)[[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0f] CGColor],
                           nil];
        

        gradient.cornerRadius = cornerRadius;
        dialogBackgroundLayer = gradient;
        
        [dialogContainer.layer insertSublayer:dialogBackgroundLayer atIndex:0];
        
        dialogContainer.layer.cornerRadius = cornerRadius;
        dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
        dialogContainer.layer.borderWidth = 1;
        dialogContainer.layer.shadowRadius = cornerRadius + 5;
        dialogContainer.layer.shadowOpacity = 0.1f;
        dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
        dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
        dialogContainer.layer.masksToBounds = YES;
        
        // There is a line above the button
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - kKVSystemAlertViewDefaultButtonHeight - kKVSystemAlertViewDefaultButtonSpacerHeight, dialogContainer.bounds.size.width, kKVSystemAlertViewDefaultButtonSpacerHeight)];
        lineView.backgroundColor = [UIColor colorWithRed:211/255.0 green:210/255.0 blue:216/255.0 alpha:1.0f];
        [dialogContainer addSubview:lineView];

        
    }else{
        //dialogBackgroundLayer = [[CALayer alloc] init];
        //dialogBackgroundLayer.frame = dialogContainer.bounds;
        UIImage* backgroundImage = [[UIImage imageNamed:@"TSAlertViewBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 130, 19, 130) resizingMode:UIImageResizingModeStretch];
        UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = dialogContainer.bounds;
        //dialogBackgroundLayer.contents = (__bridge id)(backgroundImage.CGImage);
        dialogBackgroundLayer = backgroundImageView.layer;
        
        [dialogContainer.layer insertSublayer:dialogBackgroundLayer atIndex:0];
        
        dialogContainer.layer.cornerRadius = cornerRadius;
        //dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
        //dialogContainer.layer.borderWidth = 1;
        //dialogContainer.layer.shadowRadius = cornerRadius + 5;
        //dialogContainer.layer.shadowOpacity = 0.1f;
        //dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
        //dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        //dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
        dialogContainer.layer.masksToBounds = YES;
        
        // There is a line above the button
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - kKVSystemAlertViewDefaultButtonHeight - kKVSystemAlertViewDefaultButtonSpacerHeight, dialogContainer.bounds.size.width, kKVSystemAlertViewDefaultButtonSpacerHeight)];
        
        lineView.backgroundColor = [UIColor clearColor];
        [dialogContainer addSubview:lineView];
    }
    

    
    
    // Add the custom container if there is any
    if (_containerView) {
        CGRect containerFrame = _containerView.frame;
        containerFrame.size = CGSizeMake(MIN(containerFrame.size.width, dialogSize.width - kKVSystemAlertViewDialogHorizonMargin*2), containerFrame.size.height);
        
        CGSize sizeTitle = [self calcTitleSize:[self calcMaxMessageWidth]];
        CGSize sizeMessage = [self calcMessageSize:[self calcMaxMessageWidth]];
        
        CGFloat containerViewTop = kKVSystemAlertViewTitleTopSpace + sizeTitle.height + kKVSystemAlertViewTitleMessageSpace + sizeMessage.height + kKVSystemAlertViewMessageBottomSpace;
        
        containerFrame.origin.x = kKVSystemAlertViewDialogHorizonMargin;
        containerFrame.origin.y = containerViewTop;
        _containerView.frame = containerFrame;
        [dialogContainer addSubview:_containerView];
    }
    
    
    // Add the buttons too
    [self addButtonsToView:dialogContainer];
    
    
    CGSize sizeTitle = [self calcTitleSize:[self calcMaxMessageWidth]];
    self.titleLabel.frame = CGRectMake(kKVSystemAlertViewDialogHorizonMargin, kKVSystemAlertViewTitleTopSpace, dialogSize.width - kKVSystemAlertViewDialogHorizonMargin*2, sizeTitle.height);
    
    
    self.messageLabel.text = self.message;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont systemFontOfSize:kKVSystemAlertViewMessageFontSize];
    self.messageLabel.numberOfLines = 0;
    CGSize sizeMessage = [self calcMessageSize:[self calcMaxMessageWidth]];
    self.messageLabel.frame = CGRectMake(kKVSystemAlertViewDialogHorizonMargin, self.titleLabel.frame.origin.y + sizeTitle.height + kKVSystemAlertViewTitleMessageSpace, dialogSize.width - kKVSystemAlertViewDialogHorizonMargin*2, sizeMessage.height);
    
    [dialogContainer addSubview:self.titleLabel];
    [dialogContainer addSubview:self.messageLabel];
    
    return dialogContainer;
    
}

-(void) addButtonsToView:(UIView*) container
{
    if (_buttonTitles==NULL || _buttonTitles.count == 0) { return; }
    
    CGFloat buttonHorizonalMargin = 0;
    CGFloat buttonVericalMargin = 6.0;
    if (systemMajorVersion() <= 6) {
        buttonHorizonalMargin = 6.0;
    }
    
    CGFloat buttonWidth;
    if (_buttonTitles.count > 2) {
        if (systemMajorVersion() <= 6.0) {
            buttonWidth = container.bounds.size.width - buttonHorizonalMargin*2 - kKVSystemAlertViewDialogHorizonMargin;
        }else{
            buttonWidth = container.bounds.size.width;
        }
    }else{
        if (systemMajorVersion() <= 6) {
            buttonWidth = (container.bounds.size.width - kKVSystemAlertViewDialogHorizonMargin*2 - buttonHorizonalMargin*2 - buttonVericalMargin*(_buttonTitles.count-1))/_buttonTitles.count;;
        }else{
            buttonWidth = (container.bounds.size.width - (_buttonTitles.count-1)*kKVSystemAlertViewDefaultButtonSpacerHeight)/_buttonTitles.count;
        }
    }
    
    UIImage* buttonBKImage = [UIImage imageNamed:@"TSAlertViewButtonBackground.png"];
    for (int i=0; i<[_buttonTitles count]; i++) {
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (_buttonTitles.count <= 2) {
            
            if (systemMajorVersion() <= 6) {
                [closeButton setFrame:CGRectMake(kKVSystemAlertViewDialogHorizonMargin + buttonHorizonalMargin + i * buttonWidth + i*buttonHorizonalMargin, container.bounds.size.height - buttonVericalMargin - kKVSystemAlertViewDefaultButtonHeight, buttonWidth, kKVSystemAlertViewDefaultButtonHeight)];
                
                [closeButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [closeButton setBackgroundImage:buttonBKImage forState:UIControlStateNormal];
                closeButton.opaque = YES;
            }else{
                [closeButton setFrame:CGRectMake(i * buttonWidth + i*kKVSystemAlertViewDefaultButtonSpacerHeight, container.bounds.size.height - kKVSystemAlertViewDefaultButtonHeight, buttonWidth, kKVSystemAlertViewDefaultButtonHeight)];
                if (i != 0) {
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*buttonWidth, container.bounds.size.height - kKVSystemAlertViewDefaultButtonHeight, kKVSystemAlertViewDefaultButtonSpacerHeight, kKVSystemAlertViewDefaultButtonHeight)];
                    lineView.backgroundColor = [UIColor colorWithRed:211/255.0 green:210/255.0 blue:216/255.0 alpha:1.0f];
                    [container addSubview:lineView];
                }
                
                [closeButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
                [closeButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
                [closeButton setBackgroundColor:[UIColor colorWithRed:220.0f/255.0 green:220.0f/255.0 blue:220.0f/255.0 alpha:0.8f] forState:UIControlStateHighlighted];
            }
            
        }else{
            if (systemMajorVersion() <= 6) {
                [closeButton setFrame:CGRectMake(buttonHorizonalMargin, container.bounds.size.height - kKVSystemAlertViewDefaultButtonHeight*(i+1) - buttonVericalMargin*i, buttonWidth, kKVSystemAlertViewDefaultButtonHeight)];
                
                [closeButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [closeButton setBackgroundImage:buttonBKImage forState:UIControlStateNormal];
                closeButton.opaque = YES;
            }else{
                [closeButton setFrame:CGRectMake(0, container.bounds.size.height - kKVSystemAlertViewDefaultButtonHeight*(i+1) - kKVSystemAlertViewDefaultButtonSpacerHeight*i, buttonWidth, kKVSystemAlertViewDefaultButtonHeight)];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, container.bounds.size.height - kKVSystemAlertViewDefaultButtonHeight*(i+1) - kKVSystemAlertViewDefaultButtonSpacerHeight*(i+1), container.bounds.size.width, kKVSystemAlertViewDefaultButtonSpacerHeight)];
                lineView.backgroundColor = [UIColor colorWithRed:211/255.0 green:210/255.0 blue:216/255.0 alpha:1.0f];
                [container addSubview:lineView];
                
                [closeButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
                [closeButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
                [closeButton setBackgroundColor:[UIColor colorWithRed:220.0f/255.0 green:220.0f/255.0 blue:220.0f/255.0 alpha:0.8f] forState:UIControlStateHighlighted];
            }
        }
        
        
        [closeButton addTarget:self action:@selector(dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        
        //[closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
        
        
        [closeButton.titleLabel setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
        [closeButton.layer setCornerRadius:kKVSystemAlertViewCornerRadius];
        
        [container addSubview:closeButton];
    }
    
}

-(void) applyMotionEffects
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kKVSystemAlertViewMotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kKVSystemAlertViewMotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kKVSystemAlertViewMotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kKVSystemAlertViewMotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [_dialogView addMotionEffect:motionEffectGroup];
}

// Helper function: count and return the dialog's size
-(CGSize) calcTitleSize:(CGFloat) maxWidth
{
    CGSize sizeTitle = [self.titleLabel sizeThatFits:CGSizeMake(maxWidth - kKVSystemAlertViewDialogHorizonMargin*2, MAXFLOAT)];
    return sizeTitle;
}

-(CGFloat) calcMaxMessageWidth
{
    NSString* checkMessage;
    if (systemMajorVersion() <= 6) {
        checkMessage = @"啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦";
    }else{
        checkMessage = @"啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦";
    }
    
    CGSize sizeCheckMessage = [checkMessage sizeWithFont:[UIFont systemFontOfSize:kKVSystemAlertViewMessageFontSize]];
    return sizeCheckMessage.width;
}

-(CGSize) calcMessageSize: (CGFloat) maxWidth
{
    CGSize sizeMessage = [self.messageLabel sizeThatFits:CGSizeMake(maxWidth - kKVSystemAlertViewDialogHorizonMargin*2, MAXFLOAT)];
    sizeMessage.height += 1.0;
    return sizeMessage;
}

-(CGSize) calcScreenSize
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

-(CGSize) calcDialogSize
{
    CGFloat buttonVericalMargin = 6.0;
    
    CGSize sizeTitle = [self calcTitleSize:[self calcMaxMessageWidth]];
    CGSize sizeMessage = [self calcMessageSize:[self calcMaxMessageWidth]];
    
    CGFloat dialogHeight = kKVSystemAlertViewTitleTopSpace + sizeTitle.height + kKVSystemAlertViewTitleMessageSpace + sizeMessage.height + kKVSystemAlertViewMessageBottomSpace;
    if (_containerView) {
        dialogHeight = dialogHeight + _containerView.frame.size.height + kKVSystemAlertViewContainerViewBottomSpace;
    }
    
    if (self.buttonTitles.count > 2) {
        dialogHeight = dialogHeight + buttonVericalMargin*self.buttonTitles.count + kKVSystemAlertViewDefaultButtonHeight * self.buttonTitles.count;
    }else{
        dialogHeight = dialogHeight + buttonVericalMargin + kKVSystemAlertViewDefaultButtonHeight;
    };
    
    CGFloat dialogWidth = [self calcMaxMessageWidth] + kKVSystemAlertViewDialogHorizonMargin*2;
    
    return CGSizeMake(dialogWidth, dialogHeight);
 
}

- (void)close
{
    CATransform3D currentTransform = _dialogView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[_dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        _dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    _dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         _dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         _dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

- (void)dialogButtonTouchUpInside:(id)sender
{
    if (_delegate != NULL) {
        [_delegate dialogButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
    }
    
    if (_clickHandle != NULL) {
        _clickHandle(self, (int)[sender tag]);
    }

    [self close];
}



- (void)setOnButtonTouchUpInside:(KVSystemAlertViewClickHandleBlock)onButtonTouchUpInside
{
    _clickHandle = onButtonTouchUpInside;
}

// Rotation changed, on iOS7
- (void)changeOrientationForIOS7 {
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _dialogView.transform = rotation;
                         
                     }
                     completion:nil
     ];
    
}

// Rotation changed, on iOS8
- (void)changeOrientationForIOS8: (NSNotification *)notification {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize dialogSize = [self calcDialogSize];
                         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                         _dialogView.frame = CGRectMake((screenWidth - dialogSize.width) / 2, (screenHeight - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
    
    
}


- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationForIOS7];
    } else {
        [self changeOrientationForIOS8:notification];
    }

}

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil]; 
}


@end
