//
//  ViewController.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface signup : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *birthdate;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *fname;
@property (weak, nonatomic) IBOutlet UITextField *lname;
@property (weak, nonatomic) IBOutlet UITextField *gender;

@property (strong, nonatomic) NSString *dateString;
@property (weak, nonatomic) IBOutlet UIButton *signUp;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) NSArray *pickerArray;

-(IBAction)textFieldReturn:(id)sender;
- (IBAction)closeDate:(id)sender;

@end

