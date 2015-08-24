//
//  TableCell.m
//  Horizon
//
//  Created by william murphy on 6/25/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "feed.h"
#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *selfie;
@property (strong, nonatomic) IBOutlet UILabel *caption;
@property (strong, nonatomic) IBOutlet UILabel *about;
@property (weak, nonatomic) IBOutlet UIView *videoSuper;
@property (weak, nonatomic) IBOutlet UIImageView *intention;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UILabel *noONe;

@end
