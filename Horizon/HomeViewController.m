//
//  HomeViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewUtils.h"

@interface HomeViewController () {
    NSTimer * timer;
    NSInteger time;
}
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetMedium
                                                 position:CameraPositionBack
                                             videoEnabled:YES];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == CameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    // ----- camera buttons -------- //
    
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = 70.0f / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.flashButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    self.flashButton.tintColor = [UIColor whiteColor];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash.png"] forState:UIControlStateNormal];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    // Back Button
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(20, 10, 30.0f, 30.0f);
    _backButton.clipsToBounds = YES;
    [_backButton setImage:[UIImage imageNamed:@"back_menu.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    // Video count down label
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 50.0f)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    _timeLabel.textColor=[UIColor whiteColor];
    _timeLabel.text = @"00:00:00";
    _timeLabel.hidden = YES;
    [self.view addSubview:_timeLabel];
    
    // button to toggle camera positions
    self.switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.switchButton.frame = CGRectMake(0, 0, 29.0f + 20.0f, 22.0f + 20.0f);
    self.switchButton.tintColor = [UIColor whiteColor];
    [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Picture",@"Video"]];
    self.segmentedControl.frame = CGRectMake(12.0f, screenRect.size.height - 67.0f, 120.0f, 32.0f);
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.tintColor = [UIColor whiteColor];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)control {
    NSLog(@"Segment value changed!");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // stop the camera
    [self.camera stop];
}

/* camera button methods */

- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)backButtonPressed:(UIButton *)button {
    [self performSegueWithIdentifier:@"backIntent" sender:self];
}

- (void)flashButtonPressed:(UIButton *)button {
    
    if(self.camera.flash == CameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:CameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:CameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
     _library = [[ALAssetsLibrary alloc] init];
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        // capture
        [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
            if(!error) {
                
                // we should stop the camera, since we don't need it anymore. We will open a new vc.
                // this very important, otherwise you may experience memory crashes
                [camera stop];
                NSLog(@"image: %ld",(long)image.imageOrientation);
                if(image.imageOrientation != 1 && image.imageOrientation != 2 && image.imageOrientation != 3 && image.imageOrientation != 4) {
                    image = [UIImage imageWithCGImage:[image CGImage]
                                                scale:1.0
                                          orientation: UIImageOrientationUp];
                }
        
                app.selfie = image;
                [_library saveImage:image toAlbum:@"Horizon" withCompletionBlock:^(NSError *error) {
                    if (error!=nil) {
                        NSLog(@"Big error: %@", [error description]);
                    } else {
                        app.selfie = image;
                        NSLog(@"image saved");
                    }
                }];
                [self performSegueWithIdentifier:@"toSelfie" sender:self];
            }
            else {
                NSLog(@"An error has occured: %@", error);
            }
        } exactSeenImage:YES];
    }
    else {
        
        if(!self.camera.isRecording) {
            self.segmentedControl.hidden = YES;
            self.flashButton.hidden = YES;
            self.switchButton.hidden = YES;
            _backButton.hidden = YES;
            
            self.snapButton.layer.borderColor = [UIColor redColor].CGColor;
            self.snapButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
            
            _timeLabel.hidden = NO;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            // start recording
            //NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
            NSString * u = [NSString stringWithFormat:@"Movie-%@",[NSDate date]];
            NSURL *outputURL = [[[self applicationDocumentsDirectory]
                                 URLByAppendingPathComponent:u] URLByAppendingPathExtension:@"mov"];
            [self.camera startRecordingWithOutputUrl:outputURL];
        }
        else {
            [timer invalidate];
            timer = nil;
            // Build spinner
            CGFloat width = ([UIScreen mainScreen].bounds.size.width / 2) - 35;
            CGFloat height = ([UIScreen mainScreen].bounds.size.height / 2) - 35;
            UIImageView *customActivityIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(width,height,70,70)];
            customActivityIndicator.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"], [UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"], [UIImage imageNamed:@"loader14.png"], [UIImage imageNamed:@"loader15.png"], [UIImage imageNamed:@"loader16.png"], [UIImage imageNamed:@"loader17.png"], [UIImage imageNamed:@"loader18.png"], [UIImage imageNamed:@"loader19.png"], [UIImage imageNamed:@"loader20.png"], nil];
            customActivityIndicator.animationDuration = 1.0; // in seconds
            [self.view addSubview:customActivityIndicator];
            [customActivityIndicator startAnimating];
            
            _timeLabel.hidden = YES;
            self.segmentedControl.hidden = NO;
            self.flashButton.hidden = NO;
            self.switchButton.hidden = NO;
            _backButton.hidden = NO;
            
            self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
            self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
            
            [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
                [_library writeVideoAtPathToSavedPhotosAlbum:outputFileUrl completionBlock:^(NSURL *assetURL, NSError *error) {
                    NSData *videoData = [NSData dataWithContentsOfURL:outputFileUrl];
                    app.vFile = videoData;
                    app.vSelfie = outputFileUrl;
                    app.selfie = nil;
                    //error handling
                    if (error!=nil) {
                        NSLog(@"error: %@",error);
                        return;
                    }
                    
                    //add the asset to the custom photo album
                    [self addAssetURL:assetURL toAlbum:@"Horizon"];
                    [customActivityIndicator stopAnimating];
                    [self performSegueWithIdentifier:@"toSelfie" sender:self];
                }];
            }];
        }
    }
}

