//
//  StatisticsViewController.m
//  test
//
//  Created by Tarasa on 11/22/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//
#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"

#import "StatisticsViewController.h"
#import "StatisticsTableViewCell.h"
#import <Parse/Parse.h>
@interface StatisticsViewController ()

@end

@implementation StatisticsViewController
@synthesize statisticsArrayText,statisticsArrayCount;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor turquoiseColor];
    
    [self getDataFromParse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) getDataFromParse{
    
    statisticsArrayText = [[NSMutableArray alloc] init];
    statisticsArrayCount = [[NSMutableArray alloc] init];
    NSString *currentUser = [PFUser currentUser].objectId;
    PFQuery *tmpQuery = [PFQuery queryWithClassName:@"Problems"];
    [tmpQuery whereKey:@"user_id" equalTo:currentUser];
    

    NSNumber *count = [[NSNumber alloc] initWithInteger:[tmpQuery countObjects]];
    NSString *text = @"Number of problems created by you";
    
    [statisticsArrayText addObject:text];
    [statisticsArrayCount addObject:count];
    
    tmpQuery = [PFQuery queryWithClassName:@"Problems"];
    [tmpQuery whereKey:@"solved_by" equalTo:currentUser];
    
    count = [NSNumber numberWithInteger:[tmpQuery countObjects]] ;
    text = @"Number of problems solved by you";
    [statisticsArrayText addObject:text];
    [statisticsArrayCount addObject:count];

    
    
    tmpQuery = [PFQuery queryWithClassName:@"GoTo"];
    [tmpQuery whereKey:@"send_user_id" equalTo:currentUser];
    
    count = [NSNumber numberWithInteger:[tmpQuery countObjects]];
    text = @"Number of problems in which you were involved";
    [statisticsArrayText addObject:text];
    [statisticsArrayCount addObject:count];
    
    
    
    tmpQuery = [PFQuery queryWithClassName:@"Problems"];
    [tmpQuery whereKey:@"Solved_date" greaterThan:[[NSDate date] dateByAddingTimeInterval:-7*60*60*24]];
    
    count = [NSNumber numberWithInteger:[tmpQuery countObjects]];
    text = @"Number of problems solved this week";
    [statisticsArrayText addObject:text];
    [statisticsArrayCount addObject:count];
    
    
    
    tmpQuery = [PFQuery queryWithClassName:@"Problems"];
    [tmpQuery whereKey:@"Solved_date" greaterThan:[[NSDate date] dateByAddingTimeInterval:-1*60*60*24]];
    
    count = [NSNumber numberWithInteger:[tmpQuery countObjects]];
    text = @"Number of problems solved today";
    [statisticsArrayText addObject:text];
    [statisticsArrayCount addObject:count];
    
    
    
    tmpQuery = [PFQuery queryWithClassName:@"Problems"];
    
        count = [NSNumber numberWithInteger:[tmpQuery countObjects]];
    text = @"Number of all the problems ";
    [statisticsArrayText addObject:text];
    [statisticsArrayCount addObject:count];
    
    
    tmpQuery = [PFQuery queryWithClassName:@"Problems"];
    [tmpQuery whereKey:@"solved_by" greaterThan:@"0"];
    
    count = [NSNumber numberWithInteger:[tmpQuery countObjects]];
    text = @"Number of all the solved problems";
    [statisticsArrayText addObject:text];
    [statisticsArrayCount addObject:count];
    
    
    
    
//    NSLog(@"%lu",(unsigned long)statisticsArray.count);
    
    
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIRectCorner corners = 0.2;
    static NSString *CellIdentifier = @"Cell";
    StatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.label.text = [NSString stringWithFormat:@"%@", [self.statisticsArrayText objectAtIndex:indexPath.row]] ;
    cell.labelCount.text = [[self.statisticsArrayCount objectAtIndex:indexPath.row] stringValue];
   cell.progress.progress = [[self.statisticsArrayCount objectAtIndex:indexPath.row] floatValue]/10.0;
    
    [cell.label setTextColor:[UIColor wetAsphaltColor]];
    [cell.labelCount setTextColor:[UIColor wetAsphaltColor]];
    [cell configureFlatCellWithColor:[UIColor cloudsColor]
                       selectedColor:[UIColor cloudsColor]
                     roundingCorners:corners];
        return cell;
    
   
    






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
    return nil;

}

    
@end
    
    
//    
//    
//    
//    
//    
//    NSMutableArray *tmpProblemsArray = [[tmpQuery findObjects] mutableCopy];
//    NSMutableArray *problems = [[NSMutableArray alloc] init];
//    for (int i=0; i<tmpProblemsArray.count; i++) {
//        [problems addObject: [tmpProblemsArray[i] objectId]];
//        
//    }
//    for(int i=0;i < problems.count;i++){
//        NSLog(@"problems = %@",problems[i]);
//    }
//    
//    PFQuery *comments = [PFQuery queryWithClassName:@"Comments"];
//    [comments whereKey:@"problem_id" containedIn:problems ];
//    [comments whereKey:@"user_id" notEqualTo:[PFUser currentUser].objectId];
//    NSLog(@"comments = %ld", (long)[comments countObjects] );
//    [comments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error) {
//            NSLog(@"Error %@ %@", error, [error userInfo]);
//        }
//        else {
//            activityArray  = [objects mutableCopy];
//            NSLog(@"activityArray = %ld", [activityArray count]);
//            [comments whereKey:@"user_id" equalTo:[PFUser currentUser].objectId];
//            [comments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                if (error) {
//                    NSLog(@"Error %@ %@", error, [error userInfo]);
//                }
//                else {
//                    [activityArray addObjectsFromArray:objects];
//                    
//                    PFObject *tmp;
//                    for (int i=0; i<activityArray.count; i++) {
//                        for (int j=1; j<activityArray.count; j++) {
//                            if([activityArray[i] createdAt]<[activityArray[j] createdAt])
//                            { tmp = activityArray[i];
//                                activityArray[i]= activityArray[j];
//                                activityArray[j] = tmp;
//                            }
//                        }
//                    }
//                    [self.myActivityTableView reloadData];
//                    
//                }
//                
//            }];
//            
//            
//            
//            
//        }
//        
//    }];
//    
//    
//}
//
//- (void)getNewData{
//    [self getDataFromParse];
//    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];
//    
//}
//
//- (void)stopRefresh{
//    
//    [self.refreshControl endRefreshing];
//    
//}
////
//
//@end
