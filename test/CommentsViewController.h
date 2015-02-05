//
//  CommentsViewController.h
//  test
//
//  Created by Tarasa on 11/30/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FeedTableViewController.h"
//@protocol CommentsViewControllerDelegate;

@interface CommentsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (strong,nonatomic) NSArray *commentObjects;
@property (strong, nonatomic) NSString *problemId;
@property (strong, nonatomic) PFUser *currentUser;
@property (weak, nonatomic ) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UITableView *myCommentsTableView;
@property (strong, nonatomic) NSString *localCommentId;

//@property (weak,nonatomic) id <CommentsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;

- (IBAction)commentButton:(id)sender;


@end


//@protocol CommentsViewControllerDelegate <NSObject>
//
//- (void) getDataFromParse;
//
//@end