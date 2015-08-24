//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "feed.h"
#import "AppDelegate.h"
#import "TableCell.h"

@interface feed () {
    int rows;
}

@end

@implementation feed

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDate *currentTime = [NSDate date];
    
    jsonArray = [[NSMutableArray alloc] init];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"horizon_background.png"]];
    
    _update.layer.borderWidth = 1.0f;
    _update.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _update.layer.cornerRadius = 5;
    
    _updateCaption.delegate = self;
    
    // Refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
   _location.text = [user valueForKey:@"location"];
    
    NSString * post;
    if([[user valueForKey:@"intent"] isEqual:@"friends"]) {
      post = [NSString stringWithFormat:@"fbid=%@&pid=%@&checktime=%@&intent=%@",[user valueForKey:@"fbid"], [user valueForKey:@"pid"],resultString, [user valueForKey:@"intent"]];
    } else {
      post = [NSString stringWithFormat:@"fbid=%@&pid=%@&checktime=%@&gender=%@&preference=%@&intent=%@",[user valueForKey:@"fbid"], [user valueForKey:@"pid"], resultString, [user valueForKey:@"gender"], [user valueForKey:@"pref"], [user valueForKey:@"intent"]];
    }

    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://horizonapp.net/_scripts/get_feed.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
  
    if (![jsonArray  isEqual: @"nousers"]) {
        rows = (int)[jsonArray count];
    } else {
        rows = 0;
        
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDate *currentTime = [NSDate date];
    NSTimeInterval diff = 15 - ([currentTime timeIntervalSinceDate:[user valueForKey:@"checktime"]] / 60);
    //[self performSegueWithIdentifier:@"loggedIn" sender:self];
    if(diff <= 0) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        [self performSegueWithIdentifier:@"backToLogin" sender:self];
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    //AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString * post;
    if([[user valueForKey:@"intent"] isEqual:@"friends"]) {
        post = [NSString stringWithFormat:@"fbid=%@&pid=%@&checktime=%@&intent=%@",[user valueForKey:@"fbid"], [user valueForKey:@"pid"],resultString, [user valueForKey:@"intent"]];
    } else {
        post = [NSString stringWithFormat:@"fbid=%@&pid=%@&checktime=%@&gender=%@&preference=%@&intent=%@",[user valueForKey:@"fbid"], [user valueForKey:@"pid"], resultString, [user valueForKey:@"gender"], [user valueForKey:@"pref"], [user valueForKey:@"intent"]];
    }
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://horizonapp.net/_scripts/get_feed.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
    
    if(![jsonArray  isEqual: @"nousers"]) {
        rows = (int)[jsonArray count];
        [self.tableView reloadData];
    } else {
        rows = 0;
        [self.tableView reloadData];
    }
    [refreshControl endRefreshing];
}

