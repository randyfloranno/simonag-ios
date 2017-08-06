//
//  EditProgramVC.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 8/6/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramPerusahaan.h"

@interface EditProgramVC : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) ProgramPerusahaan * _Nonnull programPerusahaan;

@end
