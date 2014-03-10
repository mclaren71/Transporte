//
//  BaseViewController.h
//  Transporte
//
//  Created by Bruce McLaren on 3/7/14.
//
//

#import <Foundation/Foundation.h>

@interface BaseViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate >
{
  UIScrollView* scrollView;
}
@property(nonatomic, strong) UITextField *activeField;
@property(nonatomic, strong) UITextView* activeTextView;
@property(nonatomic, strong) IBOutlet UIScrollView* scrollView;

- (void) registerForKeyboardNotifications;
- (void) keyboardWillBeHidden:(NSNotification*)notification;
- (void) keyboardWasShown:(NSNotification*)notification;
- (void) assignKeyboardDoneButtonToTextField:(UITextField*)textField;

@end
