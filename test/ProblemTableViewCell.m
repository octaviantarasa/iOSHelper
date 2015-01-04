//
//  ProblemTableViewCell.m
//  test
//
//  Created by Tarasa on 11/28/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "ProblemTableViewCell.h"

@implementation ProblemTableViewCell
@synthesize problemComment;
@synthesize problemHour;
@synthesize problemImage;
@synthesize problemTitle;
@synthesize quickButton;
@synthesize problemId,userId;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
