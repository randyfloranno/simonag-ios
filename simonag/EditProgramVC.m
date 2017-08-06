//
//  EditProgramVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 8/6/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "EditProgramVC.h"
#import <MBProgressHUD.h>
#import "DataService.h"

@interface EditProgramVC ()
@property (strong, nonatomic) IBOutlet UITextField *namaProgramTextField;

@end

@implementation EditProgramVC {
    NSString *id_role;
    NSString *id_tipe;
    NSString *id_perusahaanStr;
    NSNumber *id_perusahaanInt;
    NSString *authToken;
    NSString *nama;
    NSString *foto;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.namaProgramTextField.delegate = self;
    
    self.namaProgramTextField.text = self.programPerusahaan.nama_program;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:(BOOL)animated];
    
    id_role = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_role"];
    id_tipe = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_tipe"];
    id_perusahaanStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_perusahaan"];
    id_perusahaanInt = [NSNumber numberWithInteger: [id_perusahaanStr integerValue]];
    authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"];
    nama = [[NSUserDefaults standardUserDefaults] stringForKey:@"nama"];
    foto = [[NSUserDefaults standardUserDefaults] stringForKey:@"foto"];
}

- (IBAction)addBtnTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
        [[DataService instance]editProgramWithNamaProgram:self.namaProgramTextField.text IDPerusahaan:id_perusahaanStr IDProgram:self.programPerusahaan.id_program completion:^(BOOL Success) {
            if (Success) {
                NSLog(@"Edit program Successfully");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                NSLog(@"Error edit program");
            }
        }];
        
        // End do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.namaProgramTextField.text = @"";
            [self.namaProgramTextField resignFirstResponder];
            
        });
    });
}

@end
