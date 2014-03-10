//
//  Route.h
//  Transporte
//
//  Created by Bruce McLaren on 3/8/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

@property (nonatomic, strong) NSNumber* routeId;
@property (nonatomic, strong) NSString* shortName;
@property (nonatomic, strong) NSString* longName;
@property (nonatomic, strong) NSNumber* agencyId;

- (id) initWithData:(NSDictionary*)dict;

@end
