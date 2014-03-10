//
//  RouteDeparture.m
//  Transporte
//
//  Created by Bruce McLaren on 3/8/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "RouteDeparture.h"

@implementation RouteDeparture

- (id) init
{
  if (self = [super init])
  {
    _calendarDay = WEEKDAY;
    _departureId = 0;
    _time = @"";
  }
  return self;
}

- (id) initWithData:(NSDictionary*)dict
{
  if (self = [super init])
  {
    [self decodeDeparture:dict];
  }
  return self;
}

- (void) decodeDeparture:(NSDictionary*)dict
{
  if (dict != nil)
  {
    NSArray* array = [NSArray arrayWithObjects:@"WEEKDAY", @"SATURDAY", @"SUNDAY", nil];
    _calendarDay = [array indexOfObject:[dict objectForKey:@"calendar"]];
    _departureId = [dict objectForKey:@"id"];
    _time = [dict objectForKey:@"time"];
  }
}

@end
