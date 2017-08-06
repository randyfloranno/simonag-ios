//
//  DataService.m
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/26/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import "DataService.h"
#import "EditProgramVC.h"
#import <UIKit/UIKit.h>

#define API_URL "http://simonag.owline.org/api/v1"
#define GET_ALL_Dashboard "/get/Dashboard"
#define GET_ALL_ProgramPerusahaan "/get/programPerusahaan"
#define GET_ALL_TargetProgram "/get/targetProgram"

#define POST_Program "/post/programPerusahaan"

#define EDIT_Program "/edit/programPerusahaan"

#define DELETE_Program "/delete/programPerusahaan/"

@implementation DataService

+ (id) instance {
    static DataService *sharedInstance = nil; // static func
    
    @synchronized (self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc]init];
    }
    
    return sharedInstance;
}

- (NSURLSessionConfiguration *)sessionConfig {
    @autoreleasepool {
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                        diskCapacity:0
                                                            diskPath:nil];
        
        return config;
    }
}

- (void)getDashboardWithToken:(NSString *)token :(onComplete)completionHandler {
    @autoreleasepool {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s%@", API_URL, GET_ALL_Dashboard, token]]];
        
        [request setHTTPMethod:@"GET"];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)[httpResponse statusCode]);
            
            if (data != nil) {
                NSError *err;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                completionHandler(json, nil);
            } else {
                NSLog(@"Network Err: %@", error.debugDescription);
                completionHandler(nil, @"Problem connecting to the server");
            }
            
        }] resume];
        [session finishTasksAndInvalidate];
    }
}

- (void)getProgramPerusahaanWithToken:(NSString *)token :(onComplete)completionHandler {
    @autoreleasepool {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s%@", API_URL, GET_ALL_ProgramPerusahaan, token]]];
        
        [request setHTTPMethod:@"GET"];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)[httpResponse statusCode]);
            
            if (data != nil) {
                NSError *err;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                completionHandler(json, nil);
            } else {
                NSLog(@"Network Err: %@", error.debugDescription);
                completionHandler(nil, @"Problem connecting to the server");
            }
            
        }] resume];
        [session finishTasksAndInvalidate];
    }
}

- (void)getTargetProgramWithToken:(NSString *)token :(onComplete)completionHandler {
    @autoreleasepool {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s%@", API_URL, GET_ALL_TargetProgram, token]]];
        
        [request setHTTPMethod:@"GET"];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)[httpResponse statusCode]);
            
            if (data != nil) {
                NSError *err;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                completionHandler(json, nil);
            } else {
                NSLog(@"Network Err: %@", error.debugDescription);
                completionHandler(nil, @"Problem connecting to the server");
            }
            
        }] resume];
        [session finishTasksAndInvalidate];
    }
}

- (void)postProgramWithNamaProgram:(NSString *)namaProgram IDPerusahaan:(NSString *)IDPerusahaan completion:(void (^)(BOOL))completionBlock {
    @autoreleasepool {
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        [_params setObject:[NSString stringWithFormat:@"%@",namaProgram] forKey:@"nama_program"];
        [_params setObject:[NSString stringWithFormat:@"%@",IDPerusahaan] forKey:@"id_perusahaan"];
        [_params setObject:[NSString stringWithFormat:@"test"] forKey:@"keterangan"];
        
        NSURL *Url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s/%@", API_URL, POST_Program, [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"]]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        //    [request setHTTPShouldHandleCookies:NO];
        //    [request setTimeoutInterval:30];
        [request setURL:Url];
        [request addValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"] forHTTPHeaderField:@"key"];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //post body
        NSMutableData *body = [NSMutableData data];
        
        // add params (all params are strings)
        for (NSString *param in _params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //setting the body of the post to the request
        [request setHTTPBody:body];
        
        // set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        //trace
        NSLog(@"Nama Program: %@", namaProgram);
        NSLog(@"ID Perusahaan: %@", IDPerusahaan);
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)[httpResponse statusCode]);
                if([httpResponse statusCode] != 200 && [httpResponse statusCode] != 201) {
                    NSError *err;
                    NSData *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                    if(result != nil) {
                        NSLog(@"Result: %@", result);
                    }
                    completionBlock(NO);
                    return;
                } else {
                    NSError *err;
                    NSData *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                    if(result != nil) {
                        //do what if success
                    }
                    completionBlock(YES);
                }
            } else {
                NSLog(@"URL Session Task Failed: %@", error.debugDescription);
                completionBlock(NO);
            }
        }] resume];
        [session finishTasksAndInvalidate];
    }
}