-(void)updateTime {
    //Get the time left until the specified date
    time++;
    if(time < 11) {
        NSString * str;
        if(time < 10) {
            str = [NSString stringWithFormat:@"0%ld",(long)time];
        } else {
            str = @"10";
        }
        //Update the label with the remaining time
        _timeLabel.text = [NSString stringWithFormat:@"00:00:%@", str];
    } else {
        // Build spinner
        CGFloat width = ([UIScreen mainScreen].bounds.size.width / 2) - 35;
        CGFloat height = ([UIScreen mainScreen].bounds.size.height / 2) - 35;
        UIImageView *customActivityIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(width,height,70,70)];
        customActivityIndicator.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"], [UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"], [UIImage imageNamed:@"loader14.png"], [UIImage imageNamed:@"loader15.png"], [UIImage imageNamed:@"loader16.png"], [UIImage imageNamed:@"loader17.png"], [UIImage imageNamed:@"loader18.png"], [UIImage imageNamed:@"loader19.png"], [UIImage imageNamed:@"loader20.png"], nil];
        customActivityIndicator.animationDuration = 1.0; // in seconds
        [self.view addSubview:customActivityIndicator];
        [customActivityIndicator startAnimating];
        
        [timer invalidate];
        timer = nil;
        AppDelegate * app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        _timeLabel.hidden = YES;
        self.segmentedControl.hidden = NO;
        self.flashButton.hidden = NO;
        self.switchButton.hidden = NO;
        _backButton.hidden = NO;
        
        self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        
        [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error) {
            [_library writeVideoAtPathToSavedPhotosAlbum:outputFileUrl completionBlock:^(NSURL *assetURL, NSError *error) {
                NSData *videoData = [NSData dataWithContentsOfURL:outputFileUrl];
                app.vFile = videoData;
                app.vSelfie = outputFileUrl;
                //error handling
                if (error!=nil) {
                    NSLog(@"error: %@",error);
                    return;
                }
                
                //add the asset to the custom photo album
                [self addAssetURL:assetURL toAlbum:@"Horizon"];
                [customActivityIndicator stopAnimating];
                [self performSegueWithIdentifier:@"toSelfie" sender:self];
            }];
        }];
    }
}

- (void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName
{
    [_library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([albumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
            //If album found
            [_library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                //add asset to album
                NSLog(@"added: %@",asset);
                [group addAsset:asset];
            } failureBlock:nil];
        }
        else {
            //if album not found create an album
            [_library addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group)     {
                //[self addAssetURL:assetURL toAlbum:albumName];
                NSLog(@"not saved");
            } failureBlock:nil];
        }
    } failureBlock: nil];
}

/* other lifecycle methods */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.camera.view.frame = CGRectMake(0, (screenRect.size.height - screenRect.size.width) /2, screenRect.size.width, screenRect.size.width);//self.view.contentBounds;
    
    self.snapButton.center = CGPointMake(screenRect.size.width/2.0f, screenRect.size.height/2.0f);
    self.snapButton.bottom = screenRect.size.height - 15;
    
    self.flashButton.center = CGPointMake(screenRect.size.width/2.0f, screenRect.size.height/2.0f);
    self.flashButton.top = 5.0f;
    
    self.switchButton.top = 5.0f;
    self.switchButton.right = screenRect.size.width - 5.0f;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
