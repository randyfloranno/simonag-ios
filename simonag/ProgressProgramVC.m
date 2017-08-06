//
//  ProgressProgramVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/30/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "ProgressProgramVC.h"
#import "Dashboard.h"
#import "LoginVC.h"
#import "ProgramPerusahaan.h"
#import "ProgressAktifitasVC.h"
#import "ProgramPerusahaanCell.h"
#import "DataService.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>

@interface ProgressProgramVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProgressProgramVC {
    NSString *id_role;
    NSString *id_tipe;
    NSString *id_perusahaanStr;
    NSNumber *id_perusahaanInt;
    NSString *authToken;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // New Cover Image
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://simonag.owline.org/logo/%@",self.dashboard.image]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    
    [self.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"empty-icon"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       self.imageView.image = [[DataService instance] compressImage:image];
                                   }
                                   failure:nil];
    // End New Cover Image
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
        
        [self getProgramPerusahaanWithToken];
        
        // End do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)getProgramPerusahaanWithToken {
    //getProgramPerusahaanWithToken
    [[DataService instance] getProgramPerusahaanWithToken:[NSString stringWithFormat:@"/%@/%@", authToken, self.dashboard.id_perusahaan] :^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
        //NSLog(@"Data array baru neh: %@", dataArray);
        if ([[dataArray valueForKey:@"status"] isEqual: @"success"]) {
            //set array dashboard
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
    
    cell.detailBtn.hidden = YES;
    
    if([programPerusahaanList count] > 0 && [programPerusahaanList count] > indexPath.row){
        if([[programPerusahaanList objectAtIndex:indexPath.row] valueForKey:@"nama_program"] != [NSNull null]) {
            cell.namaProgramLabel.adjustsFontSizeToFitWidth = YES;
            cell.namaProgramLabel.minimumScaleFactor = 0.5;
            cell.namaProgramLabel.textColor = [UIColor orangeColor];
            cell.namaProgramLabel.text = [[programPerusahaanList objectAtIndex:indexPath.row] valueForKey:@"nama_program"];
        } else {
            cell.namaProgramLabel.text = @"";
        }
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
        progressAktifitasVC.dashboardImage = self.dashboard.image;
        
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

@end
