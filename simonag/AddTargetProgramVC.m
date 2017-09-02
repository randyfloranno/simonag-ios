//
//  AddTargetProgramVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 8/6/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "AddTargetProgramVC.h"
#import <MBProgressHUD.h>

@interface AddTargetProgramVC () {
    NSString *id_role;
    NSString *id_tipe;
    NSString *id_perusahaanStr;
    NSNumber *id_perusahaanInt;
    NSString *authToken;
}
@property (strong, nonatomic) IBOutlet UITextField *namaAktifitasTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *kategoriPickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *dueDate;
@property (strong, nonatomic) IBOutlet UITextField *satuanTextField;
@property (strong, nonatomic) IBOutlet UITextField *targetTextField;
@property (strong, nonatomic) IBOutlet UITextField *targetRevenueTextField;

@end

@implementation AddTargetProgramVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:(BOOL)animated];
    
    id_role = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_role"];
    id_tipe = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_tipe"];
    id_perusahaanStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_perusahaan"];
    id_perusahaanInt = [NSNumber numberWithInteger: [id_perusahaanStr integerValue]];
    authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"];
}

- (IBAction)addBtnTapped:(id)sender {
    
}

@end
