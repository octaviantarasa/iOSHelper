//
//  QuickViewController.m
//  test
//
//  Created by Tarasa on 12/18/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "QuickViewController.h"
#import <Parse/Parse.h>
@implementation QuickViewController
@synthesize sendHelp,userId,problemId;

- (IBAction)send:(id)sender{
    PFObject *goTo = [PFObject objectWithClassName:@"GoTo"];
    goTo[@"send_user_id"] = [PFUser currentUser].objectId;
    goTo[@"user_id"] = userId;
    goTo[@"problem_id"] = problemId;
    [goTo save];
    [self.navigationController popToRootViewControllerAnimated:YES];
  
}
@end
