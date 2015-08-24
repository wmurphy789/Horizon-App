//
//  ViewController.m
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import "map.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

@interface map () {
    GMSPlacePicker *_placePicker;
    CLLocationManager *locationManager;
    GMSPlacesClient *_placesClient;
    BOOL firstLocationUpdate_;
    GMSPlace *p;
    NSMutableArray * name;
    NSMutableArray * coords;
    NSMutableArray * pId;
    NSString * n;
    NSString *pid;
    CLLocationCoordinate2D zoomLocation;
    UIImageView *customActivityIndicator;
}

@end

@implementation map

- (void)viewDidLoad {
    [super viewDidLoad];
    _placesClient = [[GMSPlacesClient alloc] init];
    name = [[NSMutableArray alloc] init];
    pId = [[NSMutableArray alloc] init];
    coords = [[NSMutableArray alloc] init];
    
    _yes.layer.borderWidth = 1.0f;
    _yes.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _yes.layer.cornerRadius = 5;
    _no.layer.borderWidth = 1.0f;
    _no.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _no.layer.cornerRadius = 5;
    _no.hidden = YES;
    _yes.hidden = YES;
    _checkin.layer.borderWidth = 1.0f;
    _checkin.layer.borderColor = [[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _checkin.layer.cornerRadius = 5;
    
    // Build spinner
    CGFloat width = ([UIScreen mainScreen].bounds.size.width / 2) - 35;
    CGFloat height = ([UIScreen mainScreen].bounds.size.height / 2) + 55;
    customActivityIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(width,height,70,70)];
    customActivityIndicator.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"], [UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"], [UIImage imageNamed:@"loader14.png"], [UIImage imageNamed:@"loader15.png"], [UIImage imageNamed:@"loader16.png"], [UIImage imageNamed:@"loader17.png"], [UIImage imageNamed:@"loader18.png"], [UIImage imageNamed:@"loader19.png"], [UIImage imageNamed:@"loader20.png"], nil];
    customActivityIndicator.animationDuration = 1.0; // in seconds
    [self.view addSubview:customActivityIndicator];
    [customActivityIndicator startAnimating];
    
    // Connect data
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
    
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        //NSLog(@"places: %@",[placeLikelihoodList likelihoods]);
        int count = (int)[[placeLikelihoodList likelihoods] count];
        NSArray *pl = [NSArray arrayWithObjects:@"airport",@"amusement_park",@"aquarium",@"bakery",@"bank",@"bar",@"beauty_salon",@"bicycle_store",@"book_store",@"bowling_alley",@"bus_station",@"cafe",@"campground",@"car_dealer",@"casino",@"church",@"clothing_store",@"convenience_store",@"department_store",@"electronic_store",@"establishment",@"florist",@"food",@"furniture_store",@"grocery_or_supermarket",@"gym",@"hair_care",@"hardware_store",@"health",@"hindu_temple",@"home_goods_store",@"laundry",@"library",@"liquor_store",@"lodging",@"movie_theater",@"museum",@"night_club",@"park",@"pet_store",@"pharmacy",@"place_of_worship",@"restaurant",@"rv_park",@"school",@"shoe_store",@"shopping_mall",@"spa",@"stadium",@"store",@"subway_station",@"synagogue",@"train_station",@"university",@"zoo", nil];
        /*
        if([[placeLikelihoodList likelihoods] count] < 10) {
            count = (int)[[placeLikelihoodList likelihoods] count];
        } else {
            count = 10;
        }*/
        int temp = 0;
        for(int i = 0; i < count; i ++) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] objectAtIndex:i] place];
            for(int x = 0; x < [place.types count]; x++) {
                if([pl indexOfObject:place.types[x]] && temp < 11) {
                    [name addObject:place.name];
                    [pId addObject:place.placeID];
                    [coords addObject:[[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude]];
                    temp++;
                    break;
                }
            }
        }
        [_picker reloadAllComponents];
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                //NSLog(@"place: %@",place);
                n = name[0];
                pid = pId[0];
                CLLocation *co = coords[0];
                CLLocationCoordinate2D c = CLLocationCoordinate2DMake(co.coordinate.latitude, co.coordinate.longitude);
                zoomLocation = c;
                _guess.text = [NSString stringWithFormat:@"We're gonna guess you're at %@. Boom. We nailed it, didn't we?",place.name];
                _guess.hidden = NO;
                _yes.hidden = NO;
                _no.hidden = NO;
                [customActivityIndicator stopAnimating];
            }
        }
    }];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    
    //_mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.camera = camera;
    _mapView.settings.compassButton = NO;
    _mapView.settings.myLocationButton = YES;
    
    // Listen to the myLocation property of GMSMapView.
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.mapView.delegate = self;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        _mapView.myLocationEnabled = YES;
    });
    
}

- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
     }];
}

