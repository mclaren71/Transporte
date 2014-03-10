//
//  ErrorNotification.m
//  Transporte
//
//  Created by Bruce McLaren on 3/10/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "ErrorNotification.h"

@implementation ErrorNotification

+ (UIAlertView*) genServerError:(NSString*)message
{
  NSString* errorMessage = [NSString stringWithFormat:@"There is a problem retrieving data from the server. Error: %@",
                            message];
  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  return alertView;
}

+ (UIAlertView*) genExceptionError:(NSException*) exception
{
  NSString* errorMessage = [NSString stringWithFormat:@"There is a problem with this application. Error: %@",
                            exception.description];
  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Internal Error" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  return alertView;
}

@end
