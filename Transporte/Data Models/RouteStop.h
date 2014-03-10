//
//  RouteStop.h
//  Transporte
//
//  Created by Bruce McLaren on 3/8/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteStop : NSObject

@property (nonatomic, strong) NSNumber* stopId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* sequence;

- (id) initWithData:(NSDictionary*)dict;

@end
