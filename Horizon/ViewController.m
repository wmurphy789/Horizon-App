//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    BOOL _viewDidAppear;
    BOOL _viewIsVisible;
    FBSDKLoginManager *logins;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    logins = [[FBSDKLoginManager alloc] init];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if([user valueForKey:@"pid"] && ![[user valueForKey:@"pid"] isEqual:@""]) {
        // Build spinner
        CGFloat width = ([UIScreen mainScreen].bounds.size.width / 2) - 35;
        CGFloat height = ([UIScreen mainScreen].bounds.size.height / 2) - 35;
        UIImageView *customActivityIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(width,height,70,70)];
        customActivityIndicator.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"], [UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"], [UIImage imageNamed:@"loader14.png"], [UIImage imageNamed:@"loader15.png"], [UIImage imageNamed:@"loader16.png"], [UIImage imageNamed:@"loader17.png"], [UIImage imageNamed:@"loader18.png"], [UIImage imageNamed:@"loader19.png"], [UIImage imageNamed:@"loader20.png"], nil];
        customActivityIndicator.animationDuration = 1.0; // in seconds
        [self.view addSubview:customActivityIndicator];
        [customActivityIndicator startAnimating];
        
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        
        NSString * post = [NSString stringWithFormat:@"fbid=%@&pid=%@&checktime=%@",[user valueForKey:@"fbid"], [user valueForKey:@"pid"], resultString];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://horizonapp.net/_scripts/checkLog.php"]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSArray * jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
        
        if(![jsonArray isEqual: @"nousers"]) {

            NSTimeInterval diff = 15 - ([currentTime timeIntervalSinceDate:[user valueForKey:@"checktime"]] / 60);
            //[self performSegueWithIdentifier:@"loggedIn" sender:self];
            if(diff > 0) {
                [self performSelector:@selector(loadAuthenticateViewController)
                       withObject:nil
                       afterDelay:1.0];
                [customActivityIndicator stopAnimating];
            } else {
                FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
                [login logOut];
                [customActivityIndicator stopAnimating];
            }
        } else {
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logOut];
            [customActivityIndicator stopAnimating];
        }
    } else {
        [logins logOut];
    }
    
    _login.layer.borderWidth = 1.0f;
    _login.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _login.layer.cornerRadius = 5;
    //self.loginButton.readPermissions = @[@"public_profile", @"user_friends"];
    //NSLog(@"user: %@",user);
}
- (IBAction)termsCo:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.terms = @"YES";
}

-(void)loadAuthenticateViewController
{
    [self performSegueWithIdentifier:@"loggedIn" sender:self];
}

// Login with facebook
- (IBAction)facebookLogin:(id)sender {
    CGFloat width = ([UIScreen mainScreen].bounds.size.width / 2) - 35;
    CGFloat height = ([UIScreen mainScreen].bounds.size.height / 2) - 35;
    UIImageView *customActivityIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(width,height,70,70)];
    customActivityIndicator.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"], [UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"], [UIImage imageNamed:@"loader14.png"], [UIImage imageNamed:@"loader15.png"], [UIImage imageNamed:@"loader16.png"], [UIImage imageNamed:@"loader17.png"], [UIImage imageNamed:@"loader18.png"], [UIImage imageNamed:@"loader19.png"], [UIImage imageNamed:@"loader20.png"], nil];
    customActivityIndicator.animationDuration = 1.0; // in seconds
    [self.view addSubview:customActivityIndicator];
    [customActivityIndicator startAnimating];
    
    [logins logInWithReadPermissions:@[@"public_profile", @"user_friends", @"user_birthday"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Unexpected login error: %@", error);
            NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
            NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
            [[[UIAlertView alloc] initWithTitle:alertTitle
                                        message:alertMessage
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            [customActivityIndicator stopAnimating];
        } else {
            // Get information from Facebook about user
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 // If there isn't an error
                 if (!error) {
                     // Get current time to save
                     NSDate *currentTime = [NSDate date];
                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                     [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                     NSString *resultString = [dateFormatter stringFromDate: currentTime];
                     
                     // Get age if facebook doesn't provide it from birthday and subtracting current time
                     int age = 0;
                     if(![result valueForKey:@"age"] || [result valueForKey:@"age"] == 0) {
                         NSString *birthDate = [result valueForKey:@"birthday"];
                         NSDate *todayDate = [NSDate date];
                         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                         [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                         int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:birthDate]];
                         int allDays = (((time/60)/60)/24);
                         int days = allDays%365;
                         int years = (allDays-days)/365;
                         age = years;
                     } else {
                         age = (int)[result valueForKey:@"age"];
                     }
                     
                     if(age < 18) {
                         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Problem!"
                                                                           message:@"Seems that you are not over the age of 18. If this is an error, please try again!"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
                         
                         [message show];
                     } else {
                         // Set up post string to be sent to PHP file
                         NSString * post = [NSString stringWithFormat:@"fbid=%@&email=%@&fname=%@&lname=%@&gender=%@&age=%d&birthday=%@&currentTime=%@&version=0.5",[result valueForKey:@"id"],[result valueForKey:@"email"],[result valueForKey:@"first_name"],[result valueForKey:@"last_name"],[result valueForKey:@"gender"],age,[result valueForKey:@"birthday"],resultString];
                         
                         NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
                         
                         NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
                         
                         NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                         [request setURL:[NSURL URLWithString:@"http://horizonapp.net/appscripts/checkUser.php"]];
                         
                         [request setHTTPMethod:@"POST"];
                         [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                         [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                         [request setHTTPBody:postData];
                         
                         NSURLResponse *response;
                         NSError *err;
                         NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                         NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
                         
                         [customActivityIndicator stopAnimating];
                         // If the user logged in for the first time
                         if([jsonArray[0] isEqual: @"firsttime"]) {
                             // Save NSData for user
                             NSDictionary *u = [[NSDictionary alloc] initWithObjectsAndKeys:jsonArray[1], @"fbid", @(age), @"age",[result valueForKey:@"gender"], @"gender", nil];
                    
                             NSData *data = [NSKeyedArchiver archivedDataWithRootObject:u ];
                             [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
                             
                             [self performSegueWithIdentifier:@"showDis" sender:self];
                         } else if([jsonArray[0] isEqual:@"checkedin"]) { // User logged in succesfully
                             // Save NSData for user
                             NSDictionary *u = [[NSDictionary alloc] initWithObjectsAndKeys:jsonArray[1], @"fbid", @(age), @"age",[result valueForKey:@"gender"], @"gender", nil];
                             
                             NSData *data = [NSKeyedArchiver archivedDataWithRootObject:u ];
                             [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
                             
                             [self performSegueWithIdentifier:@"showPref" sender:self];
                         } else {
                             // Log in unsuccesful show alert
                             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Logged Out!"
                                                                               message:@"You are logged out!"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil];
                             
                             [message show];
                         }
                     }
                 }
        }];
        }
    }];
}

// Login as a guest
- (IBAction)guest:(id)sender {
    [self performSegueWithIdentifier:@"newUser" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
