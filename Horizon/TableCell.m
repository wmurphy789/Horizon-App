//
//  TableCell.m
//  Horizon
//
//  Created by william murphy on 6/25/15.
//  Copyright (c) 2015 william murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableCell.h"

@implementation TableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
    }
    return self;
}

-(void)awakeFromNib {
    
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
