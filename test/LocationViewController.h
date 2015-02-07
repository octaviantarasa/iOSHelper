//
//  LocationViewController.h
//  test
//
//  Created by Ion Silviu-Mihai on 2/7/15.
//  Copyright (c) 2015 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface LocationViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D problemLocation;
@end
