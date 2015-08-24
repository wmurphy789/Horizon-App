//
//  ViewController.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface map : UIViewController<UITextViewDelegate, CLLocationManagerDelegate, GMSMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *guess;
@property (weak, nonatomic) IBOutlet UIButton *yes;
@property (weak, nonatomic) IBOutlet UIButton *no;
@property (weak, nonatomic) IBOutlet UIButton *checkin;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

