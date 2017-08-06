//
//  AddProgramVC.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/31/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>

@class Dashboard;

@interface AddProgramVC : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSArray *programPerusahaanList;
}

@end
