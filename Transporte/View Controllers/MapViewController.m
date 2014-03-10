//
//  MapViewController.m
//  Transporte
//
//  Created by Bruce McLaren on 3/9/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl* mapTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (weak, nonatomic) IBOutlet UITextField* streetTextField;

@end

@implementation MapViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self registerForKeyboardNotifications];
  
  
  // Set the map over Florianópolis
  CLLocationCoordinate2D startCoord = {.latitude = -27.596903900, .longitude = -48.54945440};
  MKCoordinateRegion mapRegion;
  mapRegion.center = startCoord;
  mapRegion.span.latitudeDelta = 0.1;
  mapRegion.span.longitudeDelta = 0.1;
  [self.mapView setRegion:mapRegion animated: YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)saveLocation:(id)sender
{
  // Send street to delegate
  [self.delegate mapLocationSaved:self.streetTextField.text];
}

// ChangeMap handles changing the type of map displayed, which
// the user can modify from the UISegmentControl.
- (IBAction)changeMap:(id)sender
{
  switch (self.mapTypeSegmentedControl.selectedSegmentIndex)
  {
    case 0:
      self.mapView.mapType = MKMapTypeStandard;
      break;
    case 1:
      self.mapView.mapType = MKMapTypeSatellite;
      break;
    case 2:
      self.mapView.mapType = MKMapTypeHybrid;
  }  
}

// MapLocationFromDoubleTap handles the long press gesture and determine the street
// that the user selected. The street name is displayed in the UITextField at the
// top of the view.
- (IBAction)mapLocationFromDoubleTap:(UILongPressGestureRecognizer*) gestureRecognizer
{
  // Determine the initial point where the user touched.
  CGPoint point = [gestureRecognizer locationInView:self.mapView];
  
  CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.view];
  CLLocation* location = [[CLLocation alloc] initWithLatitude:tapPoint.latitude longitude:tapPoint.longitude];
  CLGeocoder* geocoder = [[CLGeocoder alloc] init];
  
  // ReverseGeocodeLocation will convert latitude/longitude coordinates in a placemark. From the placemark,
  // an address will be found.
  [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
  {
    if ([placemarks count] > 0)
    {
      @try
      {
        NSDictionary* dict = [[placemarks objectAtIndex:0] addressDictionary];
        if ([dict count] > 0)
        {
          // Remove any street numbers.
          NSString* street = [dict valueForKey:@"Street"];
          NSRange range = [street rangeOfString:@","];
          if (range.length > 0)
          {
            _streetTextField.text = [street substringToIndex:range.location];
          }
          else
          {
            _streetTextField.text = street;
          }
        }
      }
      @catch (NSException* ex)
      {
        NSLog(@"Unable to format address by removing street numbers");
      }
    }
  }];
}

@end
