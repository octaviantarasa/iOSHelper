//
//  DetailedProblemViewController.m
//  test
//
//  Created by Tarasa on 12/3/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "DetailedProblemViewController.h"
#import "CommentsViewController.h"
//#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LocationViewController.h"
@interface DetailedProblemViewController ()

@end

@implementation DetailedProblemViewController
@synthesize detailedComments, detailedDelete, detailedHour, detailedImageView, detailedIn, detailedLandmark, detailedLocation, detailedSeverity, detailedSolved, detailedState, detailedText, detailedTitle,detailedUserHelper,detailedWillHelp, detailedUserProper;
@synthesize problemId,problem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.problem) {
        [self getDataFromParse];
    }
    else
    {
        [self fillAllOutlets];
    }
    
    PFGeoPoint *geoPoint = [self.problem objectForKey:@"location"];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    if (location.latitude == 0 && location.longitude == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getDataFromParse{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Problems"];
    NSLog(@"problemid = %@",problemId);
    if(problemId){
        [query whereKey:@"objectId" equalTo:problemId];
       
    }
    problem = [query getFirstObject];
    [self fillAllOutlets];
//    [self hello];
   
}



- (void) fillAllOutlets{
   if(![[PFUser currentUser].objectId isEqual:[problem objectForKey:@"user_id"]])
       
   { detailedDelete.hidden = YES;
    PFQuery *uQuery = [PFQuery queryWithClassName:@"_User"];
    [uQuery whereKey:@"objectId" equalTo:[problem objectForKey:@"user_id"]];
    PFObject *u = [uQuery getFirstObject];
       detailedUserProper.text = [u objectForKey:@"name"] ;
   }
    
    else{
        detailedUserProper.hidden = YES;
    }
    [detailedTitle setText:[problem objectForKey:@"title"] ];
    [detailedText setText: [problem objectForKey:@"text"]];
//    [detailedState setText:[problem objectForKey:@"state"]];
    [detailedSolved setText:[problem objectForKey:@"solved_by"]];
    [detailedSeverity setText:[problem objectForKey:@"severity"]];
    [detailedLocation setText:[problem objectForKey:@"location_id"]];
    [detailedLandmark setText:[problem objectForKey:@"landmark"]];
//    [detailedIn setText:[problem objectForKey:@"in_out_town"]];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"GoTo"];
    [query whereKey:@"problem_id" equalTo:problemId];
    if([query countObjects]){
        PFObject *obj = [query getFirstObject];
        PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
        [userQuery whereKey:@"objectId" equalTo:[obj objectForKey:@"send_user_id"]];
        PFObject *userObj= [userQuery getFirstObject];
        detailedUserHelper.text = [userObj objectForKey:@"name"];
    }
    else{
        detailedWillHelp.hidden = YES;
        detailedUserHelper.hidden = YES;
    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d H:m"];
    NSString *stringFromDate = [formatter stringFromDate:[problem objectForKey:@"date"]];
    [detailedHour setText:stringFromDate];
    
    PFQuery *numberOfComments = [PFQuery queryWithClassName:@"Comments"];
    [numberOfComments whereKey :@"problem_id" equalTo:problemId];
    [detailedComments setTitle:[[NSString alloc] initWithFormat:@"%ld Comments ",(long)[numberOfComments countObjects]] forState:UIControlStateNormal ] ;
    
    detailedComments.userInteractionEnabled = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        PFFile *imagefile = [self.problem objectForKey:@"picture"];
        [imagefile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                if (imageData != nil) {
                    // Set the images using the main thread to avoid non-appearing images, due to the UI not updating
                    // (The UI always runs on the main thread)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //  Set the image in the cell
                        detailedImageView.image = [UIImage imageWithData:imageData];
                        
                    });
                }
                
            }
            else NSLog(@"errrror = %@",error);
        }];
        
        // Add a check to add a default image if there is not parse image available
    });

}
- (IBAction)showComments:(id)sender{
    
    [self performSegueWithIdentifier:@"showComments" sender:sender];
    
}

- (IBAction)deleteProblem:(id)sender{
    PFQuery *go = [PFQuery queryWithClassName:@"GoTo"];
    [go whereKey:@"problem_id" equalTo:problemId];
    
    if(![go countObjects]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                        message:@"Are you sure you want to delete this problem?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"A user want to help you. You can't delete this problem now"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        
        PFQuery *prb = [PFQuery queryWithClassName:@"Problems"];
        [prb whereKey:@"objectId" equalTo:problemId];
        PFObject *prob= [prb getFirstObject];
        
        [prob deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//             AppDelegate *appD = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [self.navigationController popToRootViewControllerAnimated:TRUE];
            
        }];
    }
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showComments"]) {
        CommentsViewController* commentsViewController = [segue destinationViewController];
        
        commentsViewController.problemId =self.problemId;
    }
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)seeOnMapPressed:(id)sender {
    LocationViewController *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Location"];
    
    PFGeoPoint *geoPoint = [self.problem objectForKey:@"location"];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    locationVC.problemLocation = location;
    
    [self.navigationController pushViewController: locationVC animated:YES];
}
@end
