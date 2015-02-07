//
//  ProfileViewController.m
//  test
//
//  Created by Tarasa on 11/22/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIColor+FlatUI.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    self.view.backgroundColor = [UIColor cloudsColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
