//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "signup.h"
#import "AppDelegate.h"

@interface signup () {
    int age;
}
@end

@implementation signup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _signUp.layer.borderWidth = 1.0f;
    _signUp.layer.borderColor = [[UIColor whiteColor] CGColor];
    _signUp.layer.cornerRadius = 5;
    
    self.pickerArray  = [[NSArray alloc] initWithObjects:@"Female", @"Male", nil];
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
    [self attachPickerToTextField:_gender :self.picker];
}

- (void)attachPickerToTextField: (UITextField*) textField :(UIPickerView*) picker{
    picker.delegate = self;
    picker.dataSource = self;
    
    textField.delegate = self;
    textField.inputView = picker;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == _birthdate ) {
        _datePicker.hidden = NO;
        return NO;
    } else {
        return YES; //show keyboard
    }
}

// Birthday
- (IBAction)datePicked:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    _dateString = [dateFormatter stringFromDate:self.datePicker.date];
    _birthdate.text = _dateString;
    _datePicker.hidden = YES;
    
    // Get Age of user
    NSDate *todayDate = [NSDate date];
    int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:_dateString]];
    int allDays = (((time/60)/60)/24);
    int days = allDays%365;
    int years = (allDays-days)/365;
    age = years;
}

// Close
- (IBAction)closeDate:(id)sender {
    _datePicker.hidden = YES;
}

- (IBAction)signUp:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.terms = @"NO";
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:_email.text] == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid!" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSString * post = [NSString stringWithFormat:@"email=%@&fname=%@&lname=%@&gender=%@&age=%d&birthday=%@&currentTime=%@&version=0.5",_email.text,_fname.text,_lname.text,_gender.text,age,_birthdate.text,resultString];

    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding                            allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://horizonapp.net/appscripts/checkGuest.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&err];
   
    // Save NSData for user
    if(jsonArray) {
        NSDictionary *u = [[NSDictionary alloc] initWithObjectsAndKeys:jsonArray, @"fbid", @(age), @"age",_gender.text, @"gender", nil];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:u ];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user"];
        
        [self performSegueWithIdentifier:@"showClaim" sender:self];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Try Again!"
                                                          message:@"Oops. Please try again!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

-(IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard delegate stuff

// let tapping on the background (off the input field) close the thing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_gender resignFirstResponder];
}

#pragma mark - Picker delegate stuff

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        return self.pickerArray.count;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        return [self.pickerArray objectAtIndex:row];
    }
    
    return @"???";
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if (pickerView == self.picker){
        _gender.text = [self.pickerArray objectAtIndex:row];
    }
    
}

@end
