//
//  CommentsViewController.m
//  test
//
//  Created by Tarasa on 11/30/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//
#import "UIColor+FlatUI.h"
#import "UITableViewCell+FlatUI.h"

#import "CommentsViewController.h"
#import "CommentsTableViewCell.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface CommentsViewController ()
{
    UIView *activeView;
    CGPoint lastContentOffset;
}

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
    self.view.backgroundColor = [UIColor cloudsColor];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
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
    if (![[PFUser currentUser].objectId isEqual:[comment objectForKey:@"user_id"]])
    {
        cell.commentDelete.hidden = YES;
    }
    
    cell.commentDelete.tag = indexPath.row;
    cell.commentId = comment.objectId;
    cell.commentText.text = [comment objectForKey:@"text"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d H:m"];
    NSString *stringFromDate = [formatter stringFromDate:[comment objectForKey:@"date"]];
    cell.commentHour.text = stringFromDate;
    
    if ([comment objectForKey:@"userName"]) {
        [cell.commentUser setText:[comment objectForKey:@"userName"]] ;
    }
    
    cell.commentImage.image = nil;
    
    if ([comment objectForKey:@"image"])
    {
        cell.commentImage.file = [comment objectForKey:@"image"];
        [cell.commentImage loadInBackground];
    }
    UIRectCorner corners = 0.2;
    [cell.commentText setTintColor:[UIColor wetAsphaltColor]];
    [cell.commentUser setTextColor:[UIColor wetAsphaltColor]];
    [cell.commentHour setTextColor:[UIColor blueColor]];
    [cell configureFlatCellWithColor:[UIColor cloudsColor]
                       selectedColor:[UIColor cloudsColor]
                     roundingCorners:corners];
    return cell;
}

- (void) getDataFromParse{
    dispatch_queue_t downloadQueue1 = dispatch_queue_create("Data Downloader", NULL);
    dispatch_async(downloadQueue1, ^{
        PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
        [query whereKey:@"problem_id" equalTo:self.problemId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error)
            {
                NSLog(@"Error %@ %@", error, [error userInfo]);
            }
            else
            {
                self.commentObjects = objects;
                [self.myCommentsTableView reloadData];
                
                __block NSNumber *lock = [NSNumber numberWithInt:1];
                __block int numberOfThreads = (int)(self.commentObjects.count);
                for (PFObject *object in self.commentObjects)
                {
                    PFQuery *User = [PFQuery queryWithClassName:@"_User"];
                    
                    [User whereKey :@"objectId" equalTo:[object objectForKey:@"user_id"]];
                    [User getFirstObjectInBackgroundWithBlock:^(PFObject *objectRetrived, NSError *error) {
                        [object setObject:[objectRetrived objectForKey:@"name"] forKey:@"userName"];
                        @synchronized(lock)
                        {
                            numberOfThreads--;
                            if(numberOfThreads < 1)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.myCommentsTableView reloadData];
                                });
                            }
                        }
                    }];

                }
            }
        }];
    });
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeView = textField;
    return YES;
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES    ;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[self animateTextField: textField up: NO];
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

#pragma mark Keyboard Methods for fixing textfields that are under the keyboard
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}



- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = activeView.superview.superview.frame.origin;
    CGFloat buttonHeight = activeView.superview.superview.frame.size.height;
    CGRect visibleRect = self.view.frame;
    visibleRect.origin.y = 0;
    visibleRect.size.height -= keyboardSize.height;
    
    CGPoint buttonEndOrigin = buttonOrigin;
    buttonEndOrigin.y += buttonHeight;
    
    if (!CGRectContainsPoint(visibleRect, buttonEndOrigin))
    {
        lastContentOffset = self.containerScrollView.contentOffset;
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight - self.tabBarController.tabBar.frame.size.height);
        [self.containerScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self.containerScrollView setContentOffset:lastContentOffset animated:YES];
}

@end
