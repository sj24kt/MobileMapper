//
//  RootViewController.m
//  MobileMapper
//
//  Created by Sherrie Jones on 3/24/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "RootViewController.h"
#import <MapKit/MapKit.h>

@interface RootViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *mobileMakersAnnotation;
@property CLLocationManager *locationManager;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    double latitude = 41.89373984;
    double longitude = -87.63532979;
    self.mobileMakersAnnotation = [MKPointAnnotation new];
    self.mobileMakersAnnotation.title = @"Mobile Makers";
    self.mobileMakersAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView addAnnotation:self.mobileMakersAnnotation];

    [self geoCodeLocation:@"Mount Rushmore"];
    [self geoCodeLocation:@"22929 E Alamo Place, Aurora, CO"];
    [self geoCodeLocation:@"Grand Canyon, AZ"];
    [self geoCodeLocation:@"Indaiatuba, BR"];
    [self displayUserLocation];
}

// sets the pin - runs for each annotation view
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if (![annotation isEqual:mapView.userLocation]) {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        pin.image = [UIImage imageNamed:@"makersImage"];
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return pin;
    } else {
        return nil;
    }
}

- (void)geoCodeLocation:(NSString *)addressString {

    NSString *address = addressString;
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = place.location.coordinate;
            annotation.title = place.name;
            [self.mapView addAnnotation:annotation];
            //NSLog(@"%@", annotation.description);

        }
    }];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.01;
    coordinateSpan.longitudeDelta = 0.01;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;
    [self.mapView setRegion:region animated:YES];
}

- (void)displayUserLocation {
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;

}


@end


















