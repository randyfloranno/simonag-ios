//
//  LeftMenuVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 9/2/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "LeftMenuVC.h"
#import <SWRevealViewController.h>
#import "AddProgramVC.h"
#import "TabVC.h"
#import "LoginVC.h"
#import "DataService.h"
#import <UIImageView+AFNetworking.h>

@interface LeftMenuVC () {
    NSInteger _presentedRow;
    NSString *id_role;
    NSString *id_tipe;
    NSString *id_perusahaanStr;
    NSNumber *id_perusahaanInt;
    NSString *authToken;
    NSString *nama;
    NSString *foto;
    NSString *usernameEmail;
}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation LeftMenuVC

@synthesize leftMenuTableView = _leftMenuTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Simonag";
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
    usernameEmail = [[NSUserDefaults standardUserDefaults] stringForKey:@"usernameEmail"];
    
    self.usernameLabel.text = nama;
    self.emailLabel.text = usernameEmail;
    
    // New Cover Image
    NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"http://simonag.owline.org/logo/%@", foto]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url1];
    
    [self.profilePictureImageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"empty-icon"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       self.profilePictureImageView.image = [[DataService instance] compressImage:image];
                                   }
                                   failure:nil];
    // End New Cover Image
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.leftMenuTableView reloadData];
    });
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSString *text = nil;
    if (row == 0) {
        text = @"Dashboard";
    } else if (row == 1) {
        text = @"Input Program";
    } else if (row == 2) {
        text = @"Tentang";
    } else if (row == 3) {
        text = @"Keluar";
    }
    
    cell.textLabel.text = NSLocalizedString( text,nil );
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    UIViewController *newFrontController = nil;
    
    if (row == 0) {
        newFrontController = [[TabVC alloc] init];
    } else if (row == 1) {
        newFrontController = [[AddProgramVC alloc] init];
    } else if (row == 2) {
        newFrontController = [[TabVC alloc] init];
    } else if (row == 3) {
        [self goToLoginVC];
        newFrontController = [[TabVC alloc] init];
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [revealController pushFrontViewController:navigationController animated:YES];
}

// Local method
-(void) goToLoginVC {
    @autoreleasepool {
        LoginVC *loginVC = [[LoginVC alloc] initWithNibName:nil bundle:nil];
        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

@end
