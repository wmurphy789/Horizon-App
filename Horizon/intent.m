//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "intent.h"
#import "AppDelegate.h"
#import "Overlay.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface intent () {
    NSMutableArray *assetGroups;
    NSTextAttachment *attachment;
    UIActionSheet *attachmentMenuSheet;
}

@end

@implementation intent

- (void)viewDidLoad {
    [super viewDidLoad];
 
    assetGroups = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    _friendly.layer.borderWidth = 1.0f;
    _friendly.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _friendly.layer.cornerRadius = 5;
    _romantic.layer.borderWidth = 1.0f;
    _romantic.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _romantic.layer.cornerRadius = 5;
    _selfie.layer.borderWidth = 1.0f;
    _selfie.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _selfie.layer.cornerRadius = 5;
    _male.layer.borderWidth = 1.0f;
    _male.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _male.layer.cornerRadius = 5;
    _female.layer.borderWidth = 1.0f;
    _female.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _female.layer.cornerRadius = 5;
    
    _library = [[ALAssetsLibrary alloc] init];
}

- (IBAction)friends:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.intent = @"friends";
    _selfie.hidden = NO;
    _camera.hidden = NO;
    
    _friendly.layer.borderColor = [[UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:218.0/255.0 alpha:1] CGColor];
    [_friendly setTitleColor:[UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:218.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_friend setImage:[UIImage imageNamed:@"friendsHighlighted.png"]];
    
    _romantic.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    [_romantic setTitleColor:[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_heart setImage:[UIImage imageNamed:@"heart.png"]];
}
- (IBAction)romantic:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.intent = @"romance";
    _male.hidden = NO;
    _interested.hidden = NO;
    _female.hidden = NO;
    _mIcon.hidden = NO;
    _fIcon.hidden = NO;
    _friendly.hidden = YES;
    _friend.hidden = YES;
    _romantic.hidden = YES;
    _heart.hidden = YES;
    _backButton.hidden = NO;
    
    _friendly.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    [_friendly setTitleColor:[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_friend setImage:[UIImage imageNamed:@"friends.png"]];
    
    _romantic.layer.borderColor = [[UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:218.0/255.0 alpha:1] CGColor];
    [_romantic setTitleColor:[UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:218.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_heart setImage:[UIImage imageNamed:@"heartHighlighted.png"]];
}
- (IBAction)takeSelfie:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Photo Album", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"b: %ld",(long)buttonIndex);
    if(buttonIndex == 0) {
       [self performSegueWithIdentifier:@"showCamera" sender:self]; 
    } else if(buttonIndex == 1) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        __block BOOL tok = FALSE;
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Horizon App"]) {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if(result) {
                        NSTimeInterval diff = 240 - ([[NSDate date] timeIntervalSinceDate:[result valueForProperty:ALAssetPropertyDate]] / 60);
                        
                        if(diff > 0) {
                            tok = TRUE;
                        }
                    }
                }];
            }
        } failureBlock:^(NSError *error) {
            //NSLog(@"Error loading images %@", error);
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Photos Available"
                                                              message:@"Only the last 4 hours can be used!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
        }];
        if(tok) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Photos Available"
                                                              message:@"Only the last 4 hours can be used!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
        } else {
           [self performSegueWithIdentifier:@"toLibrary" sender:self]; 
        }
    }
}

- (IBAction)cancelPicture {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toMenu:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.page = @"intent";
}

- (IBAction)male:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.pref = @"male";
    _selfie.hidden = NO;
    _camera.hidden = NO;
    
    _male.layer.borderColor = [[UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:218.0/255.0 alpha:1] CGColor];
    [_male setTitleColor:[UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:218.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_mIcon setImage:[UIImage imageNamed:@"maleHighlighted.png"]];
    
    _female.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    [_female setTitleColor:[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_fIcon setImage:[UIImage imageNamed:@"female.png"]];
}
- (IBAction)female:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.pref = @"female";
    _selfie.hidden = NO;
    _camera.hidden = NO;
    
    _male.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    [_male setTitleColor:[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_mIcon setImage:[UIImage imageNamed:@"male.png"]];
    
    _female.layer.borderColor = [[UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:218.0/255.0 alpha:1] CGColor];
    [_female setTitleColor:[UIColor colorWithRed:215.0/255.0 green:217.0/255.0 blue:218.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_fIcon setImage:[UIImage imageNamed:@"femaleHighlighted.png"]];
}
// back button
- (IBAction)goBack:(id)sender {
    _selfie.hidden = YES;
    _camera.hidden = YES;
    
    _male.hidden = YES;
    _interested.hidden = YES;
    _female.hidden = YES;
    _mIcon.hidden = YES;
    _fIcon.hidden = YES;
    _friendly.hidden = NO;
    _friend.hidden = NO;
    _romantic.hidden = NO;
    _heart.hidden = NO;
    _backButton.hidden = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    //UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    app.selfie = chosenImage;
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        [_library saveImage:chosenImage toAlbum:@"Horizon App" withCompletionBlock:^(NSError *error) {
            if (error!=nil) {
                NSLog(@"Big error: %@", [error description]);
            } else {
               app.selfie = chosenImage;
            }
        }];
    } else {
        //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        //app.selfie = chosenImage;
        NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
        
        [_library writeVideoAtPathToSavedPhotosAlbum:videoURL completionBlock:^(NSURL     *assetURL, NSError *error) {
            NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
            app.vFile = videoData;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.MOV"];
            [videoData writeToFile:tempPath atomically:NO];
            //app.vSelfie = tempPath;
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self performSegueWithIdentifier:@"toSelfie" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
