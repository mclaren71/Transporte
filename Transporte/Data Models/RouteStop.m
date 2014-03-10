//
//  RouteStop.m
//  Transporte
//
//  Created by Bruce McLaren on 3/8/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "RouteStop.h"

@implementation RouteStop

- (id) init
{
  if (self = [super init])
  {
    _stopId = 0;
    _name = @"";
    _sequence = 0;
  }
  return self;
}

- (id) initWithData:(NSDictionary*)dict
{
  if (self = [super init])
  {
    [self decodeStop:dict];
  }
  return self;
}

- (void) decodeStop:(NSDictionary*)dict
{
  if (dict != nil)
  {
    _stopId = [dict objectForKey:@"id"];
    _name = [dict objectForKey:@"name"];
    _sequence = [dict objectForKey:@"sequence"];
  }
}

@end
