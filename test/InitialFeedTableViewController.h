//
//  InitialFeedTableViewController.h
//  test
//
//  Created by Tarasa on 12/9/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface InitialFeedTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate >
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property NSMutableArray *problemsArray;
@property NSInteger numberOfRow;
@property UIRefreshControl *refreshControl;
- (IBAction)loginButtonTouchHandler:(id)sender;
@property (strong, nonatomic) PFUser *currentUser;
@end