-(void)viewDidLayoutSubviews {
    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![jsonArray  isEqual: @"nousers"]) {
        return [jsonArray count];
    }
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableCell";
    TableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int row = (int)[indexPath row];
    cell.noONe.hidden = YES;
    cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
    
    if([jsonArray isEqual:@"nousers"]) {
        cell.about.hidden = YES;
        cell.caption.hidden = YES;
        cell.selfie.hidden = YES;
        cell.background.hidden = YES;
        cell.noONe.hidden = NO;
    } else {
        cell.about.hidden = NO;
        cell.caption.hidden = NO;
        cell.selfie.hidden = NO;
        cell.background.hidden = NO;
        
        NSString *type = [jsonArray[row][@"photo"] substringFromIndex: [jsonArray[row][@"photo"] length] - 3];
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://horizonapp.net%@",jsonArray[row][@"photo"]]];
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        
        UIImage *image;
        if([type  isEqual: @"jpg"]) {
            image = [UIImage imageWithData:imageData];
            cell.selfie.image = image;
        } else {
            cell.selfie.hidden = YES;
            _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:imageUrl];
            [_moviePlayer setControlStyle:MPMovieControlStyleDefault];
            [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
            
            //CGRect rect = CGRectMake(-2, 0, [UIScreen mainScreen].bounds.size.width - 45, cell.videoSuper.bounds.size.height + 50);
            CGRect rect = CGRectMake(-2, 0, [UIScreen mainScreen].bounds.size.width - 45, (cell.frame.size.height * .69));
           
            [_moviePlayer.view setFrame:rect];
            [cell.videoSuper addSubview: _moviePlayer.view];
            [_moviePlayer prepareToPlay];
            _moviePlayer.shouldAutoplay = NO;
            
           UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            UIView *aView = [[UIView alloc] initWithFrame:_moviePlayer.view.bounds];
            [aView addGestureRecognizer:tapGesture];
            [_moviePlayer.view addSubview:aView];
        }
        
        if([jsonArray[row][@"caption"]  isEqual: @""]) {
            cell.caption.hidden = YES;
        } else {
            cell.caption.text = jsonArray[row][@"caption"];
        }
        
        cell.caption.alpha = 0.5f;
        NSString * about = [NSString stringWithFormat:@"%@, %@",jsonArray[row][@"age"], jsonArray[row][@"gender"]];
        cell.about.text = about;
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([[user valueForKey:@"intent"]  isEqual: @"romance"]) {
            [cell.intention setImage:[UIImage imageNamed:@"intention-heart.png"]];
        } else {
            [cell.intention setImage:[UIImage imageNamed:@"intention-friends.png"]];
        }
    }
    
    return cell;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [_moviePlayer setFullscreen:YES animated:NO]; //commenting out this will make it work
    [_moviePlayer play];
}

- (IBAction)toMenu:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.page = @"feed";
}
// Show Profile
- (IBAction)showP:(id)sender {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if([user valueForKey:@"photo"]) {
        [self performSegueWithIdentifier:@"showProfile" sender:self];
    } else {
        /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingFormat:@"/vid1.MOV"];
        [[user valueForKey:@"vFile"] writeToFile:path atomically:NO];*/
       
        NSURL *videoUrl = [user valueForKey:@"video"];//[NSURL fileURLWithPath:path];
        
        if (!_moviePlayer.fullscreen) {
            [self createAndConfigureMoviePlayer];
            
            MPMoviePlayerController *player = _moviePlayer;
            if (videoUrl) {
                player.contentURL = videoUrl;
                player.fullscreen = YES;
                [player prepareToPlay];
                [self resizeMovieView];
            }
        }
    }
}
- (void)resizeMovieView
{
    // Size the non-fullscreen movie view to 80% of the parent view.
    // This is for example purposes only to show a distinction between embedded and fullscreen modes.
    CGRect bounds = self.view.bounds;
    CGRect movieRect = CGRectInset(bounds,
                                   CGRectGetWidth(bounds) * 0,
                                   CGRectGetHeight(bounds) * 0);
    
    _moviePlayer.view.frame = movieRect;
}

