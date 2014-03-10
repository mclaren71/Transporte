//
//  ErrorNotification.h
//  Transporte
//
//  Created by Bruce McLaren on 3/10/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorNotification : NSObject

+ (UIAlertView*) genServerError:(NSString*)errorMessage;
+ (UIAlertView*) genExceptionError:(NSException*) exception;
@end
