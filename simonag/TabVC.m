//
//  TabVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/23/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "TabVC.h"
#import <SWRevealViewController.h>
#import "DataService.h"
#import "LoginVC.h"
#import "Dashboard.h"
#import <SVProgressHUD.h>
#import <MBProgressHUD.h>

@interface TabVC () {
    NSString *id_role;
    NSString *id_tipe;
    NSString *id_perusahaanStr;
    NSNumber *id_perusahaanInt;
    NSString *authToken;
    NSString *nama;
    NSString *foto;
}

@end

@implementation TabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Pencapaian 3K";
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sidemenu-icon"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    id_role = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_role"];
    id_tipe = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_tipe"];
    id_perusahaanStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"id_perusahaan"];
    id_perusahaanInt = [NSNumber numberWithInteger: [id_perusahaanStr integerValue]];
    authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"];
    nama = [[NSUserDefaults standardUserDefaults] stringForKey:@"nama"];
    foto = [[NSUserDefaults standardUserDefaults] stringForKey:@"foto"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:(BOOL)animated];
    
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
                //tabbar
                KualitasVC *kualitasVC = [[KualitasVC alloc] init];
                KapasitasVC *kapasitasVC = [[KapasitasVC alloc] init];
                KomersialVC *komersialVC = [[KomersialVC alloc] init];
                
                NSArray *tabViewControllers = @[kualitasVC, kapasitasVC, komersialVC];
                
                [self setViewControllers:tabViewControllers];
                
                kualitasVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSString stringWithFormat:@"Kualitas %@%%", [[dashboardList objectAtIndex:0] valueForKey:@"realisasi_persen"]] image:nil tag:0];
                kapasitasVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSString stringWithFormat:@"Kapasitas %@%%", [[dashboardList objectAtIndex:1] valueForKey:@"realisasi_persen"]] image:nil tag:1];
                komersialVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSString stringWithFormat:@"Komersial %@%%", [[dashboardList objectAtIndex:2] valueForKey:@"realisasi_persen"]] image:nil tag:2];
            });
            
            for (NSDictionary *dshbrd in [dataArray valueForKey:@"kategori"]) {
                @autoreleasepool {
                    Dashboard *dashboard = [[Dashboard alloc]init];
                    
                    dashboard.realisasi_persen = [dshbrd objectForKey:@"realisasi_persen"];
                    
                    [arrDashboard addObject:dashboard];
                }
            }
            dashboardList = arrDashboard;
            //[self updateTableData];
        } else if ([[dataArray valueForKey:@"status"] isEqual: @"invalid-token"]) {
            LoginVC *loginVC = [[LoginVC alloc] initWithNibName:nil bundle:nil];
            loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:loginVC animated:YES completion:nil];
        } else {
            NSLog(@"Err Message TabVC: %@", errMessage);
        }
    }];
}

@end