-(IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)updateC:(id)sender {
    NSString * val = _updateCaption.text;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString * post = [NSString stringWithFormat:@"fbid=%@&caption=%@",[user valueForKey:@"fbid"], val];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://horizonapp.net/_scripts/updateCaption.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSArray *j = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
    
    if([j isEqual: @"updatedphoto"]) {
        /*NSMutableDictionary *m = [jsonArray[rows] mutableCopy];
        NSMutableArray * arr = [jsonArray mutableCopy];
        [m removeObjectForKey:@"caption"];
        [m setObject:val forKey:@"caption"];
        [arr replaceObjectAtIndex:(rows) withObject:m];
        jsonArray = [[NSMutableArray alloc] init];
        jsonArray = arr;*/
        
        NSDictionary *u;
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if([user valueForKey:@"photo"]) {
            u = [[NSDictionary alloc] initWithObjectsAndKeys:[user valueForKey:@"fbid"] , @"fbid",[user valueForKey:@"age"], @"age",[user valueForKey:@"gender"] , @"gender", [user valueForKey:@"pid"], @"pid", [user valueForKey:@"checktime"], @"checktime", val, @"caption", [user valueForKey:@"intent"], @"intent", [user valueForKey:@"photo"], @"photo", [user valueForKey:@"location"], @"location", [user valueForKey:@"pref"], @"pref", nil];
        } else {
            u = [[NSDictionary alloc] initWithObjectsAndKeys:[user valueForKey:@"fbid"] , @"fbid",[user valueForKey:@"age"], @"age",[user valueForKey:@"gender"] , @"gender", [user valueForKey:@"pid"], @"pid", [user valueForKey:@"checktime"], @"checktime", val, @"caption", [user valueForKey:@"intent"], @"intent", [user valueForKey:@"video"], @"video", [user valueForKey:@"vFile"], @"vFile", [user valueForKey:@"location"], @"location", [user valueForKey:@"pref"], @"pref", nil];
        }
        
        NSData *d = [NSKeyedArchiver archivedDataWithRootObject:u ];
        [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"user"];

        // [self.tableView reloadData];
        _updateCaption.text = @"";
        _updateCaption.placeholder = @"Update your caption";
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Try Again!"
                                                          message:@"Oops. Please try again!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
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

#pragma mark - Setters and Getters

- (UIWindow *)appWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = ([UIApplication sharedApplication].windows)[0];
    }
    
    return window;
}

#pragma mark - Create and Configure Movie Player

- (void)createAndConfigureMoviePlayer
{
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] init];
    
    if (player) {
        _moviePlayer = player;
        
        [self installMovieNotificationObservers];
        
        player.movieSourceType = MPMovieSourceTypeFile;
        player.shouldAutoplay = NO;
        player.allowsAirPlay = YES;
        
        [self.view addSubview:player.view];
    }
}

- (void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = _moviePlayer;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterFullscreen:)
                                                 name:MPMoviePlayerDidEnterFullscreenNotification
                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willExitFullscreen:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didExitFullscreen:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:player];
}

#pragma mark - Movie Notification Handlers

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    NSNumber *reason = [notification userInfo][MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason integerValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            break;
        case MPMovieFinishReasonPlaybackError:
            break;
        case MPMovieFinishReasonUserExited:
            [self removeMovieViewFromViewHierarchy];
            break;
        default:
            break;
    }
}

- (void)didEnterFullscreen:(NSNotification *)notification
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(layoutFullscreenOverlayForOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    // This needs to be called in the next run loop for it to work properly in iOS 6+
    [self performSelector:@selector(addFullscreenOverlayForCurrentInterfaceOrientation) withObject:nil afterDelay:0];
}

- (void)willExitFullscreen:(NSNotification*)notification
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [_moviePlayer.view removeFromSuperview];
    // Remove the fullscreen overlay view
    if (self.fullscreenOverlay) {
        [self.fullscreenOverlay removeFromSuperview];
        self.fullscreenOverlay = nil;
    }
}

- (void)didExitFullscreen:(NSNotification*)notification
{
    // Remove the fullscreen overlay view
    // This was called already in willExitFullscreen: but we'll call it again to ensure that it's removed.
    if (self.fullscreenOverlay) {
        [self.fullscreenOverlay removeFromSuperview];
        self.fullscreenOverlay = nil;
    }
}

#pragma mark - Fullscreen Overlay

