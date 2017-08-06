//
//  Dashboard.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/26/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dashboard : NSObject
@property(nonatomic,strong) NSString *id_perusahaan;
@property(nonatomic,strong) NSString *nama_perusahaan;
@property(nonatomic,strong) NSString *keterangan;
@property(nonatomic,strong) NSString *realisasi_persen;
@property(nonatomic,strong) NSString *kualitas_persen;
@property(nonatomic,strong) NSString *kapasitas_persen;
@property(nonatomic,strong) NSString *komersial_persen;
@property(nonatomic,strong) NSString *total_rupiah;
@property(nonatomic,strong) NSString *total_aktivitas;
@property(nonatomic,strong) NSString *image;
@property(nonatomic,strong) NSString *jumlah_perusahaan;
@property(nonatomic,strong) NSString *jumlah_program;

@property(nonatomic,strong) NSString *nama_kategori;
@end
