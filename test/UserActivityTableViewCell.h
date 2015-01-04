//
//  UserActivityTableViewCell.h
//  test
//
//  Created by Tarasa on 12/16/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *problem;
@end
