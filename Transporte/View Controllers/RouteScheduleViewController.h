//
//  RouteScheduleViewController.h
//  Transporte
//
//  Created by Bruce McLaren on 3/8/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "Route.h"
#import "RestWebServiceUtility.h"

@interface RouteScheduleViewController : BaseTableViewController < RestServiceProtocol >

@property (nonatomic, strong) Route* route;
@property (nonatomic, strong) NSMutableArray* weekdays;
@property (nonatomic, strong) NSMutableArray* saturdays;
@property (nonatomic, strong) NSMutableArray* sundays;
@property (nonatomic, strong) NSArray* calendarDays;

@end
