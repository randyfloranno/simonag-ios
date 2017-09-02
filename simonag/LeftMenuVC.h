//
//  LeftMenuVC.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 9/2/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView * _Nullable leftMenuTableView;
@property (weak, nonatomic) IBOutlet UIImageView * _Nullable profilePictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView * _Nullable coverImageView;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable emailLabel;

@end
