//
//  HomeViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "UIImage+FixOrientation.h"

@interface HomeViewController : UIViewController

@property (strong, atomic) ALAssetsLibrary* library;

@end
