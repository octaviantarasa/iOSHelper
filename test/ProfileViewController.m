//
//  ProfileViewController.m
//  test
//
//  Created by Tarasa on 11/22/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIColor+FlatUI.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize profileImage,name;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    self.view.backgroundColor = [UIColor cloudsColor];
    [self fbData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fbData{
    
    [PFFacebookUtils initializeFacebook];
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        } else {
            // retrive user's details at here as shown below
            NSLog(@"FB user first name:%@",user.first_name);
            NSLog(@"FB user last name:%@",user.last_name);
            NSString *facebookID = user.objectID;
            
            NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
            UIImage *result = [UIImage imageWithData:data];
            profileImage.image = result;
            name.text = user.first_name;
            NSLog(@"picture: %@", result);
            NSLog(@"email id:%@",[user objectForKey:@"email"]);
            
            
        }
    }];
    
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
