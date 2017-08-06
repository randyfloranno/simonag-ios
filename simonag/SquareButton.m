//
//  SquareButton.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/31/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "SquareButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation SquareButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.height / 8;
}

@end
