//
//  RouteScheduleViewController.m
//  Transporte
//
//  Created by Bruce McLaren on 3/8/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "RouteScheduleViewController.h"
#import "RouteDeparture.h"
#import "ErrorNotification.h"

@implementation RouteScheduleViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.calendarDays = [NSArray arrayWithObjects:@"Weekday", @"Saturday", @"Sunday", nil];
  
	if (_route != nil)
  {
    [self loadData];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

// LoadData function with query the server using the RestWebServiceUtility class. The query
// will request all departure times that are found by routeId.
- (void)loadData
{
  [self.activityIndicator startAnimating];
  
  RestWebServiceUtility* webServiceUtil = [[RestWebServiceUtility alloc] init];
  webServiceUtil.delegate = self;
  
  // Get route departures using route Id
  [webServiceUtil findDeparturesByRouteId:_route.routeId];
}

// AddWeekdayDeparture will add the RouteDeparture object to the array,
// after the array has been initialized the first time.
- (void) addWeekdayDeparture:(RouteDeparture*)departure
{
  if ([_weekdays count] == 0)
  {
    _weekdays = [[NSMutableArray alloc] init];
  }
  [_weekdays addObject:departure];
}

// AddSaturdayDeparture will add the RouteDeparture object to the array,
// after the array has been initialized the first time.
- (void) addSaturdayDeparture:(RouteDeparture*)departure
{
  if ([_saturdays count] == 0)
  {
    _saturdays = [[NSMutableArray alloc] init];
  }
  [_saturdays addObject:departure];
}

// AddSundayDeparture will add the RouteDeparture object to the array,
// after the array has been initialized the first time.
- (void) addSundayDeparture:(RouteDeparture*)departure
{
  
  if ([_sundays count] == 0)
  {
    _sundays = [[NSMutableArray alloc] init];
  }
  [_sundays addObject:departure];
}

#pragma mark RestServiceProtocol.
// DeparturesByRouteIdReturned will decode the JSON data that came back from the server. The data is
// used to create RouteDeparture objects, which are added to the UITableView based on calendar day.
- (void) departuresByRouteIdReturned:(NSData*)data
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
          RouteDeparture* departure = [[RouteDeparture alloc] initWithData:dict];
          switch (departure.calendarDay)
          {
            case WEEKDAY:
              [self addWeekdayDeparture:departure];
              break;
            case SATURDAY:
              [self addSaturdayDeparture:departure];
              break;
            case SUNDAY:
              [self addSundayDeparture:departure];
              break;
          }
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.calendarDays count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section)
  {
    case WEEKDAY:
      return [_weekdays count];
      break;
    case SATURDAY:
      return [_saturdays count];
      break;
    case SUNDAY:
      return [_sundays count];
  }
  return 0;
}

// ViewForHeaderInSection function will create a custom view for each UITableView section header.
// The section header will display the specific calendar day for that section.
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
  [myView setBackgroundColor:[UIColor colorWithRed:46/255.0f green:85/255.0f blue:150/255.0f alpha:1.0f]];
  
  UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 8.0, 200.0, 20.0)];
  [label setFont:[UIFont fontWithName:@"TrebuchetMS" size:16.0]];
  label.textColor = [UIColor whiteColor];
  label.text = [self.calendarDays objectAtIndex:section];
  
  [myView addSubview:label];
  return myView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  RouteDeparture* departure = nil;
  @try
  {
    switch (indexPath.section)
    {
      case WEEKDAY:
        departure = [_weekdays objectAtIndex:indexPath.row];
        break;
      case SATURDAY:
        departure = [_saturdays objectAtIndex:indexPath.row];
        break;
      case SUNDAY:
        departure = [_sundays objectAtIndex:indexPath.row];
    }
    if (departure != nil)
    {
      cell.textLabel.text = departure.time;
    }
  }
  @catch (NSException* ex)
  {
    cell.textLabel.text = @"";
  }
  [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
  return cell;
}

@end
