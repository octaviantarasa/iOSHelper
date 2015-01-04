//
//  QuickViewController.h
//  test
//
//  Created by Tarasa on 12/18/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sendHelp;
@property (strong, nonatomic) NSString *problemId;
@property (strong, nonatomic) NSString *userId;
@end
