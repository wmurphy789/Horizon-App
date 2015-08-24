//
//  ViewController.h
//  Horizon
//
//  Created by william murphy on 6/13/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gender : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *male;
@property (weak, nonatomic) IBOutlet UIButton *female;


@end

