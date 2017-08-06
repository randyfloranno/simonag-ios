//
//  ProgressAktifitasVC.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/30/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgramPerusahaan;

@interface ProgressAktifitasVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *targetProgramList;
}

@property (nonatomic,strong) ProgramPerusahaan* _Nullable programPerusahaan;
@property (nonatomic, retain) NSString* _Nonnull dashboardImage;

@end
