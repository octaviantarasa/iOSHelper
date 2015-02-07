//
//  LocationViewController.m
//  test
//
//  Created by Ion Silviu-Mihai on 2/7/15.
//  Copyright (c) 2015 Tarasa. All rights reserved.
//

#import "LocationViewController.h"
#import "Location.h"
#define METERS_PER_MILE 1609.344
@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self plotLocationPositions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)plotLocationPositions
{
    Location *location = [[Location alloc] initWithName:@"Problem" address:@"Please help me" coordinate: self.problemLocation];
    [_mapView showAnnotations:@[location] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[Location class]])
    {
        MKPinAnnotationView  *annotationView = (MKPinAnnotationView  *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView  alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            //annotationView.image = [UIImage imageNamed:@"arrest.png"];
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    Location *location = (Location*)view.annotation;
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}


@end
