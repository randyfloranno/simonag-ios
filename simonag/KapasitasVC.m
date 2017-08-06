//
//  KapasitasVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/22/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "KapasitasVC.h"
#import "KCell.h"
#import "DataService.h"
#import "Dashboard.h"
#import "LoginVC.h"
#import "AddProgramVC.h"
#import "ProgressProgramVC.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>

@interface KapasitasVC () {
    NSString *id_role;
    NSString *id_tipe;
    NSString *id_perusahaanStr;
    NSNumber *id_perusahaanInt;
    NSString *authToken;
}

@property (strong, nonatomic) IBOutlet UITableView *kapasitasTableView;
@property (strong, nonatomic) IBOutlet UILabel *jumlahBUMNdanJumlahProgram;

@end

@implementation KapasitasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.kapasitasTableView.delegate = self;
    self.kapasitasTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:(BOOL)animated];
    
    id_role = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_role"];
    id_tipe = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_tipe"];
    id_perusahaanStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_perusahaan"];
    id_perusahaanInt = [NSNumber numberWithInteger: [id_perusahaanStr integerValue]];
    authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
        [self getDashboardWithToken];
        
        // End do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)getDashboardWithToken {
    //getDashboardWithToken
    [[DataService instance] getDashboardWithToken:[NSString stringWithFormat:@"/%@", authToken] :^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
        //NSLog(@"Data array baru neh: %@", dataArray);
        if ([[dataArray valueForKey:@"status"] isEqual: @"success"]) {
            //set array dashboard
            NSMutableArray *arrDashboard = [[NSMutableArray alloc]init];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.jumlahBUMNdanJumlahProgram.text = [NSString stringWithFormat:@"Jumlah BUMN: %@ | Jumlah Program: %@", [dataArray valueForKey:@"jumlah_perusahaan"], [dataArray valueForKey:@"jumlah_program"]];
            });
            
            for (NSDictionary *dshbrd in [dataArray valueForKey:@"perusahaan"]) {
                @autoreleasepool {
                    Dashboard *dashboard = [[Dashboard alloc]init];
                    
                    dashboard.id_perusahaan = [dshbrd objectForKey:@"id_perusahaan"];
                    dashboard.nama_perusahaan = [dshbrd objectForKey:@"nama_perusahaan"];
                    dashboard.keterangan = [dshbrd objectForKey:@"keterangan"];
                    dashboard.realisasi_persen = [dshbrd objectForKey:@"realisasi_persen"];
                    dashboard.kualitas_persen = [dshbrd objectForKey:@"kualitas_persen"];
                    dashboard.kapasitas_persen = [dshbrd objectForKey:@"kapasitas_persen"];
                    dashboard.komersial_persen = [dshbrd objectForKey:@"komersial_persen"];
                    dashboard.total_rupiah = [dshbrd objectForKey:@"total_rupiah"];
                    dashboard.total_aktivitas = [dshbrd objectForKey:@"total_aktivitas"];
                    dashboard.image = [dshbrd objectForKey:@"image"];
                    
                    [arrDashboard addObject:dashboard];
                }
            }
            dashboardList = arrDashboard;
            [self updateTableData];
        } else if ([[dataArray valueForKey:@"status"] isEqual: @"invalid-token"]) {
            NSLog(@"Invalid token");
            LoginVC *loginVC = [[LoginVC alloc] initWithNibName:nil bundle:nil];
            loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:loginVC animated:YES completion:nil];
        } else {
            NSLog(@"Err Message KualitasVC: %@", errMessage);
        }
    }];
}

- (void)updateTableData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.kapasitasTableView reloadData];
    });
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"dasboardList Count: %lu", (unsigned long)[dashboardList count]);
    return dashboardList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak KCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"KCell" bundle:nil] forCellReuseIdentifier:@"KCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"KCell"];
    }
    
    if([dashboardList count] > 0 && [dashboardList count] > indexPath.row){
        if([[dashboardList objectAtIndex:indexPath.row] valueForKey:@"kapasitas_persen"] != [NSNull null]) {
            cell.progressView.progress = [[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"kapasitas_persen"] floatValue] / 100;
        } else {
            cell.progressView.progress = 0.0;
        }
        
        if([[dashboardList objectAtIndex:indexPath.row] valueForKey:@"kapasitas_persen"] != [NSNull null]) {
            cell.percentageValue.hidden = NO;
            cell.percentageValue.text = [NSString stringWithFormat:@"%@%%", [[dashboardList objectAtIndex:indexPath.row] valueForKey:@"kapasitas_persen"]];
        } else {
            cell.percentageValue.hidden = YES;
        }
        
        // New Cover Image
        NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://simonag.owline.org/logo/%@",[[dashboardList objectAtIndex:indexPath.row]valueForKey:@"image"]]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url1];
        
        [cell.imageView setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"empty-icon"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           cell.imageView.image = [[DataService instance] compressImage:image];
                                       }
                                       failure:nil];
        // End New Cover Image
        
    } else {
        
        //Array is empty,handle as you needed
        
    }
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.kapasitasTableView setUserInteractionEnabled:YES];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        [tableView setUserInteractionEnabled:NO];
        
        AddProgramVC *addProgramVC = [[AddProgramVC alloc] initWithNibName:@"AddProgramVC" bundle:nil];
        ProgressProgramVC *progressProgramVC = [[ProgressProgramVC alloc] initWithNibName:@"ProgressProgramVC" bundle:nil];
        Dashboard *dashboard = [dashboardList objectAtIndex:indexPath.row];
        
        NSLog(@"ID Perusahaan: %@", id_perusahaanStr);
        NSLog(@"Dashboard ID Perusahaan: %@", dashboard.id_perusahaan);
        
        if([[NSString stringWithFormat:@"%@", dashboard.id_perusahaan] isEqualToString:id_perusahaanStr]) {
            NSLog(@"id perusahaan sama");
            [self.navigationController pushViewController:addProgramVC animated:YES];
        } else {
            NSLog(@"id perusahaan tidak sama");
            progressProgramVC.dashboard = dashboard;
            [self.navigationController pushViewController:progressProgramVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

@end
