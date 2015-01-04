//
//  NewProblemViewController.h
//  test
//
//  Created by Tarasa on 12/9/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewProblemViewController : UIViewController
@property (weak,nonatomic) IBOutlet UITextField *problemTitle;
@property (weak,nonatomic) IBOutlet UITextField *problemDescription;
@property (weak,nonatomic) IBOutlet UITextField *problemLandmark;
@property (weak,nonatomic) IBOutlet UITextField *problemDirection;
@property (weak,nonatomic) IBOutlet UISegmentedControl *problemSeverity;

@end
