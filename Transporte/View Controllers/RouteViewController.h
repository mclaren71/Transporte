//
//  RouteViewController.h
//  Transporte
//
//  Created by Bruce McLaren on 3/7/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RestWebServiceUtility.h"
#import "MapViewController.h"

@interface RouteViewController : BaseTableViewController < UISearchBarDelegate, RestServiceProtocol, MapProtocol >

@property (nonatomic, weak) IBOutlet UISearchBar* searchBar;

- (void) routesByStopNameReturned:(NSData*)data;
- (void) mapLocationSaved:(NSString*)street;

- (IBAction)showMap:(id)sender;

@end
