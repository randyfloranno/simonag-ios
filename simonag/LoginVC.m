//
//  LoginVC.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/26/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "LoginVC.h"
#import "AuthService.h"
#import "ForgotPasswordVC.h"
#import <MBProgressHUD.h>

#define kOFFSET_FOR_KEYBOARD 80.0

@interface LoginVC ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewInsideScrollview;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.emailTextField.delegate = self;
        self.passwordTextField.delegate = self;
    });
}

-(void) backToKualitasVC {
    @autoreleasepool {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:YES forKey:@"isAuthenticated"];
        
        NSLog(@"ID Role: %@", [prefs stringForKey:@"id_role"]);
        NSLog(@"ID Tipe: %@", [prefs stringForKey:@"id_tipe"]);
        NSLog(@"ID Perusahaan: %@", [prefs stringForKey:@"id_perusahaan"]);
        NSLog(@"Nama: %@", [prefs stringForKey:@"nama"]);
        NSLog(@"Foto: %@", [prefs stringForKey:@"foto"]);
        NSLog(@"Token: %@", [prefs stringForKey:@"authToken"]);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

- (IBAction)loginBtnTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AuthService instance]loginUser:self.emailTextField.text :self.passwordTextField.text completion:^(BOOL Success) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            if(Success) {
                [self backToKualitasVC];
            } else {
                NSLog(@"Incorrect login");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }];
}
- (IBAction)forgotPasswordBtnTapped:(id)sender {
    @autoreleasepool {
        ForgotPasswordVC *forgotPasswordVC = [[ForgotPasswordVC alloc] initWithNibName:nil bundle:nil];
        forgotPasswordVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:forgotPasswordVC animated:YES completion:nil];
    }
}

//
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds));
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        [self.view endEditing:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.scrollView.showsVerticalScrollIndicator=YES;
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds)+90);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == self.passwordTextField) {
        self.scrollView.contentOffset = CGPointMake(0, ((CGRectGetHeight(self.view.bounds)/2)-textField.frame.origin.y+(CGRectGetHeight(self.emailTextField.bounds))));
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,(([UIScreen mainScreen].bounds.size.height*0.99)-[UIScreen mainScreen].bounds.size.height),[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
}

-(void)keyboardDidHide:(NSNotification *)notification {
    [self.view setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
}

@end
