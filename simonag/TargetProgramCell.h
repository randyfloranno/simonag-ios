//
//  TargetProgramCell.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/30/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetProgramCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *namaAktifitasLabel;
@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *realisasiLabel;
@property (strong, nonatomic) IBOutlet UILabel *kategoriLabel;
@property (strong, nonatomic) IBOutlet UILabel *realisasiPersenLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailBtn;

@end
