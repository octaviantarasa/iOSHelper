//
//  ProblemTableViewCell.h
//  test
//
//  Created by Tarasa on 11/28/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
@interface ProblemTableViewCell : UITableViewCell 
@property (weak, nonatomic) IBOutlet PFImageView *problemImage;
@property (weak, nonatomic) IBOutlet UIButton *problemTitle;
@property (weak, nonatomic) IBOutlet UILabel *problemText;
@property (weak, nonatomic) IBOutlet UIButton *problemComment;
@property (weak, nonatomic) IBOutlet UILabel *problemHour;
@property (strong, nonatomic) IBOutlet UIButton *quickButton;
@property (strong, nonatomic) NSString *problemId;
@property (strong, nonatomic) NSString *userId;
@end
