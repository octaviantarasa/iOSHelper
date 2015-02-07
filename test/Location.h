//
//  Location.h
//  AppliFrance
//
//  Created by Ion Silviu-Mihai on 1/29/15.
//  Copyright (c) 2015 geronimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
