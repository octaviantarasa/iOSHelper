//
//  LocationManagerSingleton.m
//  test
//
//  Created by Tarasa on 2/5/15.
//  Copyright (c) 2015 Tarasa. All rights reserved.
//

#import "LocationManagerSingleton.h"

@implementation LocationManagerSingleton

@synthesize locationManager;

- (id)init {
    self = [super init];
    
    if(self) {
        self.locationManager = [CLLocationManager new];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:1];
        [self.locationManager setHeadingFilter:kCLHeadingFilterNone];
      
        [self.locationManager startUpdatingLocation];
        //do any more customization to your location manager
    }
    
    return self;
}

+ (LocationManagerSingleton*)sharedSingleton {
    static LocationManagerSingleton* sharedSingleton;
    if(!sharedSingleton) {
        @synchronized(sharedSingleton) {
            sharedSingleton = [LocationManagerSingleton new];
        }
    }
    
    return sharedSingleton;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    //handle your heading updates here- I would suggest only handling the nth update, because they
    //come in fast and furious and it takes a lot of processing power to handle all of them
}

@end
