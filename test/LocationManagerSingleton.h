//
//  LocationManagerSingleton.h
//  test
//
//  Created by Tarasa on 2/5/15.
//  Copyright (c) 2015 Tarasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

+ (LocationManagerSingleton*)sharedSingleton;

@end
