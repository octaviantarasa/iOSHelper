//
//  IntiailProblemTableViewCell.h
//  test
//
//  Created by Tarasa on 12/9/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
@interface InitialProblemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *problemImage;
@property (weak, nonatomic) IBOutlet UILabel *problemTitle;
@property (weak, nonatomic) IBOutlet UILabel *problemComment;
@property (weak, nonatomic) IBOutlet UILabel *problemHour;


@end
