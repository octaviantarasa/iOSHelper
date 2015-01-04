//
//  CommentsTableViewCell.h
//  test
//
//  Created by Tarasa on 12/1/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet UILabel *commentUser;
@property (weak, nonatomic) IBOutlet UILabel *commentHour;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UIButton *commentDelete;
@property (strong, nonatomic) NSString *commentId;
@end
