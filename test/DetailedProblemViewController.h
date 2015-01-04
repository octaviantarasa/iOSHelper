//
//  DetailedProblemViewController.h
//  test
//
//  Created by Tarasa on 12/3/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailedProblemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *detailedImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailedState;
@property (weak, nonatomic) IBOutlet UILabel *detailedTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailedHour;
@property (weak, nonatomic) IBOutlet UILabel *detailedText;
@property (weak, nonatomic) IBOutlet UILabel *detailedIn;
@property (weak, nonatomic) IBOutlet UILabel *detailedLocation;
@property (weak, nonatomic) IBOutlet UILabel *detailedSeverity;
@property (weak, nonatomic) IBOutlet UILabel *detailedLandmark;
@property (weak, nonatomic) IBOutlet UILabel *detailedSolved;
@property (weak, nonatomic) IBOutlet UIButton *detailedComments;
@property (weak, nonatomic) IBOutlet UIButton *detailedDelete;
@property (weak, nonatomic) IBOutlet UILabel *detailedUserHelper;
@property (weak, nonatomic) IBOutlet UILabel *detailedWillHelp;
@property (weak, nonatomic) IBOutlet UILabel *detailedUserProper;

@property (strong, nonatomic) NSString *problemId;
@property (strong, nonatomic) PFObject *problem;
@end
