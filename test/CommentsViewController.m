//
//  CommentsViewController.m
//  test
//
//  Created by Tarasa on 11/30/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsTableViewCell.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "FeedTableViewController.h"
@interface CommentsViewController ()

@end

@implementation CommentsViewController
@synthesize commentObjects;
@synthesize myCommentsTableView;
@synthesize problemId,currentUser;
@synthesize commentTextField,commentButton, localCommentId;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDataFromParse];
    commentTextField.delegate =self;

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    }

- (void)viewWillDisappear:(BOOL)animated {
    
    
    
    [super viewWillDisappear:animated];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [commentObjects count];
}

-  (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"comCell";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    PFObject *comment = [self.commentObjects objectAtIndex:indexPath.row];
    if (![[PFUser currentUser].objectId isEqual:[comment objectForKey:@"user_id"]]) {
        cell.commentDelete.hidden = YES;
        
    }
    cell.commentDelete.tag = indexPath.row;
    cell.commentId = comment.objectId;
    cell.commentText.text = [comment objectForKey:@"text"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d H:m"];
    NSString *stringFromDate = [formatter stringFromDate:[comment objectForKey:@"date"]];
    cell.commentHour.text = stringFromDate;
    
    PFQuery *User = [PFQuery queryWithClassName:@"_User"];
       
    [User whereKey :@"objectId" equalTo:[comment objectForKey:@"user_id"]];
    PFObject *tmpUser = [User getFirstObject];
    cell.commentUser.text = [tmpUser objectForKey:@"name" ];
    
    
  
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        PFFile *imageFile = [comment objectForKey:@"image"];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                if (imageData != nil) {
                    // Set the images using the main thread to avoid non-appearing images, due to the UI not updating
                    // (The UI always runs on the main thread)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 4. Set the image in the cell
                        cell.commentImage.image = [UIImage imageWithData:imageData];
                        [cell setNeedsLayout];
                    });
                }
                
            }
        }];
        
        // Add a check to add a default image if there is not parse image available
    });

    
    return cell;
}

- (void) getDataFromParse{
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"problem_id" equalTo:self.problemId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
        else {
            self.commentObjects = objects;
            [self.myCommentsTableView reloadData];
            
        }
    }];
}
- (IBAction)commentButton:(id)sender{
    NSString *commentText = [commentTextField text];

    if (![commentText isEqual:@""]) {
        PFObject *comment = [PFObject objectWithClassName:@"Comments"];
        comment[@"text"] = commentText;
        comment[@"user_id"] = [PFUser currentUser].objectId;
        comment[@"problem_id"] = problemId;
        comment[@"date"] = [NSDate date];
        [comment save];
        commentTextField.text = nil  ;
        [self textFieldDidEndEditing:commentTextField];
        [self getDataFromParse];
        [myCommentsTableView reloadData];
        
    }
}
- (IBAction) deleteComment:(id)sender{
    NSLog(@"sender tag  = %ld", (long)[sender tag]);
    
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    //Type cast it to CustomCell
    CommentsTableViewCell *cell = (CommentsTableViewCell*)[myCommentsTableView cellForRowAtIndexPath:myIP];
    localCommentId = cell.commentId;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                    message:@"Are you sure you want to delete this comment?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        PFQuery *comm = [PFQuery queryWithClassName:@"Comments"];
        [comm whereKey:@"objectId" equalTo:localCommentId];
        PFObject *comment = [comm getFirstObject];
        
        [comment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            //             AppDelegate *appD = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//            [self.navigationController popToRootViewControllerAnimated:TRUE];
            [self  getDataFromParse];
            [self.myCommentsTableView reloadData];
            
        }];
    }
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES    ;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 155; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
