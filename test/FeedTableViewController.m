//
//  myTableViewController.m
//  test
//
//  Created by Tarasa on 11/19/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "FeedTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ProblemTableViewCell.h"
#import "DetailedProblemViewController.h"
#import "CommentsViewController.h"
#import "NewProblemViewController.h"
#import "QuickViewController.h"
#import "InitialFeedTableViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import <ParseUI/ParseUI.h>
@interface FeedTableViewController ()

@end

@implementation FeedTableViewController{
    CLLocationManager *locationManager;
}
@synthesize loginView;
@synthesize myTableView;
@synthesize FBButton;
@synthesize numberOfRow;
@synthesize problemsArray;
//@synthesize currentUser;
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex = -1;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(getNewData) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:refresh];
    self.refreshControl = refresh;
   
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"%@", [locations lastObject]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataFromParse];
    
}

- (void) getDataFromParse{
    
    dispatch_queue_t downloadQueue1 = dispatch_queue_create("Data Downloader", NULL);
    dispatch_async(downloadQueue1, ^{
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
                
                __block NSNumber *lock = [NSNumber numberWithInt:1];
                __block int numberOfThreads = (int)(self.problemsArray.count);
                
                
                for (PFObject *object in self.problemsArray)
                {
                    PFQuery *numberOfComments = [PFQuery queryWithClassName:@"Comments"];
                    [numberOfComments whereKey :@"problem_id" equalTo:[object objectId]];
                    //[cell.problemComment setText:[[NSString alloc] initWithFormat:@"%ld Comments ",(long)[numberOfComments countObjects]]] ;
                    [numberOfComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                     {
                         [object setObject: [NSString stringWithFormat:@"%lu", (unsigned long)[objects count] ] forKey:@"commentsCount"];
                         
                         @synchronized(lock)
                         {
                             numberOfThreads--;
                             if(numberOfThreads < 1)
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [self.myTableView reloadData];
                                 });
                             }
                         }
                         
                     }];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.myTableView reloadData];
                });
            }
        }];
    });
}

- (void)getNewData{
    [self getDataFromParse];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];
    
}

- (void)stopRefresh{
    
    [self.refreshControl endRefreshing];
    
}
- (IBAction)quickSolve:(id)sender{
    
}

- (IBAction)showComments:(id)sender{
    
    [self performSegueWithIdentifier:@"showComments" sender:sender];
    
}
- (IBAction) newProblem:(id)sender{
    [self performSegueWithIdentifier:@"showNewProblem" sender:sender];
}

- (IBAction)showProblem:(id)sender{
    [self performSegueWithIdentifier:@"showProblem" sender:sender];
}
- (IBAction) logOutButtonTouchHandler:(id)sender{
    
     [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:^{}];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *problem = [self.problemsArray objectAtIndex:indexPath.row];
    
    if([[problem objectForKey:@"user_id"] isEqual:[PFUser currentUser].objectId]){
        cell.quickButton.hidden = YES;
        //set color for your problems
        
    }
    
    [cell.problemTitle setTitle:[problem objectForKey:@"title"] forState:UIControlStateNormal];
    
    cell.userId = [problem objectForKey:@"user_id"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d H:m"];
    NSString *stringFromDate = [formatter stringFromDate:[problem objectForKey:@"date"]];
    cell.problemHour.text = stringFromDate;
    
    if ([[self.problemsArray objectAtIndex: indexPath.row] objectForKey:@"commentsCount"]) {
        [cell.problemComment setTitle:[[NSString alloc] initWithFormat:@"%@ Comments ",[[self.problemsArray objectAtIndex: indexPath.row] objectForKey:@"commentsCount"]] forState:UIControlStateNormal];
    }
    
    NSString *prbId = problem.objectId;
    cell.problemId = prbId;
    
    cell.problemComment.userInteractionEnabled = YES;
    
    [cell.quickButton setTitle:@"Quick" forState:UIControlStateNormal];
    cell.problemText.text  = [problem objectForKey:@"text"];
    
    cell.problemImage.image = nil;
    
    if ([problem objectForKey:@"picture"])
    {
        cell.problemImage.file = [problem objectForKey:@"picture"];
        [cell.problemImage loadInBackground];
    }

    return cell;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    if ([[segue identifier] isEqualToString:@"showComments"]) {
        CommentsViewController* commentsViewController = [segue destinationViewController];
        ProblemTableViewCell *clickedCell = (ProblemTableViewCell *)[self.myTableView cellForRowAtIndexPath: indexPath];
        commentsViewController.problemId = clickedCell.problemId;
    }
    else if ([[segue identifier] isEqualToString:@"showProblem"]){
        DetailedProblemViewController *detailed = [segue destinationViewController];
        ProblemTableViewCell *clickedCell = (ProblemTableViewCell *)[self.myTableView cellForRowAtIndexPath: indexPath];
        detailed.problemId =clickedCell.problemId;
    }
    else if ([[segue identifier] isEqualToString:@"showNewProblem"]){
        NewProblemViewController *newPVC = [segue destinationViewController];
        
    }
    else if ([[segue identifier] isEqualToString:@"quickHelp"]){
        QuickViewController *quick = [segue destinationViewController];
        ProblemTableViewCell *clickedCell = (ProblemTableViewCell *)[self.myTableView cellForRowAtIndexPath: indexPath];
        quick.problemId = clickedCell.problemId;
        quick.userId = clickedCell.userId;
    }
    else if([[ segue identifier] isEqualToString:@"logOutSegue"]){
      InitialFeedTableViewController *initial = [segue destinationViewController];
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//        app.window.rootViewController = initial;
        app.myViewController = initial;
        
    }
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [problemsArray count];
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
        CLLocation *locUser  = [[CLLocation alloc] initWithLatitude:[locationManager.location coordinate].latitude longitude:[locationManager.location coordinate].longitude];
        CLLocationDistance dist = [locPoint distanceFromLocation:locUser ];
        BOOL b = [user isEqualToString:[PFUser currentUser].objectId];
        if (dist > 1000 && !b) {
            [self.problemsArray removeObject:problem];
        }
//        NSLog(@"distance ======= %f",dist);
        
    }
}


//dispatch_sync(dispatch_get_main_queue(), ^{
//    [locationManager startUpdatingLocation];
//    NSLog(@"locatie ---- %f", [locationManager location].coordinate.latitude);
//});


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGRect frame = loginView.frame;
//    frame.origin.y = scrollView.contentOffset.y - self.loginView.frame.size.height + self.myTableView.frame.size.height - self.loginView.frame.size.height;
//    self.loginView.frame = frame;
//
//    [self.view bringSubviewToFront:self.loginView];
//}
@end


