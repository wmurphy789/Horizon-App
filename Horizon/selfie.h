//
//  ViewController.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface selfie : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *takeSefie;
@property (weak, nonatomic) IBOutlet UIImageView *selfie;
@property (weak, nonatomic) IBOutlet UIView *videoSuper;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UITextField *saySomething;
@property (weak, nonatomic) IBOutlet UITextField *saySomethingV;
@property (weak, nonatomic) IBOutlet UILabel *about;
@property (weak, nonatomic) IBOutlet UIImageView *intention;

- (IBAction)textFieldReturn:(id)sender;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

