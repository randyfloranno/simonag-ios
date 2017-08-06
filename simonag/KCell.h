//
//  KCell.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/26/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <LDProgressView.h>

@interface KCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *percentageValue;


@end
