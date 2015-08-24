//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "terms.h"
#import "AppDelegate.h"

@interface terms () {

}

@end

@implementation terms

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    _accept.layer.borderWidth = 1.0f;
    _accept.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _accept.layer.cornerRadius = 5;
    
    _accept.hidden = NO;
    if([app.terms  isEqual: @"YES"]) {
        _accept.hidden = YES;
    }
}
- (IBAction)acceptterms:(id)sender {
    [self performSegueWithIdentifier:@"showIntent" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