- (void)addFullscreenOverlayForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Get the screen dimensions based on the orientation
    CGRect screenRect = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGRect temp = CGRectZero;
        temp.size.width = screenRect.size.height;
        temp.size.height = screenRect.size.width;
        screenRect = temp;
    }
    /*UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    aView.backgroundColor = [UIColor yellowColor];
    [_moviePlayer.view addSubview:aView];*/
    
    CGFloat screenWidth = CGRectGetWidth(screenRect);
    CGFloat screenHeight = CGRectGetHeight(screenRect);
    
    // Create a sample overlay view centered the fullscreen view
    CGRect overlayRect = CGRectMake(0,
                                    [[UIScreen mainScreen] bounds].size.height - 150,
                                    [[UIScreen mainScreen] bounds].size.width, 50);
    
    //UIView *fullscreenOverlay = [[UIView alloc] initWithFrame:overlayRect];
    
    //fullscreenOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UIFont * customFont = [UIFont fontWithName:@"Roboto" size:17]; //custom font
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString * text = [user valueForKey:@"caption"];
    if(![text isEqual:@""]) {
        UILabel *fullscreenOverlay = [[UILabel alloc]initWithFrame:overlayRect];
        fullscreenOverlay.text = text;
        fullscreenOverlay.font = customFont;
        fullscreenOverlay.numberOfLines = 1;
        fullscreenOverlay.adjustsFontSizeToFitWidth = YES;
        fullscreenOverlay.minimumScaleFactor = 10.0f/12.0f;
        fullscreenOverlay.clipsToBounds = YES;
        fullscreenOverlay.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        fullscreenOverlay.textColor = [UIColor whiteColor];
        fullscreenOverlay.textAlignment = NSTextAlignmentCenter;
        
        // Rotation and position the view based on the orientation
        // If your overlay isn't centered you'll need to adjust the CGAffineTransformTranslate
        // transform for PortraitUpsideDown, LandscapeLeft and LandscapeRight orientations.
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (interfaceOrientation) {
            case UIInterfaceOrientationPortrait:
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                transform = CGAffineTransformTranslate(transform,
                                                       -(screenWidth/2.0 - screenHeight/2.0),
                                                       -(screenWidth/2.0 - screenHeight/2.0));
                break;
            case UIInterfaceOrientationLandscapeRight:
                transform = CGAffineTransformRotate(transform, M_PI_2);
                transform = CGAffineTransformTranslate(transform,
                                                       screenWidth/2.0 - screenHeight/2.0,
                                                       screenWidth/2.0 - screenHeight/2.0);
                break;
            default:
                break;
        }
        
        [fullscreenOverlay setTransform:transform];
        
        [self.appWindow addSubview:fullscreenOverlay];
        self.fullscreenOverlay = fullscreenOverlay;
    }
}

- (void)addFullscreenOverlayForCurrentInterfaceOrientation
{
    [self addFullscreenOverlayForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)layoutFullscreenOverlay
{
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    // If there's an overlay view, so remove it and add it in the new orientation
    if (self.fullscreenOverlay) {
        [self.fullscreenOverlay removeFromSuperview];
        self.fullscreenOverlay = nil;
        
        [self addFullscreenOverlayForInterfaceOrientation:statusBarOrientation];
    }
}

#pragma mark - UIDeviceOrientationDidChangeNotification Handler

- (void)layoutFullscreenOverlayForOrientation:(UIDeviceOrientation)orientation
{
    // This needs to be called in the next run loop for it to work properly in iOS 6+
    [self performSelector:@selector(layoutFullscreenOverlay) withObject:nil afterDelay:0];
}

#pragma mark - Remove Movie Player

- (void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = _moviePlayer;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerDidEnterFullscreenNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:player];
}

- (void)deleteMoviePlayerAndNotificationObservers
{
    [self removeMovieNotificationHandlers];
    
    // Need to nil the contentURL in iOS 5 otherwise the AVPlayerItem, AVURLAsset,
    // and other related objects don't get released.
    _moviePlayer.contentURL = nil;
    _moviePlayer = nil;
}

- (void)removeMovieViewFromViewHierarchy
{
    MPMoviePlayerController *player = _moviePlayer;
    [player.view removeFromSuperview];
}

@end
