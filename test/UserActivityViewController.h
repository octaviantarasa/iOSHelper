//
//  UserActivityViewController.h
//  test
//
//  Created by Tarasa on 11/22/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserActivityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myActivityTableView;

@property NSMutableArray *activityArray;
@property NSMutableArray *commentsArray;

@property NSInteger numberOfRow;
@property UIRefreshControl *refreshControl;

@end
