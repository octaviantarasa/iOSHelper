//
//  StatisticsViewController.h
//  test
//
//  Created by Tarasa on 11/22/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *statisticsArrayText;
@property (strong, nonatomic) NSMutableArray *statisticsArrayCount;
@end