-(void)saveUser {
    
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSDictionary *user = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
   
    // Set PID
    app.pid = pid;
    
    NSDictionary *u;
    if(app.selfie) {
       u = [[NSDictionary alloc] initWithObjectsAndKeys:[user valueForKey:@"fbid"] , @"fbid",[user valueForKey:@"age"], @"age",[user valueForKey:@"gender"] , @"gender", pid, @"pid", currentTime, @"checktime", app.caption, @"caption", app.intent, @"intent", app.selfie, @"photo", n, @"location", app.pref, @"pref", nil];
    } else {
       u = [[NSDictionary alloc] initWithObjectsAndKeys:[user valueForKey:@"fbid"] , @"fbid",[user valueForKey:@"age"], @"age",[user valueForKey:@"gender"] , @"gender", pid, @"pid", currentTime, @"checktime", app.caption, @"caption", app.intent, @"intent", app.vSelfie, @"video", app.vFile, @"vFile", n, @"location", app.pref, @"pref", nil];
    }
 
    NSData *d = [NSKeyedArchiver archivedDataWithRootObject:u ];
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"user"];
    
    //Image
    NSString *imageString;
    NSData *imageData;
    if(app.selfie) {
        imageString = [NSString stringWithFormat:@"Content-Disposition: form-data;    name=\"userfile\"; filename=\"%@\"\r\n", [NSString stringWithFormat:@"%@.jpg", [user valueForKey:@"fbid"]]];
    
        imageData = UIImageJPEGRepresentation(app.selfie, 0.8);
    } else {
        imageString = [NSString stringWithFormat:@"Content-Disposition: form-data;    name=\"userfile\"; filename=\"%@\"\r\n", [NSString stringWithFormat:@"%@.mov", [user valueForKey:@"fbid"]]];
        
        imageData = app.vFile;//[NSData dataWithContentsOfFile:app.vSelfie];
    }
    NSString *urlString = @"http://horizonapp.net/_scripts/checkin.php";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"--------------------------    -14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;     boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // FBID
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"fbid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[user valueForKey:@"fbid"] dataUsingEncoding:NSUTF8StringEncoding]];
    // Type of data
    if(app.selfie) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name= \"dataType\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"image"] dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name= \"dataType\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"video"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    // AGE
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"age\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"%@",[user valueForKey:@"age"]] dataUsingEncoding:NSUTF8StringEncoding]];
    // GENDER
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"gender\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"male" dataUsingEncoding:NSUTF8StringEncoding]];
    // Pref
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"preference\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[app.pref dataUsingEncoding:NSUTF8StringEncoding]];
    // Intent
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"intent\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[app.intent dataUsingEncoding:NSUTF8StringEncoding]];
    // Photpos
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"photopos\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"0" dataUsingEncoding:NSUTF8StringEncoding]];
    // Caption
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"caption\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[app.caption dataUsingEncoding:NSUTF8StringEncoding]];
    // Timestamp
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"timestamp\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[resultString dataUsingEncoding:NSUTF8StringEncoding]];
    // PID
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"pid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[pid dataUsingEncoding:NSUTF8StringEncoding]];
    // Place
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"place\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[n dataUsingEncoding:NSUTF8StringEncoding]];
    // Lat
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"lat\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[@(zoomLocation.latitude) stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
    // long
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name= \"long\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[@(zoomLocation.longitude) stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]     dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:imageString ]     dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-    stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]     dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if([jsonArray  isEqual: @"checkedin"]) {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:840];
            //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
            localNotification.alertBody = @"You will be logged out in 1 minute!";
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            [customActivityIndicator stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"showFeed" sender:self];
            });
        } else if([jsonArray isEqual:@"alreadythere"]) {
            [customActivityIndicator stopAnimating];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Logged In!"
                                                              message:@"You are already logged at this location!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
        } else {
            [customActivityIndicator stopAnimating];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Try Again!"
                                                              message:@"Oops. Please try again!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
        }
    }];
}
// User clicks yes
- (IBAction)yes:(id)sender {
    _yes.hidden = YES;
    _no.hidden = YES;
    _checkin.hidden = NO;
}
// User clicks no
- (IBAction)no:(id)sender {
    _picker.hidden = NO;
    _guess.hidden = YES;
    _no.hidden = YES;
    _yes.hidden = YES;
    _checkin.hidden = NO;
}

- (void)dealloc {
    [_mapView removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}
- (IBAction)check_in:(id)sender {
    // Build spinner
    [customActivityIndicator startAnimating];
    [self saveUser];
}
- (IBAction)toMenu:(id)sender {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    app.page = @"location";
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange {
    // Make links clickable.
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [name count];
}

// The data to return for the row and component (column) that's being passed in
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = name[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:99.0/255.0 green:133.0/255.0 blue:192.0/255.0 alpha:1]}];
    
    return attString;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    n = name[row];
    pid = pId[row];
    CLLocation *co = coords[row];
    CLLocationCoordinate2D c = CLLocationCoordinate2DMake(co.coordinate.latitude, co.coordinate.longitude);
    zoomLocation = c;
}

@end
