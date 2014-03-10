//
//  RouteViewController.m
//  Transporte
//
//  Created by Bruce McLaren on 3/7/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "RouteViewController.h"
#import "RouteStopsViewController.h"
#import "RouteScheduleViewController.h"
#import "Route.h"
#import "ErrorNotification.h"

@implementation RouteViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

// ShowMap will display the mapView so that the user can select a street rather than entering in the street name.
- (IBAction)showMap:(id)sender
{
  [_searchBar resignFirstResponder];
  
  MapViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapKit"];
  viewController.delegate = self;
  [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark UISearchBar delegate functions
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
  [self queryWebService:searchBar.text];
}

// QueryWebService will request route data from the server using the RestWebServiceUtility class.
- (void)queryWebService:(NSString*)address
{
  // Remove any old routes.
  [self.tableArray removeAllObjects];
  
  // Start activity indicator
  [self.activityIndicator startAnimating];
  
  // Create final search string by trimming whitespace from the end of the address.
  NSString* finalString = [address stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
  
  // Make sure we don't query an empty string.
  if ([finalString length] > 0)
  {
    // Call web service
    RestWebServiceUtility* webServiceUtil = [[RestWebServiceUtility alloc] init];
    webServiceUtil.delegate = self;
    [webServiceUtil findRoutesByStopName:address];
  }
}

#pragma mark RestServiceProtocol functions
// RoutesByStopNameReturned will decode the JSON data that came back from the server. The data is
// used to create Route objects which are added to the UITableView.
- (void) routesByStopNameReturned:(NSData*)data
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
          Route* route = [[Route alloc] initWithData:dict];
          
          // Lazy load the tableArray
          if (self.tableArray == nil)
          {
            self.tableArray = [[NSMutableArray alloc] init];
          }
          [self.tableArray addObject:route];
        }
        [self.tableView reloadData];
      }
    }
    else
    {
      UIAlertView* errorAlertView = [ErrorNotification genServerError:error.description];
      [errorAlertView show];
    }
  }
  @catch (NSException* ex)
  {
    UIAlertView* exceptionAlertView = [ErrorNotification genExceptionError:ex];
    [exceptionAlertView show];
  }
}

- (void) errorReturned:(NSError*)error
{
  [self.activityIndicator stopAnimating];
  UIAlertView* errorAlertView = [ErrorNotification genServerError:error.description];
  [errorAlertView show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [_searchBar resignFirstResponder];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  @try
  {
    Route* route = [self.tableArray objectAtIndex:indexPath.row];
    if (route != nil)
    {
      RouteStopsViewController* stopsController = [self.storyboard instantiateViewControllerWithIdentifier:@"RouteStops"];
      stopsController.route = route;
      
      RouteScheduleViewController* scheduleController = [self.storyboard instantiateViewControllerWithIdentifier:@"RouteSchedule"];
      scheduleController.route = route;
      
      UITabBarController* tabBarController = [[UITabBarController alloc] init];
      
      // Create custom navigation bar title.
      CGRect frame = CGRectMake(0, 0, 200, 44);
      UILabel *label = [[UILabel alloc] initWithFrame:frame];
      label.font = [UIFont boldSystemFontOfSize:12.0];
      label.text = route.longName;
      tabBarController.navigationItem.titleView = label;
      
      tabBarController.viewControllers = [NSArray arrayWithObjects:stopsController, scheduleController, nil];
      [self.navigationController pushViewController:tabBarController animated:YES];
    }
  }
  @catch (NSException* ex)
  {
    [[ErrorNotification genExceptionError:ex] show];
  }
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Set up the cell...
  @try
  {
    Route* route = [self.tableArray objectAtIndex:indexPath.row];
  
    // Display long name of route in UITableViewCell.
    cell.textLabel.text = route.longName;
  }
  @catch (NSException* ex)
  {
    cell.textLabel.text = @"";
  }
  [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
  return cell;
}

#pragma mark MapProtocol
// MapLocationSaved is called by the MapViewController after the user has selected a street
// the map view. The street name is already formatted and
- (void) mapLocationSaved:(NSString*)street
{
  [self.navigationController popViewControllerAnimated:YES];
  
  // Display the street name in the searchBar text so that the user can modify the text, if necessary.
  _searchBar.text = street;
  
  // Query the server
  [self queryWebService:street];
}

@end
