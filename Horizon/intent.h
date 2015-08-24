//
//  ViewController.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@interface intent : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *friendly;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *romantic;
@property (weak, nonatomic) IBOutlet UIButton *male;
@property (weak, nonatomic) IBOutlet UIButton *female;
@property (weak, nonatomic) IBOutlet UILabel *interested;
@property (weak, nonatomic) IBOutlet UIImageView *mIcon;
@property (weak, nonatomic) IBOutlet UIImageView *fIcon;
@property (weak, nonatomic) IBOutlet UIImageView *camera;
@property (weak, nonatomic) IBOutlet UIImageView *friend;
@property (weak, nonatomic) IBOutlet UIImageView *heart;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, strong) UISegmentedControl *myControl;
@property (weak, nonatomic) IBOutlet UIButton *selfie;
@property (strong, atomic) ALAssetsLibrary* library;
@property (nonatomic, strong) UIImagePickerController * imagePickerController;;

@end

