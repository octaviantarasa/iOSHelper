//
//  InitialFeedTableViewController.m
//  test
//
//  Created by Tarasa on 12/9/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "InitialFeedTableViewController.h"
#import "InitialProblemTableViewCell.h"
#import "LocationManagerSingleton.h"
#import "FeedTableViewController.h"
#import "CommentsViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>
@interface InitialFeedTableViewController ()

@end

@implementation InitialFeedTableViewController{
    CLLocationManager *locationManager;
}
@synthesize problemsArray;
@synthesize currentUser;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    
//    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
//    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//        [locationManager requestWhenInUseAuthorization];
//        [locationManager requestAlwaysAuthorization];
//        
//    }
//    locationManager.distanceFilter = 1;
//    [locationManager startUpdatingLocation];
//    


    [self getDataFromParse];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getDataFromParse{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
//                                             (unsigned long)NULL), ^(void) {
//        while (true) {
//             NSLog(@"---------------%@",locationManager.location);
//            [locationManager ]
//        }
//    });
   
    PFQuery *query = [PFQuery queryWithClassName:@"Problems"];
    
    if([problemsArray count]){
        [problemsArray removeAllObjects];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            self.problemsArray =  [objects mutableCopy];
//            [self getNearestLocation];
            [self.myTableView reloadData];
            
        }
    }];
}

- (IBAction)loginButtonTouchHandler:(id)sender  {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        //        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                
            } else {
                NSLog(@"User with facebook logged in!");
            }
//            currentUser = user;
//            NSLog(@"currentUSer ==== %@",currentUser.objectId);
            [self performSegueWithIdentifier:@"ToDetailedFeed" sender:sender];
            //            [self _presentUserDetailsViewControllerAnimated:YES];
        }
    }];
    
    
    
    //    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    InitialProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *problem = [self.problemsArray objectAtIndex:indexPath.row];
    
    [cell.problemTitle setText:[problem objectForKey:@"title"]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d H:m"];
    NSString *stringFromDate = [formatter stringFromDate:[problem objectForKey:@"date"]];
    cell.problemHour.text = stringFromDate;
    
    PFQuery *numberOfComments = [PFQuery queryWithClassName:@"Comments"];
    [numberOfComments whereKey :@"problem_id" equalTo:[problem objectId]];
    [cell.problemComment setText:[[NSString alloc] initWithFormat:@"%ld Comments ",(long)[numberOfComments countObjects]]] ;
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        PFFile *imageFile = [problem objectForKey:@"picture"];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                if (imageData != nil) {
                    // Set the images using the main thread to avoid non-appearing images, due to the UI not updating
                    // (The UI always runs on the main thread)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //  Set the image in the cell
                        cell.problemImage.image = [UIImage imageWithData:imageData];
                        [cell setNeedsLayout];
                    });
                }
                
            }
        }];
        
        // Add a check to add a default image if there is not parse image available
    });
    
    
    
    return cell;
    
}
- (void) getNearestLocation
{
    PFObject *problem;
    PFGeoPoint *point;
    NSString *user;
    for (problem in problemsArray) {
        
        point = [problem objectForKey:@"location"];
        user = [problem objectForKey:@"user_id"];
        CLLocation *locPoint = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        CLLocation *locUser  = [[CLLocation alloc] initWithLatitude:[[LocationManagerSingleton sharedSingleton].locationManager.location coordinate].latitude longitude:[[LocationManagerSingleton sharedSingleton].locationManager.location coordinate].longitude];
        CLLocationDistance dist = [locPoint distanceFromLocation:locUser ];
        BOOL b = [user isEqualToString:[PFUser currentUser].objectId];
        if (dist > 1000 && !b) {
            [self.problemsArray removeObject:problem];
        }
        NSLog(@"distance ======= %f",dist);
        
    }

}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ToDetailedFeed"]) {
        FeedTableViewController * feedTableViewController = [segue destinationViewController];
        
//        [feedTableViewController.currentUser copy:currentUser];
//        ProblemTableViewCell *clickedCell = (ProblemTableViewCell *)[[sender superview] superview];
//        commentsViewController.problemId =clickedCell.problemId;
        
    }
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [problemsArray count];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
