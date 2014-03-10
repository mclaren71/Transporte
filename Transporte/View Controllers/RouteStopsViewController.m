//
//  RouteDetailViewController.m
//  Transporte
//
//  Created by Bruce McLaren on 3/7/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "RouteStopsViewController.h"
#import "RouteStop.h"
#import "RouteDeparture.h"
#import "ErrorNotification.h"

@implementation RouteStopsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (_route != nil)
  {
    self.tableArray = [[NSMutableArray alloc] init];
    [self loadData];
  }
}

// LoadData function with query the server using the RestWebServiceUtility class. The query
// will request all stops that are found by routeId.
- (void)loadData
{
  [self.activityIndicator startAnimating];
  
  RestWebServiceUtility* webServiceUtil = [[RestWebServiceUtility alloc] init];
  webServiceUtil.delegate = self;
  
  // Get route stops using route Id
  [webServiceUtil findStopsByRouteId:_route.routeId];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark RestServiceProtocol
// StopsByRouteIdReturned will decode the JSON data that came back from the server. The data is
// used to create RouteStop objects, which are added to the UITableView.
- (void) stopsByRouteIdReturned:(NSData*)data
{
  [self.activityIndicator stopAnimating];
  
  NSError* error;
  @try
  {
  NSDictionary* serializedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
  if (error == nil)
  {
    if ([serializedData objectForKey:@"error"] != nil)
    {
      UIAlertView* errorAlertView = [ErrorNotification genServerError:[serializedData objectForKey:@"error"]];
      [errorAlertView show];
    }
    else
    {
      NSArray* routes = [serializedData objectForKey:@"rows"];
      for (NSDictionary* dict in routes)
      {
        [self.tableArray addObject:[[RouteStop alloc] initWithData:dict]];
      }
      [self.tableView reloadData];
    }
  }
  }
  @catch (NSException* ex)
  {
    [[ErrorNotification genExceptionError:ex] show];
  }
}

// ErrorReturned is called by the RestWebServiceUtilty class when an error is generated while requesting and handling
// the requested data.
- (void) errorReturned:(NSError*)error
{
  [self.activityIndicator stopAnimating];
  
  NSString* errorMessage = [NSString stringWithFormat:@"There is a problem retrieving the requested data. Error: %@", error.description];
  UIAlertView* errorAlertView = [ErrorNotification genServerError:errorMessage];
  [errorAlertView show];
}

#pragma mark UITableView overrides
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  @try
  {
    RouteStop* routeStop = [self.tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = routeStop.name;
  }
  @catch (NSException* ex)
  {
    cell.textLabel.text = @"";
  }
  [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
  return cell;
}
@end
