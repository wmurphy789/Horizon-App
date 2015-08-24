//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "menu.h"
#import "AppDelegate.h"

@interface menu () {
    NSMutableData *_downloadedData;
    NSTimer * timer;
}

@end

@implementation menu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _about.layer.borderWidth = 1.0f;
    _about.layer.borderColor = [[UIColor whiteColor] CGColor];
    _about.layer.cornerRadius = 5;
    _term.layer.borderWidth = 1.0f;
    _term.layer.borderColor = [[UIColor whiteColor] CGColor];
    _term.layer.cornerRadius = 5;
    _privacy.layer.borderWidth = 1.0f;
    _privacy.layer.borderColor = [[UIColor whiteColor] CGColor];
    _privacy.layer.cornerRadius = 5;
    _Horizon.layer.borderWidth = 1.0f;
    _Horizon.layer.borderColor = [[UIColor whiteColor] CGColor];
    _Horizon.layer.cornerRadius = 5;
    _help.layer.borderWidth = 1.0f;
    _help.layer.borderColor = [[UIColor whiteColor] CGColor];
    _help.layer.cornerRadius = 5;
    _exit.layer.borderWidth = 1.0f;
    _exit.layer.borderColor = [[UIColor whiteColor] CGColor];
    _exit.layer.cornerRadius = 5;
    
    // Figure out time left
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if([user valueForKey:@"checktime"]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
}

-(void)updateTime {
    //Get the time left until the specified date
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSDate *currentTime = [NSDate date];
    NSTimeInterval diff = [currentTime timeIntervalSinceDate:[user valueForKey:@"checktime"]];
    NSInteger m = diff;
    NSInteger sec = 60 - (m % 60);
    NSInteger min = 14 - ((m / 60) % 60);
    if(min >= 0) {
        //Update the label with the remaining time
        _mLeft.text = [NSString stringWithFormat:@"%02ld:%02ld left", (long)min,(long)sec];
    } else {
        _mLeft.text = @"15:00 left";
    }
}

- (IBAction)leaveMenu:(id)sender {
    //[self dismissViewControllerAnimated:NO completion:nil];
    [timer invalidate];
    timer = nil;
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [self performSegueWithIdentifier:app.page sender:self];
}

- (IBAction)logout:(id)sender {
    [timer invalidate];
    timer = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString * post = [NSString stringWithFormat:@"fbid=%@",[user valueForKey:@"fbid"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://horizonapp.net/appscripts/checkOut.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSDictionary * u = [[NSDictionary alloc] initWithObjectsAndKeys:@"" , @"fbid",@"", @"age",@"" , @"gender", @"", @"pid", @"", @"checktime", @"", @"caption", @"", @"intent", @"", @"video", @"", @"pref", nil];
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:u ];
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"user"];
    
    [timer invalidate];
    timer = nil;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self performSegueWithIdentifier:@"backToMain" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
