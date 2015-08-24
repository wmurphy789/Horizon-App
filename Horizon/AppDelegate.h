//
//  AppDelegate.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate> {
    UIImage * selfie;
    NSString * vSelfie;
    NSString *intent;
    NSDictionary * user;
    NSString *pref;
    NSString *caption;
    NSString *pid;
    NSString *page;
    NSData * vFile;
    NSString *terms;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIImage *selfie;
@property (strong, nonatomic) NSData *vFile;
@property (strong, nonatomic) NSURL *vSelfie;
@property (strong, nonatomic) NSString *intent;
@property (strong, nonatomic) NSString *pref;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *page;
@property (strong, nonatomic) NSString *terms;
@property (strong, nonatomic) NSDictionary * user;

@end

