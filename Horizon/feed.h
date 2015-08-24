//
//  ViewController.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface feed : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate> {
    NSMutableArray *jsonArray;
}
@property (weak, nonatomic) IBOutlet UITextField *updateCaption;
@property (weak, nonatomic) IBOutlet UINavigationBar *feed;
@property (weak, nonatomic) IBOutlet UIButton *update;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (nonatomic, weak) UILabel *fullscreenOverlay;
@property (weak, nonatomic) IBOutlet UILabel *location;

-(IBAction)textFieldReturn:(id)sender;
- (void)handleTap:(UITapGestureRecognizer *)recognizer;

@end

