//
//  AuthService.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/30/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "AuthService.h"
#import <Foundation/Foundation.h>
#import <Security/Security.h>

#define API_URL "http://simonag.owline.org/api/v1"
#define POST_Login "/login"
#define POST_ForgotPassword "/sendEmailForgotPassword"

@implementation AuthService

+ (id) instance {
    static AuthService *sharedInstance = nil; // static func
    
    @synchronized (self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc]init];
    }
    
    return sharedInstance;
}

- (void)setIsAuthenticated:(BOOL)isAuthenticated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _isAuthenticated = [defaults boolForKey:@"isAuthenticated"];
}

- (void)setAuthToken:(NSString *)authToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _authToken = [defaults objectForKey:@"authToken"];
}

- (void)setIdusr:(NSString *)idusr {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _idusr = [defaults objectForKey:@"idusr"];
}

-(NSURLSessionConfiguration *)sessionConfig {
    @autoreleasepool {
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                        diskCapacity:0
                                                            diskPath:nil];
        
        return config;
    }
}

- (void) loginUser:(NSString *)username :(NSString *)password completion:(void (^)(BOOL))completionBlock {
    @autoreleasepool {
        NSString *Post =[[NSString alloc] initWithFormat:@"email=%@&password=%@",username,password];
        
        NSURL *Url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s", API_URL, POST_Login]];
        
        NSData *PostData = [Post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[PostData length]];
        
        NSMutableURLRequest *Request = [[NSMutableURLRequest alloc] init];
        [Request setURL:Url];
        [Request setHTTPMethod:@"POST"];
        [Request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [Request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [Request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [Request setHTTPBody:PostData];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
        [[session dataTaskWithRequest:Request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data != nil) {
                NSError *err;
                NSData *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                NSLog(@"Result: %@", [result valueForKey:@"status"]);
                if ([[result valueForKey:@"status"] isEqual: @"failed"]) {
                    NSLog(@"Incorrect Login!");
                    completionBlock(NO);
                } else if ([[result valueForKey:@"status"] isEqual: @"success"]) {
                    [[NSUserDefaults standardUserDefaults] setValue:[result valueForKey:@"id_role"] forKey:@"id_role"];
                    [[NSUserDefaults standardUserDefaults] setValue:[result valueForKey:@"id_tipe"] forKey:@"id_tipe"];
                    [[NSUserDefaults standardUserDefaults] setValue:[result valueForKey:@"id_perusahaan"] forKey:@"id_perusahaan"];
                    [[NSUserDefaults standardUserDefaults] setValue:[result valueForKey:@"nama"] forKey:@"nama"];
                    [[NSUserDefaults standardUserDefaults] setValue:[result valueForKey:@"foto"] forKey:@"foto"];
                    [[NSUserDefaults standardUserDefaults] setValue:[result valueForKey:@"token"] forKey:@"authToken"];
                    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"usernameEmail"];
                    completionBlock(YES);
                } else {
                    completionBlock(NO);
                }
            } else {
                NSLog(@"Network Err: %@", error.debugDescription);
                completionBlock(NO);
            }
        }] resume];
        [session finishTasksAndInvalidate];
    }
}

- (void)forgotPassword:(NSString *)email completion:(void (^)(BOOL))completionBlock {
    @autoreleasepool {
        NSString *Post =[[NSString alloc] initWithFormat:@"email=%@",email];
        
        NSURL *Url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s", API_URL, POST_ForgotPassword]];
        
        NSData *PostData = [Post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[PostData length]];
        
        NSMutableURLRequest *Request = [[NSMutableURLRequest alloc] init];
        [Request setURL:Url];
        [Request setHTTPMethod:@"POST"];
        [Request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [Request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [Request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [Request setHTTPBody:PostData];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[session dataTaskWithRequest:Request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSError *err;
                NSData *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                if (error == nil) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)[httpResponse statusCode]);
                    if([httpResponse statusCode] != 200 && [httpResponse statusCode] != 201) {
                        if(result != nil) {
//                            [[NSUserDefaults standardUserDefaults] setValue:[result valueForKey:@"message"] forKey:@"forgotPasswordError"];
                        }
                        completionBlock(NO);
                        return;
                    } else {
                        if(result != nil) {
//                            [[NSUserDefaults standardUserDefaults] setValue:[result valueForKey:@"message"] forKey:@"forgotPasswordError"];
                        }
                        completionBlock(YES);
                    }
                } else {
                    NSLog(@"URL Session Task Failed: %@", error.debugDescription);
                    completionBlock(NO);
                }
            }] resume];
            [session finishTasksAndInvalidate];
        });
    }
}

@end
