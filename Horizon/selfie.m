//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "selfie.h"
#import "AppDelegate.h"

@interface selfie () {
    NSMutableData *_downloadedData;
}

@end

@implementation selfie

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.caption = @"";
    _saySomething.delegate = self;
    _saySomethingV.delegate = self;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString * ab = [NSString stringWithFormat:@"%@, %@",[user valueForKey:@"age"],[[user valueForKey:@"gender"] capitalizedString]];
    _about.text = ab;
    
    if([app.intent  isEqual: @"romance"]) {
        [_intention setImage:[UIImage imageNamed:@"intention-heart.png"]];
    } else {
       [_intention setImage:[UIImage imageNamed:@"intention-friends.png"]];
    }
    if(app.selfie) {
        _selfie.image = app.selfie;
        _saySomethingV.hidden = YES;
    } else {
       //_selfie.image = app.selfie;
        NSURL *videoUrl = app.vSelfie;
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        [_moviePlayer setControlStyle:MPMovieControlStyleDefault];
        [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        _saySomething.hidden = YES;
    }
    _takeSefie.layer.borderWidth = 1.0f;
    _takeSefie.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _takeSefie.layer.cornerRadius = 5;
    
    UIColor *color = [UIColor whiteColor];
    _saySomething.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tap to add caption" attributes:@{NSForegroundColorAttributeName: color}];
    _saySomethingV.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Tap to add caption" attributes:@{NSForegroundColorAttributeName: color}];
}
- (IBAction)toMenu:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.page = @"caption";
}

-(void) viewWillAppear:(BOOL)animated {
    //_moviePlayer.repeatMode = MPMovieRepeatModeOne;
    CGRect rect = CGRectMake(0, 13, [UIScreen mainScreen].bounds.size.width - 47, _videoSuper.bounds.size.height + 65);
    [_moviePlayer.view setFrame:rect];
    [self.videoSuper addSubview: _moviePlayer.view];
    [_moviePlayer prepareToPlay];
    _moviePlayer.shouldAutoplay = NO;
    
    _saySomething.alpha = 0.5f;
    _saySomethingV.alpha = 0.5f;
    //[_moviePlayer play];
}
- (IBAction)saveCaption:(id)sender {
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if(((UIButton *)sender).tag == 0) {
        app.caption = _saySomething.text;
    } else {
        app.caption = _saySomethingV.text;
    }
}

-(IBAction)textFieldReturn:(id)sender {
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    if(((UIButton *)sender).tag == 0) {
        app.caption = _saySomething.text;
    } else {
        app.caption = _saySomethingV.text;
    }
    
    [sender resignFirstResponder];
}

#define MAXLENGTH 30

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
   return newLength <= MAXLENGTH || returnKey;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification {
    // Assign new frame to your view
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [self.view setFrame:CGRectMake(0,-110,screenSize.width,screenSize.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [self.view setFrame:CGRectMake(0,0,screenSize.width,screenSize.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
