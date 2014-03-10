//
//  RouteDetailViewController.h
//  Transporte
//
//  Created by Bruce McLaren on 3/7/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Route.h"
#import "RestWebServiceUtility.h"

@interface RouteStopsViewController : BaseTableViewController < RestServiceProtocol >

@property (nonatomic, strong) Route* route;

@end
