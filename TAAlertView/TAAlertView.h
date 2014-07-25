//
//  TAAlertView.h
//  TAPlayer
//
//  Created by Xi Zhang on 7/2/14.
//  Copyright (c) 2014 Arun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    TAAlertViewStyleDefault,
    TAAlertViewStylePlainTextInput
}TAAlertViewStyle;


@class TAAlertView;
@protocol TAAlertViewDelegate <NSObject>

-(void)TAAlertView:(TAAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface TAAlertView : UIView<UITextFieldDelegate>


@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

-(void)show;
-(void)setTAAlertViewType:(TAAlertViewStyle)type;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
-(void)dismiss;
-(UITextField *)textFieldAtIndex:(NSUInteger)index;
-(UIButton*)getButtonForTag:(NSUInteger)tagNumber;

@end
