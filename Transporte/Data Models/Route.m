//
//  Route.m
//  Transporte
//
//  Created by Bruce McLaren on 3/8/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "Route.h"

@implementation Route

- (id) init
{
  if (self = [super init])
  {
    _routeId = 0;
    _shortName = @"";
    _longName = @"";
    _agencyId = 0;
  }
  return self;
}

- (id) initWithData:(NSDictionary*)dict
{
  if (self = [super init])
  {
    [self decodeRoute:dict];
  }
  return self;
}

- (void) decodeRoute:(NSDictionary*)dict
{
  if (dict != nil)
  {
    _routeId = [dict objectForKey:@"id"];
    _shortName = [dict objectForKey:@"shortName"];
    _longName = [dict objectForKey:@"longName"];
    _agencyId = [dict objectForKey:@"agencyId"];
  }
}

@end
