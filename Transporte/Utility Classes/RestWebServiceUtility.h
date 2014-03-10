//
//  TMTRestWebServices.h
//  Transporte
//
//  Created by Bruce McLaren on 3/07/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RestServiceProtocol <NSObject>

@optional
- (void) routesByStopNameReturned:(NSData*)data;
- (void) stopsByRouteIdReturned:(NSData*)data;
- (void) departuresByRouteIdReturned:(NSData*)data;
- (void) errorReturned:(NSError*)error;
@end

@interface RestWebServiceUtility : NSObject

@property (nonatomic, strong) id<RestServiceProtocol> delegate;

- (void) findRoutesByStopName:(NSString*)streetName;
- (void) findStopsByRouteId:(NSNumber*)routeId;
- (void) findDeparturesByRouteId:(NSNumber*)routeId;

@end
