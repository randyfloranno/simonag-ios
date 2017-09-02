//
//  RoundedUIImageView.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 9/2/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "RoundedUIImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedUIImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [[UIColor blueColor] CGColor];
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.clipsToBounds = YES;
}

@end
