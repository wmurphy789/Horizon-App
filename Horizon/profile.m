//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "profile.h"
#import "AppDelegate.h"

@interface profile () {
    NSMutableData *_downloadedData;
}

@end

@implementation profile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    //NSLog(@"profile: %@",user);
    
    NSString * ab = [NSString stringWithFormat:@"%@, %@",[user valueForKey:@"age"],[[user valueForKey:@"gender"] capitalizedString]];
    _about.text = ab;
    _location.text = [user valueForKey:@"location"];
    
    if([[user valueForKey:@"caption"]  isEqual: @""]) {
        _caption.hidden = YES;
    } else {
       _caption.text = [user valueForKey:@"caption"];
    }
    
    if([[user valueForKey:@"intent"]  isEqual: @"romance"]) {
        [_intention setImage:[UIImage imageNamed:@"intention-heart.png"]];
    } else {
        [_intention setImage:[UIImage imageNamed:@"intention-friends.png"]];
    }
    
    if([user valueForKey:@"photo"]) {
        _selfie.image = [user valueForKey:@"photo"];
    } else {
       //_selfie.image = app.selfie;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingFormat:@"/vid1.MOV"];
        [[user valueForKey:@"vFile"] writeToFile:path atomically:NO];
        
        NSURL *videoUrl = [NSURL fileURLWithPath:path];
        
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        [_moviePlayer setControlStyle:MPMovieControlStyleDefault];
        [_moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    }
}
- (IBAction)backFeed:(id)sender {
    [self performSegueWithIdentifier:@"backFeed" sender:self];
}

-(void) viewWillAppear:(BOOL)animated {
    //_moviePlayer.repeatMode = MPMovieRepeatModeOne;
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 68, _videoSuper.bounds.size.height + 20);
    [_moviePlayer.view setFrame:rect];
    [self.videoSuper addSubview: _moviePlayer.view];
    [_moviePlayer prepareToPlay];
    
    //[_moviePlayer play];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_moviePlayer stop];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_moviePlayer stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
