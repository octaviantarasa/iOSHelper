//
//  QuickViewController.m
//  test
//
//  Created by Tarasa on 12/18/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//  

#import "QuickViewController.h"
#import "UIColor+FlatUI.h"
#import <Parse/Parse.h>
@implementation QuickViewController
@synthesize sendHelp,userId,problemId,picker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Quick Solve";
    self.view.backgroundColor = [UIColor turquoiseColor];
    
}
- (IBAction)send:(id)sender{
    
    NSNumber *min = [NSNumber numberWithInteger:[picker minuteInterval]];
    PFObject *goTo = [PFObject objectWithClassName:@"GoTo"];
    goTo[@"send_user_id"] = [PFUser currentUser].objectId;
    goTo[@"user_id"] = userId;
    goTo[@"problem_id"] = problemId;
    goTo[@"time"] = min;
    [goTo save];
    
    PFQuery *pushQuery = [PFInstallation query];
    
    [pushQuery whereKey:@"user" equalTo: goTo[@"user_id"]];
    
    PFPush *pushNotification = [[PFPush alloc] init];
    [pushNotification setQuery: pushQuery];
    [pushNotification setMessage: [NSString stringWithFormat:@"A user is coming to help you. He estimated that he will arrive in %@ minutes", goTo[@"time"]]];
    [pushNotification sendPushInBackground];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end
