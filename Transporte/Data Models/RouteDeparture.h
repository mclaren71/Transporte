//
//  RouteDeparture.h
//  Transporte
//
//  Created by Bruce McLaren on 3/8/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Calendar)
{
  WEEKDAY,
  SATURDAY,
  SUNDAY
};

@interface RouteDeparture : NSObject

@property (nonatomic) NSInteger calendarDay;
@property (nonatomic, strong) NSNumber* departureId;
@property (nonatomic, strong) NSString* time;

- (id) initWithData:(NSDictionary*)dict;

@end
