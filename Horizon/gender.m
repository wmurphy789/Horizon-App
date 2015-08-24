//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "gender.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface gender ()

@end

@implementation gender

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _male.layer.borderWidth = 1.0f;
    _male.layer.borderColor = [[UIColor whiteColor] CGColor];
    _male.layer.cornerRadius = 5;
    _female.layer.borderWidth = 1.0f;
    _female.layer.borderColor = [[UIColor whiteColor] CGColor];
    _female.layer.cornerRadius = 5;
}

- (IBAction)male:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.pref = @"male";
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.videoMaximumDuration = 10.0f;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)female:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.pref = @"female";
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.videoMaximumDuration = 10.0f;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        app.selfie = chosenImage;
    } else {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        app.selfie = chosenImage;
        NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
        NSString *pathToVideo = [videoURL path];
        app.vSelfie = pathToVideo;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self performSegueWithIdentifier:@"addCaption" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
