//
//  TMTRestWebServices.m
//  Transporte
//
//  Created by Bruce McLaren on 3/07/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "RestWebServiceUtility.h"
#import "Reachability.h"

NSString* const routesByStopNameURL = @"https://dashboard.appglu.com/v1/queries/findRoutesByStopName/run";
NSString* const stopsByRouteIdURL = @"https://dashboard.appglu.com/v1/queries/findStopsByRouteId/run";
NSString* const departuresByRouteIdURL = @"https://dashboard.appglu.com/v1/queries/findDeparturesByRouteId/run";
NSString* const authString = @"Basic V0tENE43WU1BMXVpTThWOkR0ZFR0ek1MUWxBMGhrMkMxWWk1cEx5VklsQVE2OA==";

@implementation RestWebServiceUtility 

// This function uses Apple provided class called Reachability. Reachability will
// test the user's phone to determine if it connected to the internet and the
// the target server is up.
- (BOOL) isPhoneNetworked
{
  if ([Reachability reachabilityWithHostName:@"https://dashboard.appglu.com"])
  {
    return YES;
  }
  else
  {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to verify network connectivity. Please verify cellular or wifi connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    return NO;
  }
}

// CreateURLRequest will create a generic NSNutableURLRequest for a POST request
// will default header information and authorization.
- (NSMutableURLRequest*) createURLRequest:(NSString*)serverURL
{
  NSMutableString *hostAddr = [NSMutableString stringWithString:serverURL];
  
  // Create request with server address.
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:hostAddr]];
  [request setHTTPMethod:@"POST"];
  
  // Add authorization to request header.
  [request addValue:authString forHTTPHeaderField:@"Authorization"];
  [request addValue:@"staging" forHTTPHeaderField:@"X-AppGlu-Environment"];
  
  // Set messege type to JSON.
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  return request;
}

// FindRoutesByStopName will query a server for all routes on a given street.
// The request will be sent asynchronously and dispatched to the main thread from
// a block. The outgoing body of the request is JSON.
- (void) findRoutesByStopName:(NSString*)streetName
{
  if ([self isPhoneNetworked] == YES)
  {
    // Create a standard URL request.
    NSMutableURLRequest* request = [self createURLRequest:routesByStopNameURL];
    
    // Format the street name
    NSString* formattedStr = [NSString stringWithFormat:@"%%%@%%", streetName];
    
    // Encode the data into JSON format.
    NSDictionary *stopNameDict = [NSDictionary dictionaryWithObjectsAndKeys:formattedStr, @"stopName", nil];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:stopNameDict, @"params", nil];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:jsonData];
    
    // Send request to the server.
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      if ([data length] > 0 && connectionError == nil)
      {
        // Send data back
        dispatch_async(dispatch_get_main_queue(), ^{
          [_delegate routesByStopNameReturned:data];
        });        
      }
      else if (connectionError != nil)
      {
        dispatch_async(dispatch_get_main_queue(), ^{
          [_delegate errorReturned:connectionError];
        });
      }
    }];
  }
}

// FindStopsByRouteId will query the server from all stops on a given route.
// The request will be sent asynchronously and dispatched to the main thread from
// a block. The outgoing body of the request is JSON.
- (void) findStopsByRouteId:(NSNumber*)routeId
{
  if ([self isPhoneNetworked] == YES)
  {
    // Create a standard URL request.
    NSMutableURLRequest* request = [self createURLRequest:stopsByRouteIdURL];
    
    // Specify the street name in the JSON data and add it to the HTTP body
    NSDictionary *stopByRouteIdDict = [NSDictionary dictionaryWithObjectsAndKeys:routeId, @"routeId", nil];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:stopByRouteIdDict, @"params", nil];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:jsonData];
    
    // Send request to the server.
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      if ([data length] > 0 && connectionError == nil)
      {
        // Send data back to the delegate.
        dispatch_async(dispatch_get_main_queue(), ^{
          [_delegate stopsByRouteIdReturned:data];
        });
      }
      else if (connectionError != nil)
      {
        // Tell delegate about error.
        dispatch_async(dispatch_get_main_queue(), ^{
          [_delegate errorReturned:connectionError];
        });
      }
    }];
  }
}

// FindDeparturesByRouteId will query the server for all departures on a given route.
// The request will be sent asynchronously and dispatched to the main thread from
// a block. The outgoing body of the request is JSON.
- (void) findDeparturesByRouteId:(NSNumber*)routeId
{
  if ([self isPhoneNetworked] == YES)
  {
    // Create a standard URL request.
    NSMutableURLRequest* request = [self createURLRequest:departuresByRouteIdURL];
    
    // Specify the street name in the JSON data and add it to the HTTP body
    NSDictionary* departuresDict = [NSDictionary dictionaryWithObjectsAndKeys:routeId, @"routeId", nil];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:departuresDict, @"params", nil];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:jsonData];
    
    // Send request to the server.
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      if ([data length] > 0 && connectionError == nil)
      {
        // Send data back to the delegate.
        dispatch_async(dispatch_get_main_queue(), ^{
          [_delegate departuresByRouteIdReturned:data];
        });
      }
      else if (connectionError != nil)
      {
        dispatch_async(dispatch_get_main_queue(), ^{
          [_delegate errorReturned:connectionError];
        });
      }
    }];
  }
}

@end
