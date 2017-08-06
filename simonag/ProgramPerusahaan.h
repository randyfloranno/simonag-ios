//
//  ProgramPerusahaan.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/30/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgramPerusahaan : NSObject
@property(nonatomic,strong) NSString *id_program;
@property(nonatomic,strong) NSString *nama_program;
@property(nonatomic,strong) NSString *keterangan;
@property(nonatomic,strong) NSString *realisasi_persen;
@property(nonatomic,strong) NSString *kualitas_persen;
@property(nonatomic,strong) NSString *kapasitas_persen;
@property(nonatomic,strong) NSString *komersial_persen;

@end
