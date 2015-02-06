//
//  AppDelegate.m
//  test
//
//  Created by Tarasa on 11/9/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedTableViewController.h"
#import "LocationManagerSingleton.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>

#import "DetailedProblemViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate{
     
}
@synthesize window;
@synthesize Main;


@synthesize myViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"0C5QpsRBnb5LfrFQsX9ZBp4RwzYhWJhTuiM4xNAc"
                  clientKey:@"XTeK9dvckHJSWlQepMc20dujmc8IJ8Gm4kxuTUnr"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    // Handle remote notification
    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"Launched from push notification: %@", dictionary);
            
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            if (![token isEqualToString:@"0"])
            {
                [self performSelector:@selector(handleRemoteNotification:)
                           withObject:dictionary
                           afterDelay:0];
            }
        }
    }

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNone)];
    }
    
    
//    
//    NSLog(@"this shit = %d", [FBSession activeSession].isOpen);
    [PFImageView class];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    NSLog(@"%@", [locations lastObject]);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    if ([PFUser currentUser].objectId)
    {
        currentInstallation[@"user"] = [PFUser currentUser].objectId;
    }
    [currentInstallation saveInBackground];
}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [PFPush handlePush:userInfo];
//}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Received notification: %@", userInfo);
    BOOL afterLaunching = ([application applicationState] == UIApplicationStateActive) ? NO : YES;
    [self handleRemoteNotification:userInfo afterLaunchingApp:afterLaunching];
}
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotification:userInfo afterLaunchingApp:YES];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo afterLaunchingApp:(BOOL)afterLaunching
{
    if (afterLaunching)
    {
        NSString *alertMessage = userInfo[@"aps"][@"alert"];
        NSString *problemId = userInfo[@"idP"];
        if (problemId.length > 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:alertMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:@"View", nil];
            alertView.tag = 100;
            [alertView show];
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:alertMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles: nil];
            [alertView show];
        }
    }
    else
    {
        self.userInfo = userInfo;
        
        NSString *alertMessage = userInfo[@"aps"][@"alert"];
        NSString *problemId = userInfo[@"idP"];
        if (problemId.length > 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:alertMessage
                                                               delegate:self
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:@"View", nil];
            alertView.tag = 100;
            [alertView show];

        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:alertMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles: nil];
            [alertView show];
        }
    }
    
    /* Trigger refresh from push notification
     BOOL shouldRefresh = [userInfo[@"refresh"] boolValue];
     if (shouldRefresh) [[AppModel sharedModel] refreshDataFromServer];
     */
}

- (void)presentModalViewControllerForNotification:(NSDictionary *)userInfo
{
    NSString *problemID = userInfo[@"idP"];
    PFObject *targetProblem = [PFObject objectWithoutDataWithClassName:@"Problems"
                                                            objectId:problemID];
    
    // Fetch photo object
    [targetProblem fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error)
    {
        if (!error && [PFUser currentUser])
        {
            //self.window.rootViewController = self.myViewController;
            
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            UIViewController *visibleViewController = tabBarController.selectedViewController;

            
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            DetailedProblemViewController *detailed = [mainStoryboard instantiateViewControllerWithIdentifier:@"DetailedProblemViewController"];
            detailed.problemId = problemID;
            detailed.problem = object;
            
            if (tabBarController.selectedViewController == tabBarController.moreNavigationController)
            {
                UINavigationController *selectedNavController = tabBarController.moreNavigationController;
                visibleViewController = selectedNavController.visibleViewController;
            }
            else if ([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *selectedNavController = (UINavigationController *)tabBarController.selectedViewController;
                if (selectedNavController.visibleViewController) visibleViewController = selectedNavController.visibleViewController;
            }
            
            [visibleViewController.navigationController pushViewController:detailed animated:YES];
        }
    }];
}


#pragma mark Alert View delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1) [self presentModalViewControllerForNotification:self.userInfo];
    }
}
@end
