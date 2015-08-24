//
//  AppDelegate.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate () {
   NSTimer * timer;  
}
@end

@implementation AppDelegate

@synthesize selfie = _selfie;
@synthesize vSelfie = _vSelfie;
@synthesize user = _user;
@synthesize intent = _intent;
@synthesize pref = _pref;
@synthesize caption = _caption;
@synthesize pid = _pid;
@synthesize page = _page;
@synthesize vFile = _vFile;
@synthesize terms = _terms;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FBSDKLoginButton class];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    caption = @"";
    [GMSServices provideAPIKey:@"AIzaSyDjrNFKCYCyG0mydWU15MGhZlLq1tVlSN0"];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device token: %@",deviceToken);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //UIApplicationState state = [application applicationState];
    //if (state == UIApplicationStateActive) {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *u = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSTimeInterval diff = 15 - ([[NSDate date] timeIntervalSinceDate:[u valueForKey:@"checktime"]] / 60);
    // Only show the alert box if there has been less than 15 min
    if(diff > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You will be logged out in 1 minute!"
                                                        message:@"Do you want to stay logged in?"
                                                       delegate:self cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes",nil];
        [alert show];
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        NSDictionary *u = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        
        NSString * post = [NSString stringWithFormat:@"fbid=%@&currentTime=%@",[u valueForKey:@"fbid"], resultString];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"http://horizonapp.net/appscripts/updateTime.php"]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSArray * jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
        
        NSLog(@"j: %@",jsonArray);
        timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
        
    } else {
       timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(log) userInfo:nil repeats:NO];
    }
}

-(void)updateTime {
    NSDictionary *us;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *u = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDate *currentTime = [NSDate date];
    
    if([u valueForKey:@"photo"]) {
        us = [[NSDictionary alloc] initWithObjectsAndKeys:[u valueForKey:@"fbid"] , @"fbid",[u valueForKey:@"age"], @"age",[u valueForKey:@"gender"] , @"gender", [u valueForKey:@"pid"], @"pid", currentTime, @"checktime", [u valueForKey:@"caption"], @"caption", [u valueForKey:@"intent"], @"intent", [u valueForKey:@"photo"], @"photo", [u valueForKey:@"location"], @"location", [u valueForKey:@"pref"], @"pref", nil];
    } else {
        us = [[NSDictionary alloc] initWithObjectsAndKeys:[user valueForKey:@"fbid"] , @"fbid",[u valueForKey:@"age"], @"age",[u valueForKey:@"gender"] , @"gender", [u valueForKey:@"pid"], @"pid", currentTime, @"checktime", [u valueForKey:@"caption"], @"caption", [u valueForKey:@"intent"], @"intent", [u valueForKey:@"video"], @"video", [u valueForKey:@"vFile"], @"vFile", [u valueForKey:@"location"], @"location", [u valueForKey:@"pref"], @"pref", nil];
    }
    
    NSData *da = [NSKeyedArchiver archivedDataWithRootObject:us ];
    [[NSUserDefaults standardUserDefaults] setObject:da forKey:@"user"];
    
    // Make a notifcation show in 15min
    // New for iOS 8 - Register the notifications
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:840];
    //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
    localNotification.alertBody = @"You will be logged out in 1 minute!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)log {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.window makeKeyAndVisible];

    self.window.rootViewController = loginViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *u = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDate *currentTime = [NSDate date];
    if([u valueForKey:@"checktime"] && ![[u valueForKey:@"checktime"]  isEqual: @""]) {
        NSTimeInterval diff = 15 - ([currentTime timeIntervalSinceDate:[u valueForKey:@"checktime"]] / 60);
        
        if(diff <= 0) {
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            [login logOut];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.window makeKeyAndVisible];
            
            self.window.rootViewController = loginViewController;
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
