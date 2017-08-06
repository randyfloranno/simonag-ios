//
//  AddProgramVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/31/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "AddProgramVC.h"
#import "LoginVC.h"
#import "ProgramPerusahaan.h"
#import "ProgressAktifitasVC.h"
#import "ProgramPerusahaanCell.h"
#import "DataService.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>

@interface AddProgramVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextField *namaProgramTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddProgramVC {
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
    self.title = @"Input Program";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"sidemenu-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
    //                                                                              style:UIBarButtonItemStylePlain
    //                                                                             target:self
    //                                                                             action:@selector(presentRightMenuViewController:)];
    
//    [self.view addSubview:({
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        button.frame = CGRectMake(0, 84, self.view.frame.size.width, 44);
//        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        [button setTitle:@"Push View Controller" forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
//        button;
//    })];
    
    self.namaProgramTextField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    
    // New Cover Image
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://simonag.owline.org/logo/%@", foto]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"empty-icon"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       self.imageView.image = [[DataService instance] compressImage:image];
                                   }
                                   failure:nil];
    // End New Cover Image
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
        [self getProgramPerusahaanWithToken];
        
        // End do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)getProgramPerusahaanWithToken {
    //getProgramPerusahaanWithToken
    [[DataService instance] getProgramPerusahaanWithToken:[NSString stringWithFormat:@"/%@/%@", authToken, id_perusahaanStr] :^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
        //NSLog(@"Data array baru neh: %@", dataArray);
        if ([[dataArray valueForKey:@"status"] isEqual: @"success"]) {
            //set array ProgramPerusahaan
            NSMutableArray *arrProgramPerusahaan = [[NSMutableArray alloc]init];
            
            for (NSDictionary *prgrm in [dataArray valueForKey:@"program"]) {
                @autoreleasepool {
                    ProgramPerusahaan *programPerusahaan = [[ProgramPerusahaan alloc]init];
                    
                    programPerusahaan.id_program = [prgrm objectForKey:@"id_program"];
                    programPerusahaan.nama_program = [prgrm objectForKey:@"nama_program"];
                    programPerusahaan.keterangan = [prgrm objectForKey:@"keterangan"];
                    programPerusahaan.realisasi_persen = [prgrm objectForKey:@"realisasi_persen"];
                    programPerusahaan.kualitas_persen = [prgrm objectForKey:@"kualitas_persen"];
                    programPerusahaan.kapasitas_persen = [prgrm objectForKey:@"kapasitas_persen"];
                    programPerusahaan.komersial_persen = [prgrm objectForKey:@"komersial_persen"];
                    
                    [arrProgramPerusahaan addObject:programPerusahaan];
                }
            }
            programPerusahaanList = arrProgramPerusahaan;
            [self updateTableData];
        } else if ([[dataArray valueForKey:@"status"] isEqual: @"invalid-token"]) {
            NSLog(@"Invalid token");
            LoginVC *loginVC = [[LoginVC alloc] initWithNibName:nil bundle:nil];
            loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:loginVC animated:YES completion:nil];
        } else {
            NSLog(@"Err Message ProgressProgramVC: %@", errMessage);
        }
    }];
}

- (void)updateTableData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"dasboardList Count: %lu", (unsigned long)[programPerusahaanList count]);
    return programPerusahaanList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak ProgramPerusahaanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProgramPerusahaanCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ProgramPerusahaanCell" bundle:nil] forCellReuseIdentifier:@"ProgramPerusahaanCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProgramPerusahaanCell"];
    }
    
    if([programPerusahaanList count] > 0 && [programPerusahaanList count] > indexPath.row){
        if([[programPerusahaanList objectAtIndex:indexPath.row] valueForKey:@"nama_program"] != [NSNull null]) {
            cell.namaProgramLabel.adjustsFontSizeToFitWidth = YES;
            cell.namaProgramLabel.minimumScaleFactor = 0.5;
            cell.namaProgramLabel.textColor = [UIColor orangeColor];
            cell.namaProgramLabel.text = [[programPerusahaanList objectAtIndex:indexPath.row] valueForKey:@"nama_program"];
        } else {
            cell.namaProgramLabel.text = @"";
        }
        
        // for Bottom Button
        cell.detailBtn.tag = indexPath.row;

        [cell.detailBtn addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        // end for Bottom Button
    } else {
        
        //Array is empty,handle as you needed
        
    }
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView setUserInteractionEnabled:YES];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        [tableView setUserInteractionEnabled:NO];
        
        ProgressAktifitasVC *progressAktifitasVC = [[ProgressAktifitasVC alloc] initWithNibName:@"ProgressAktifitasVC" bundle:nil];
        ProgramPerusahaan *programPerusahaan = [programPerusahaanList objectAtIndex:indexPath.row];
        
        progressAktifitasVC.programPerusahaan = programPerusahaan;
        [self.navigationController pushViewController:progressAktifitasVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(void)detailButtonClicked:(UIButton*)sender {
//    Review *review = [filteredReviewList objectAtIndex:sender.tag];
//    userIDTapped = review.userID;
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Detail Menu"
                                        message:@"Select method of input"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"View"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked View");
                                                ProgressAktifitasVC *progressAktifitasVC = [[ProgressAktifitasVC alloc] initWithNibName:@"ProgressAktifitasVC" bundle:nil];
                                                ProgramPerusahaan *programPerusahaan = [programPerusahaanList objectAtIndex:sender.tag];
                                                
                                                progressAktifitasVC.programPerusahaan = programPerusahaan;
                                                [self.navigationController pushViewController:progressAktifitasVC animated:YES];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Edit"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Edit");
                                                [[DataService instance] editProgramButtonClicked:sender arrayList:programPerusahaanList navigationController:self.navigationController];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Delete");
                                                ProgramPerusahaan *programPerusahaan = [programPerusahaanList objectAtIndex:sender.tag];
                                                [[DataService instance] deleteProgramWithIDProgram:programPerusahaan.id_program :^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
                                                    if ([[dataArray valueForKey:@"status"] isEqual: @"delete-success"]) {
                                                        [self getProgramPerusahaanWithToken];
                                                    } else if ([[dataArray valueForKey:@"status"] isEqual: @"invalid-token"]) {
                                                        NSLog(@"Invalid token");
                                                        LoginVC *loginVC = [[LoginVC alloc] initWithNibName:nil bundle:nil];
                                                        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                                        [self presentViewController:loginVC animated:YES completion:nil];
                                                    } else {
                                                        NSLog(@"Err Message KualitasVC: %@", errMessage);
                                                    }
                                                }];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action) {
                                                NSLog(@"Clicked Cancel");
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)addBtnTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
        [[DataService instance]postProgramWithNamaProgram:self.namaProgramTextField.text IDPerusahaan:id_perusahaanStr completion:^(BOOL Success) {
            if (Success) {
                NSLog(@"Post program Successfully");
                [self getProgramPerusahaanWithToken];
            } else {
                NSLog(@"Error post program");
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

//
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
