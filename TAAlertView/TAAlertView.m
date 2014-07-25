//
//  TAAlertView.m
//  TAPlayer
//
//  Created by Xi Zhang on 7/2/14.
//  Copyright (c) 2014 Arun. All rights reserved.
//

#import "TAAlertView.h"



#define kAnimationDuration 0.5

@interface TAAlertView(){

}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (assign,nonatomic) TAAlertViewStyle alertType;
@property (strong, nonatomic) UIView *modalView;

@end

@implementation TAAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
//    self = [super initWithFrame:CGRectMake(0, 0, 340, 209)];
    self = [[[NSBundle mainBundle] loadNibNamed:@"TAAlertView" owner:nil options:nil]  objectAtIndex:0];

    if (self) {
        self.inputTextField.delegate=self;
        self.titleLabel.text=title;
        [self configTiTle];
        self.delegate = delegate;
        self.buttonArray = [NSMutableArray array];
        if (message!=nil) {
            self.messageLabel =[[UILabel alloc] initWithFrame:CGRectMake(35, 12, 270, 72)];
            [self.messageLabel setBackgroundColor:[UIColor clearColor]];
            [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
            self.messageLabel.text=message;
            [self configMessageLabel];
            [self.contentView addSubview:self.messageLabel];
        }
        
        if (cancelButtonTitle!=nil) {
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.cancelButton setBackgroundColor:[UIColor clearColor]];
            self.cancelButton.titleLabel.text =cancelButtonTitle;
            [self.cancelButton addTarget:self action:@selector(removeAlertView) forControlEvents:UIControlEventTouchUpInside];
            CGRect rect = CGRectMake(0, 100, 340, 43);
            [self.cancelButton setFrame:rect];
            [self.contentView addSubview:self.cancelButton];
            
        }
        
        CGFloat totalWidth = 340.0;
        CGFloat unitWidth = totalWidth /otherButtonTitles.count;
        int marginNumber = 0;
        if (self.cancelButton!=nil) {
            marginNumber = 1;
            unitWidth = totalWidth /(otherButtonTitles.count+1);
        }
        
        
        for (int i =0; i<otherButtonTitles.count; i++) {
            //to be continued.
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:[otherButtonTitles objectAtIndex:i]  forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            int line =i;

    
            CGFloat currentX =i*(unitWidth+marginNumber)+line+unitWidth;
            CGRect rect = CGRectMake(i*(unitWidth+marginNumber)+line, 100, unitWidth, 43);
            [button setFrame:rect];
            [self configCommonButton:button];
            [self.contentView addSubview:button];
            [self.buttonArray addObject:button];
            
            if (i!=otherButtonTitles.count-1) {
            UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(currentX, 100, 1.0, 43)];
                  [seperator setBackgroundColor:[UIColor lightGrayColor]];
                [self.contentView addSubview:seperator];
            }
       
          
            button.tag = i;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

-(void)configCommonButton:(UIButton *)button
{
    UIFont *matterFont = [UIFont systemFontOfSize:18.0];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:matterFont];
}

-(void)configTiTle
{
    UIFont *matterBoldFont = [UIFont systemFontOfSize:22.0];
    [self.titleLabel setFont:matterBoldFont];
}

-(void)configMessageLabel
{
    UIFont *matterFont = [UIFont systemFontOfSize:15.0];
    [self.messageLabel setFont:matterFont];
    [self.messageLabel setNumberOfLines:0];
    [self.messageLabel setTextColor:[UIColor blackColor]];
}

-(void)setTAAlertViewType:(TAAlertViewStyle)type
{
    self.alertType=type;
    switch (type) {
        case TAAlertViewStyleDefault:
        {
            [self.inputTextField setHidden:YES];
            [self.messageLabel setHidden:NO];
        }
            break;
        
        case TAAlertViewStylePlainTextInput:
        {
            [self.inputTextField setHidden:NO];
            [self.messageLabel setHidden:YES];
        }
        default:
            break;
    }
}

-(UITextField *)textFieldAtIndex:(NSUInteger)index
{
    //for TAALERT now just ignore index input
    switch (self.alertType) {
        case TAAlertViewStyleDefault:{
            return nil;
        }
            break;
        case TAAlertViewStylePlainTextInput:{
            return self.inputTextField;
        }
        
            
        default:
            return nil;
            break;
    }
}

