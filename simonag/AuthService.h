//
//  AuthService.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/30/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthService : NSObject

@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, retain) NSString* _Nonnull idusr;
@property (nonatomic, retain) NSString* _Nonnull authToken;

+ (nullable id) instance;
- (void) loginUser:(NSString* _Nonnull)username :(NSString* _Nonnull)password completion:(void (^ _Nonnull)(BOOL))completionBlock;

- (void) forgotPassword:(NSString* _Nonnull)email completion:(void (^ _Nonnull)(BOOL))completionBlock;

@end
