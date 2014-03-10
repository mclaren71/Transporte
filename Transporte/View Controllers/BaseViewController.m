//
//  BaseViewController.m
//  Transporte
//
//  Created by Bruce McLaren on 3/7/14.
//

#import "BaseViewController.h"

@implementation BaseViewController
@synthesize activeField;
@synthesize scrollView;

#pragma mark UITextFieldDelegate

- (void) registerForKeyboardNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if([text isEqualToString:@"\n"])
  {
    [textView resignFirstResponder];
    return NO;
  }
  return YES;
}

-(void)textFieldDidBeginEditing:(UITextField*)textField
{
  self.activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
  self.activeField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark keyboard protocol
- (void) keyboardWillBeHidden:(NSNotification*)notification
{
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	scrollView.contentInset = contentInsets;
	scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) keyboardWasShown:(NSNotification*)notification
{
  NSDictionary *info = [notification userInfo];
	CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
	scrollView.contentInset = contentInsets;
	scrollView.scrollIndicatorInsets = contentInsets;
	
	CGRect rect = self.view.frame;
  rect.size.height -= keyboardSize.width;
	if (!CGRectContainsPoint(rect, self.activeField.frame.origin) )
	{
    int deltaY = self.view.frame.size.height - self.activeField.frame.origin.y;
    if (deltaY < keyboardSize.width)
    {
      int point = 390 - deltaY;
      CGPoint scrollPoint = CGPointMake(0.0, point);
      [scrollView setContentOffset:scrollPoint animated:YES];
    }
	}
}

- (void) assignKeyboardDoneButtonToTextField:(UITextField*)textField
{
  UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
  keyboardDoneButtonView.barStyle = UIBarStyleBlack;
  keyboardDoneButtonView.translucent = NO;
  keyboardDoneButtonView.tintColor = [UIColor whiteColor];
  [keyboardDoneButtonView sizeToFit];
  
  UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleBordered target:self                                                                action:@selector(doneClicked:)];
  
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
  
  // Plug the keyboardDoneButtonView into the text field...
  textField.inputAccessoryView = keyboardDoneButtonView;
}

- (void) doneClicked:(id)sender
{
  [activeField resignFirstResponder];
}
@end
