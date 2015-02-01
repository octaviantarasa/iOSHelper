//
//  NewProblemViewController.m
//  test
//
//  Created by Tarasa on 12/9/14.
//  Copyright (c) 2014 Tarasa. All rights reserved.
//

#import "NewProblemViewController.h"
#import "AppDelegate.h"

#import <Parse/Parse.h>
@interface NewProblemViewController ()

@end

@implementation NewProblemViewController
@synthesize problemDescription,problemDirection,problemLandmark,problemSeverity,problemTitle,imageView;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setAction:@selector(performBackNavigation:)];
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createNewProblem:(id)sender{
    AppDelegate *appD = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    [appD.locationManager stopUpdatingLocation];
    appD.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [appD.locationManager startUpdatingLocation];
    
    NSLog(@"severity === = %@",[problemSeverity titleForSegmentAtIndex:problemSeverity.selectedSegmentIndex]);
    
    if (![problemTitle.text isEqualToString:@""]) {
        if (![problemDescription.text isEqualToString:@""]) {
            if (!problemSeverity.selected) {
                NSData *imageData = UIImagePNGRepresentation(imageView.image);
                PFFile *imageFile = [PFFile fileWithName:problemTitle.text data:imageData];
                [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        if (succeeded) {
                            PFObject *problem =  [PFObject objectWithClassName:@"Problems"];
                            problem[@"title"] = problemTitle.text;
                            problem[@"text"] = problemDescription.text;
                            problem[@"severity"] = [problemSeverity titleForSegmentAtIndex:problemSeverity.selectedSegmentIndex];
                            PFGeoPoint *loc = [PFGeoPoint geoPointWithLocation:appD.locationManager.location];
                            problem[@"location"] = loc;
                            problem[@"user_id"] = [PFUser currentUser].objectId;
                            problem[@"date"] = [NSDate date];
                            problem[@"picture"] = imageFile;
                            [problem save];
                            problemTitle.text = @"";
                            problemDescription.text = @"";
                            problemDirection.text = @"";
                            problemLandmark.text = @"";
                            [self.navigationController popToRootViewControllerAnimated:TRUE];
//                            [problem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                                
//                                
//                            }];
                            
                            
                        }
                    } else {
                        // Handle error
                    }        
                }];
                
                
                
                
                
               
                
                
            }
        }
        
    } else {
        
    }
    [appD.locationManager stopUpdatingLocation];
}


- (void)performBackNavigation:(id)sender
{
    // Do operations
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                    message:@"Are you sure you want to cancel this problem?"
                                                   delegate:nil
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];

    
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)takePhoto:(id)sender
{
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate =self;
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
//        imagePicker.mediaTypes =[NSArray arrayWithObjects:(NSString*) kUTTypeImage, nil];
        imagePicker.allowsEditing =NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
//        newMedia=YES ;
    }
    else if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        

    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
            UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        imageView.image = image;
        
//        if (newMedia)
//            UIImageWriteToSavedPhotosAlbum(image,
//                                           self,
//                                           @selector(image:finishedSavingWithError:contextInfo:),
//                                           nil);
//    }
//    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
//    {
//        // Code here to support video if enabled
//    }
    
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
