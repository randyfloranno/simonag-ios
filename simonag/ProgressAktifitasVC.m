//
//  ProgressAktifitasVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/30/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "ProgressAktifitasVC.h"
#import "ProgramPerusahaan.h"
#import "TargetProgram.h"
#import "DataService.h"
#import "LoginVC.h"
#import "TargetProgramCell.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>

@interface ProgressAktifitasVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *programLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProgressAktifitasVC {
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.programLabel.text = self.programPerusahaan.nama_program;
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
    
    if(self.dashboardImage != nil) {
        // New Cover Image
        NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://simonag.owline.org/logo/%@",self.dashboardImage]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        
        [self.imageView setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"empty-icon"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           self.imageView.image = [[DataService instance] compressImage:image];
                                       }
                                       failure:nil];
        // End New Cover Image
    } else {
        // New Cover Image
        NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://simonag.owline.org/logo/%@",foto]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        
        [self.imageView setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"empty-icon"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           self.imageView.image = [[DataService instance] compressImage:image];
                                       }
                                       failure:nil];
        // End New Cover Image
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
        [self getTargetProgramWithToken];
        
        // End do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)getTargetProgramWithToken {
    //getTargetProgramWithToken
    [[DataService instance] getTargetProgramWithToken:[NSString stringWithFormat:@"/%@/%@", authToken, self.programPerusahaan.id_program] :^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
        //NSLog(@"Data array baru neh: %@", dataArray);
        if ([[dataArray valueForKey:@"status"] isEqual: @"success"]) {
            //set array dashboard
            NSMutableArray *arrTargetProgram = [[NSMutableArray alloc]init];
            
            for (NSDictionary *trgt in [dataArray valueForKey:@"target"]) {
                @autoreleasepool {
                    TargetProgram *targetProgram = [[TargetProgram alloc]init];
                    
                    targetProgram.id_target = [trgt objectForKey:@"id_target"];
                    targetProgram.nama_aktivitas = [trgt objectForKey:@"nama_aktivitas"];
                    targetProgram.keterangan = [trgt objectForKey:@"keterangan"];
                    targetProgram.due_date = [trgt objectForKey:@"due_date"];
                    targetProgram.realisasi_persen = [trgt objectForKey:@"realisasi_persen"];
                    targetProgram.target_nilai = [trgt objectForKey:@"target_nilai"];
                    targetProgram.realisasi = [trgt objectForKey:@"realisasi"];
                    
                    targetProgram.revenue_target_nilai = [trgt objectForKey:@"revenue_target_nilai"];
                    targetProgram.realisasi_revenue = [trgt objectForKey:@"realisasi_revenue"];
                    targetProgram.koordinat = [trgt objectForKey:@"koordinat"];
                    targetProgram.id_kategori = [trgt objectForKey:@"id_kategori"];
                    targetProgram.nama_kategori = [trgt objectForKey:@"nama_kategori"];
                    targetProgram.status_revenue = [trgt objectForKey:@"status_revenue"];
                    targetProgram.id_satuan = [trgt objectForKey:@"id_satuan"];
                    targetProgram.nama_satuan = [trgt objectForKey:@"nama_satuan"];
                    
                    [arrTargetProgram addObject:targetProgram];
                }
            }
            targetProgramList = arrTargetProgram;
            [self updateTableData];
        } else if ([[dataArray valueForKey:@"status"] isEqual: @"invalid-token"]) {
            NSLog(@"Invalid token");
            LoginVC *loginVC = [[LoginVC alloc] initWithNibName:nil bundle:nil];
            loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:loginVC animated:YES completion:nil];
        } else {
            NSLog(@"Err Message ProgressAktifitasVC: %@", errMessage);
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
    return targetProgramList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak TargetProgramCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TargetProgramCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"TargetProgramCell" bundle:nil] forCellReuseIdentifier:@"TargetProgramCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"TargetProgramCell"];
    }
    
    cell.detailBtn.hidden = YES;
    
    if([targetProgramList count] > 0 && [targetProgramList count] > indexPath.row){
        if([[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"nama_aktivitas"] != [NSNull null]) {
            cell.namaAktifitasLabel.text = [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"nama_aktivitas"];
        } else {
            cell.namaAktifitasLabel.text = @"";
        }
        if([[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"due_date"] != [NSNull null]) {
            cell.dueDateLabel.text = [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"due_date"];
        } else {
            cell.dueDateLabel.text = @"";
        }
        if([[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"realisasi"] != [NSNull null] && [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"target_nilai"] != [NSNull null] && [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"nama_satuan"] != [NSNull null]) {
            cell.realisasiLabel.text = [NSString stringWithFormat:@"%@/%@ (%@)", [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"realisasi"], [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"target_nilai"], [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"nama_satuan"]];
        } else {
            cell.realisasiLabel.text = @"";
        }
        if([[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"nama_kategori"] != [NSNull null]) {
            cell.kategoriLabel.text = [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"nama_kategori"];
        } else {
            cell.kategoriLabel.text = @"";
        }
        if([[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"realisasi_persen"] != [NSNull null]) {
            cell.realisasiPersenLabel.text = [NSString stringWithFormat:@"%@%%", [[targetProgramList objectAtIndex:indexPath.row] valueForKey:@"realisasi_persen"]];
        } else {
            cell.realisasiPersenLabel.text = @"";
        }
    } else {
        
        //Array is empty,handle as you needed
        
    }
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView setUserInteractionEnabled:YES];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

@end
