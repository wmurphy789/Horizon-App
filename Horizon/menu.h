//
//  ViewController.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface menu : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *about;
@property (weak, nonatomic) IBOutlet UIButton *Horizon;
@property (weak, nonatomic) IBOutlet UIButton *help;
@property (weak, nonatomic) IBOutlet UIButton *term;
@property (weak, nonatomic) IBOutlet UIButton *privacy;
@property (weak, nonatomic) IBOutlet UILabel *mLeft;
@property (weak, nonatomic) IBOutlet UIButton *exit;
@end