-(void)awakeFromNib
{
    
    self.layer.cornerRadius= 5.0;
    self.inputTextField.layer.cornerRadius = 5.0;
    self.layer.masksToBounds=YES;
    self.inputTextField.layer.masksToBounds=YES;
    self.messageLabel.backgroundColor=[UIColor clearColor];
   
}

-(void)show
{
    
  //  UIView *mainView = [self.window.subviews objectAtIndex:0];// [(UIViewController*)self.window view];
     [self setUserInteractionEnabled:NO];
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    if (!mainWindow.subviews.count) {
        return;
    }
    UIView* mainView = mainWindow.subviews[0];

    
    self.center = CGPointMake(CGRectGetMidX(mainView.bounds), CGRectGetMidY(mainView.bounds)) ;
    [mainView addSubview:self];
    [self.superview bringSubviewToFront:self];
    if (!self.modalView) {
        self.modalView = [[UIView alloc] initWithFrame:self.superview.bounds];
        [self.modalView setBackgroundColor:[UIColor clearColor]];
        [self.superview insertSubview:self.modalView belowSubview:self];
    }
//    [self setUserInteractionEnabled:YES];
//    
//    
//    [self setUserInteractionEnabled:NO];
     self.transform = CGAffineTransformMakeScale(0.8, 0.8);
      [self.layer setOpacity:0.0];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.transform = CGAffineTransformIdentity;
        [self.layer setOpacity:1.0];
    } completion:^(BOOL finished) {
     [self setUserInteractionEnabled:YES];
    }];
  
//    UIView *mainView = [(UIViewController*)self.delegate view];
//
//    self.center = CGPointMake(CGRectGetMidX(mainView.bounds), CGRectGetMidY(mainView.bounds)) ;
//    [mainView addSubview:self];
//    [self.superview bringSubviewToFront:self];
//    if (!self.modalView) {
//        self.modalView = [[UIView alloc] initWithFrame:self.superview.bounds];
//        [self.modalView setBackgroundColor:[UIColor clearColor]];
//        [self.superview insertSubview:self.modalView belowSubview:self];
//    }
//    [self setUserInteractionEnabled:YES];
}


-(void)disableRecursivelyAllSubviews:(UIView *)theView
{
    theView.userInteractionEnabled = NO;
    for(UIView* subview in [theView subviews])
    {
        [self disableRecursivelyAllSubviews:subview];
    }
}

-(void)disableAllSubviewsOf:(UIView *)theView
{
    for(UIView* subview in [theView subviews])
    {
        [self disableRecursivelyAllSubviews:subview];
    }
}

-(void)enableRecursivelyAllSubviews:(UIView *)theView
{
    theView.userInteractionEnabled = YES;
    for(UIView* subview in [theView subviews])
    {
        [self enableRecursivelyAllSubviews:subview];
    }
}

-(void)enableAllSubViewOf:(UIView *)theView
{
    for(UIView* subview in [theView subviews])
    {
        [self enableRecursivelyAllSubviews:subview];
    }
}

-(void)removeAlertView
{
    [self setUserInteractionEnabled:NO];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self.layer setOpacity:0.0];
    } completion:^(BOOL finished) {
       // UIView *mainView = [(UIViewController*)self.delegate view];
        if (self.modalView) {
            [self.modalView removeFromSuperview];
            self.modalView=nil;
        }
       // [self enableAllSubViewOf:mainView];
        [self removeFromSuperview];
    }];
}

-(void)buttonDidClicked:(UIButton*)sender
{
    if (self.delegate) {
  
        [self.delegate TAAlertView:self clickedButtonAtIndex:sender.tag];
    }
}

-(UIButton*)getButtonForTag:(NSUInteger)tagNumber;
{
    UIButton *button = (UIButton*)[self.buttonArray objectAtIndex:tagNumber];
    return button;
}



-(void)dismiss
{
    [self removeAlertView];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
     NSDictionary *userInfo = notification.userInfo;
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    CGRect keyboardBounds;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    

    UIView* mainView = self.superview;
    
    CGRect rect = [mainView convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y -=rect.size.height/2;
        self.frame = frame;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
     NSDictionary *userInfo = notification.userInfo;
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];

    UIView* mainView = self.superview;
    
    CGRect rect = [mainView convertRect:keyboardBounds fromView:nil];

    [UIView animateWithDuration:animationDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y +=rect.size.height/2;
        self.frame = frame;
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
