//
//  DataService.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/26/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^onComplete)(NSArray * __nullable dataArray, NSString * __nullable errMessage);

@interface DataService : NSObject

+ (nullable id) instance;
- (void)getDashboardWithToken:(NSString* _Nonnull)token :(nullable onComplete)completionHandler;
- (void)getProgramPerusahaanWithToken:(NSString* _Nonnull)token :(nullable onComplete)completionHandler;
- (void)getTargetProgramWithToken:(NSString* _Nonnull)token :(nullable onComplete)completionHandler;
- (UIImage* _Nonnull)compressImage:(UIImage* _Nonnull)image;

- (void)postProgramWithNamaProgram:(NSString* _Nonnull)namaProgram IDPerusahaan:(NSString* _Nonnull)IDPerusahaan completion:(void (^ _Nullable)(BOOL))completionBlock;

- (void)editProgramWithNamaProgram:(NSString* _Nonnull)namaProgram IDPerusahaan:(NSString* _Nonnull)IDPerusahaan IDProgram:(NSString* _Nonnull)IDProgram completion:(void (^ _Nullable)(BOOL))completionBlock;

- (void)deleteProgramWithIDProgram:(NSString* _Nonnull)IDProgram :(nullable onComplete)completionHandler;

////
- (void)editProgramButtonClicked:(UIButton* _Nonnull)sender arrayList:(NSArray* _Nonnull)arrayList navigationController:(UINavigationController* _Nonnull)navigationController;

@end
