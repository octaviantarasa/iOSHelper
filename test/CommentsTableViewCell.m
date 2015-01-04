//
//  CommentsTableViewCell.m
//  test
//
//  Created by Tarasa on 12/1/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "CommentsTableViewCell.h"

@implementation CommentsTableViewCell
@synthesize commentHour, commentImage, commentText,  commentUser,commentDelete, commentId;



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
