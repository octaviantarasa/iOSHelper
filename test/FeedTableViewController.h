//
//  myTableViewController.h
//  test
//
//  Created by Tarasa on 11/19/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
@interface FeedTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    int selectedIndex;
    NSMutableArray *titleArray;
    NSArray *subtitleArray;
    IBOutlet UITableView *myTableView;
    NSArray *textArray;
    
}
@property FBLoginView *loginView;

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *FBButton;
@property NSMutableDictionary *imageDictionary;
//@property (strong, nonatomic) PFUser *currentUser;

@property NSMutableArray *problemsArray;
@property NSInteger numberOfRow;
@property UIRefreshControl *refreshControl;
- (IBAction)loginButtonTouchHandler:(id)sender;
- (IBAction) quickSolve:(id)sender;
- (IBAction) showComments:(id)sender;
- (IBAction) showProblem:(id)sender;
@end
