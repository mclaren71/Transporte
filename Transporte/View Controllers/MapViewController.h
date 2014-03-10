//
//  MapViewController.h
//  Transporte
//
//  Created by Bruce McLaren on 3/9/14.
//  Copyright (c) 2014 Bruce McLaren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"

@protocol MapProtocol <NSObject>

- (void) mapLocationSaved:(NSString*)street;

@end

@interface MapViewController : BaseViewController < MKMapViewDelegate >

@property (nonatomic, strong) id< MapProtocol > delegate;

- (IBAction)saveLocation:(id)sender;
- (IBAction)changeMap:(id)sender;
- (IBAction)mapLocationFromDoubleTap:(UILongPressGestureRecognizer*) gestureRecognizer;

@end