- (void)editProgramWithNamaProgram:(NSString *)namaProgram IDPerusahaan:(NSString *)IDPerusahaan IDProgram:(NSString *)IDProgram  completion:(void (^)(BOOL))completionBlock {
    @autoreleasepool {
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        [_params setObject:[NSString stringWithFormat:@"%@",namaProgram] forKey:@"nama_program"];
        [_params setObject:[NSString stringWithFormat:@"%@",IDPerusahaan] forKey:@"id_perusahaan"];
        [_params setObject:[NSString stringWithFormat:@"test"] forKey:@"keterangan"];
        [_params setObject:[NSString stringWithFormat:@"%@",IDProgram] forKey:@"id_program"];
        
        NSURL *Url = [NSURL URLWithString:[NSString stringWithFormat:@"%s%s/%@", API_URL, EDIT_Program, [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"]]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        //    [request setHTTPShouldHandleCookies:NO];
        //    [request setTimeoutInterval:30];
        [request setURL:Url];
        [request addValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"] forHTTPHeaderField:@"key"];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        //post body
        NSMutableData *body = [NSMutableData data];
        
        // add params (all params are strings)
        for (NSString *param in _params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //setting the body of the post to the request
        [request setHTTPBody:body];
        
        // set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        //trace
        NSLog(@"Nama Program: %@", namaProgram);
        NSLog(@"ID Perusahaan: %@", IDPerusahaan);
        NSLog(@"ID Program: %@", IDProgram);
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)[httpResponse statusCode]);
                if([httpResponse statusCode] != 200 && [httpResponse statusCode] != 201) {
                    NSError *err;
                    NSData *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                    if(result != nil) {
                        NSLog(@"Result: %@", result);
                    }
                    completionBlock(NO);
                    return;
                } else {
                    NSError *err;
                    NSData *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                    if(result != nil) {
                        //do what if success
                    }
                    completionBlock(YES);
                }
            } else {
                NSLog(@"URL Session Task Failed: %@", error.debugDescription);
                completionBlock(NO);
            }
        }] resume];
        [session finishTasksAndInvalidate];
    }
}

- (void)deleteProgramWithIDProgram:(NSString *)IDProgram :(onComplete)completionHandler {
    @autoreleasepool {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%s%@/%@", API_URL, DELETE_Program, [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"], IDProgram]]];
        
        [request setHTTPMethod:@"GET"];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"URL Session Task Succeeded: HTTP %ld", (long)[httpResponse statusCode]);
            
            if (data != nil) {
                NSError *err;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                completionHandler(json, nil);
            } else {
                NSLog(@"Network Err: %@", error.debugDescription);
                completionHandler(nil, @"Problem connecting to the server");
            }
            
        }] resume];
        [session finishTasksAndInvalidate];
    }
}

////
- (void)editProgramButtonClicked:(UIButton*)sender arrayList:(NSArray*)arrayList navigationController:(UINavigationController*)navigationController {
    NSLog(@"Sender Tag Edit Button: %ld", (long)sender.tag);
    ProgramPerusahaan *programPerusahaan = [arrayList objectAtIndex:sender.tag];
    EditProgramVC *editProgramVC = [[EditProgramVC alloc] initWithNibName:@"EditProgramVC" bundle:nil];
    editProgramVC.title = @"Edit Program";
    editProgramVC.programPerusahaan = programPerusahaan;
    [navigationController pushViewController:editProgramVC animated:YES];
}

- (UIImage *)compressImage:(UIImage *)image {
    UIImage *resizeImage;
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 46.0; //new max. height for image
    float maxWidth = 46.0; //new max. width for image
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    //float compressionQuality = 0.5; //50 percent compression
    float compressionQuality = 0.9;
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    //NSLog(@"Actual height : %f and Width : %f",actualHeight,actualWidth);
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    //NSData *imageData = UIImagePNGRepresentation(img);
    resizeImage = [[UIImage alloc] initWithData:imageData];
    UIGraphicsEndImageContext();
    return resizeImage;
}

@end
