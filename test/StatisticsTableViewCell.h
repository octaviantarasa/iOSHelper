//
//  StatisticsTableViewCell.h
//  test
//
//  Created by Tarasa on 2/1/15.
//  Copyright (c) 2015 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsTableViewCell : UITableViewCell 
@property (weak,nonatomic) IBOutlet UIProgressView *progress;
@property (weak,nonatomic) IBOutlet UILabel *label;
@property (weak,nonatomic) IBOutlet UILabel *labelCount;
@end
