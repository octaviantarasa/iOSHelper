//
//  UserActivityViewController.m
//  test
//
//  Created by Tarasa on 11/22/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//
#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"

#import "UserActivityViewController.h"
#import "UserActivityTableViewCell.h"
#import <Parse/Parse.h>
@interface UserActivityViewController ()

@end

@implementation UserActivityViewController
@synthesize myActivityTableView, activityArray,commentsArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(getNewData) forControlEvents:UIControlEventValueChanged];
    [self.myActivityTableView addSubview:refresh];
    self.refreshControl = refresh;
    self.myActivityTableView.delegate = self;
    self.title = @"Activity";
    self.view.backgroundColor = [UIColor cloudsColor];
    [self getDataFromParse];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getDataFromParse{
    
    
    PFQuery *tmpQuery = [PFQuery queryWithClassName:@"Problems"];
    [tmpQuery whereKey:@"user_id" equalTo:[PFUser currentUser].objectId];
    NSMutableArray *tmpProblemsArray = [[tmpQuery findObjects] mutableCopy];
    NSMutableArray *problems = [[NSMutableArray alloc] init];
    for (int i=0; i<tmpProblemsArray.count; i++) {
        [problems addObject: [tmpProblemsArray[i] objectId]];
        
    }
    for(int i=0;i < problems.count;i++){
        NSLog(@"problems = %@",problems[i]);
    }
    
    PFQuery *comments = [PFQuery queryWithClassName:@"Comments"];
    [comments whereKey:@"problem_id" containedIn:problems ];
    [comments whereKey:@"user_id" notEqualTo:[PFUser currentUser].objectId];
    NSLog(@"comments = %ld", (long)[comments countObjects] );
    [comments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            activityArray  = [objects mutableCopy];
            NSLog(@"activityArray = %ld", [activityArray count]);
            [comments whereKey:@"user_id" equalTo:[PFUser currentUser].objectId];
            [comments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"Error %@ %@", error, [error userInfo]);
                }
                else {
                    [activityArray addObjectsFromArray:objects];
                    
                    PFObject *tmp;
                    for (int i=0; i<activityArray.count; i++) {
                        for (int j=1; j<activityArray.count; j++) {
                            if([activityArray[i] createdAt]<[activityArray[j] createdAt])
                            { tmp = activityArray[i];
                                activityArray[i]= activityArray[j];
                                activityArray[j] = tmp;
                            }
                        }
                    }
                    [self.myActivityTableView reloadData];
                    
                }
                
            }];

            
            
            
        }
        
    }];
    
    
}

- (void)getNewData{
    [self getDataFromParse];
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];
    
}

- (void)stopRefresh{
    
    [self.refreshControl endRefreshing];
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [activityArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UserActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    
    PFObject *activity = [self.activityArray objectAtIndex:indexPath.row];
    
    cell.problem.text = nil;
    cell.user.text = nil;
    
    dispatch_queue_t downloadQueue1 = dispatch_queue_create("Data Downloader", NULL);
    dispatch_async(downloadQueue1, ^{
        PFQuery *problems = [PFQuery queryWithClassName:@"Problems"];
        [problems whereKey:@"objectId" equalTo:[activity objectForKey:@"problem_id"]];
        [problems getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (indexPath.row == cell.tag) {
                    cell.problem.text = [object objectForKey:@"title"];
                }

            });
        }];
    });
    
    
    if ([[activity objectForKey:@"user_id"] isEqual:[PFUser currentUser].objectId])
    {
        cell.user.text = @"You";
    }
    else
    {
        dispatch_queue_t downloadQueue1 = dispatch_queue_create("Data Downloader", NULL);
        dispatch_async(downloadQueue1, ^{
            PFQuery *users = [PFQuery queryWithClassName:@"_User"];
            [users whereKey:@"objectId" equalTo:[activity objectForKey:@"user_id"]];
            [users getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (indexPath.row == cell.tag)
                    {
                        cell.user.text = [object objectForKey:@"name"];
                    }
                });
            }];
        });
        

    }
    
    cell.date.text = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d H:m"];
    NSString *stringFromDate = [formatter stringFromDate:[activity objectForKey:@"date"]];
    cell.date.text = stringFromDate;
    
    
     UIRectCorner corners = 0.2;
    [cell.user setTextColor:[UIColor wetAsphaltColor]];
    [cell.problem setTextColor:[UIColor wetAsphaltColor]];
    [cell.date setTintColor:[UIColor greenSeaColor]];
    
    [cell configureFlatCellWithColor:[UIColor cloudsColor]
                       selectedColor:[UIColor cloudsColor]
                     roundingCorners:corners];
    
    
    //    PFObject *problem = [self.problemsArray objectAtIndex:indexPath.row];
    //
    //    if([[problem objectForKey:@"user_id"] isEqual:[PFUser currentUser].objectId]){
    //        //set color for your problems
    //
    //    }
    //
    //    [cell.problemTitle setTitle:[problem objectForKey:@"title"] forState:UIControlStateNormal];
    //
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"M/d H:m"];
    //    NSString *stringFromDate = [formatter stringFromDate:[problem objectForKey:@"date"]];
    //    cell.problemHour.text = stringFromDate;
    //
    //    PFQuery *numberOfComments = [PFQuery queryWithClassName:@"Comments"];
    //    [numberOfComments whereKey :@"problem_id" equalTo:[problem objectId]];
    //    [cell.problemComment setTitle:[[NSString alloc] initWithFormat:@"%ld Comments ",(long)[numberOfComments countObjects]] forState:UIControlStateNormal ] ;
    //
    //    NSString *prbId = problem.objectId;
    //    cell.problemId = prbId;
    //
    //    cell.problemComment.userInteractionEnabled = YES;
    //
    //    [cell.quickButton setTitle:@"Quick" forState:UIControlStateNormal];
    //
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_async(queue, ^{
    //
    //        PFFile *imageFile = [problem objectForKey:@"picture"];
    //
    //        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
    //            if (!error) {
    //                if (imageData != nil) {
    //                    // Set the images using the main thread to avoid non-appearing images, due to the UI not updating
    //                    // (The UI always runs on the main thread)
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        //  Set the image in the cell
    //                        cell.problemImage.image = [UIImage imageWithData:imageData];
    //                        [cell setNeedsLayout];
    //                    });
    //                }
    //
    //            }
    //        }];
    //
    //        // Add a check to add a default image if there is not parse image available
    //    });
    //
    //
    //
    return cell;
    
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
