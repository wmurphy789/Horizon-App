//
//  ViewController.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface profile : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *selfie;
@property (retain, nonatomic) IBOutlet UIView *videoSuper;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *about;
@property (weak, nonatomic) IBOutlet UIImageView *intention;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end

