//
//  AppDelegate.h
//  test
//
//  Created by Tarasa on 11/9/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *myViewController;
@property (strong, nonatomic) UIStoryboard *Main;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

