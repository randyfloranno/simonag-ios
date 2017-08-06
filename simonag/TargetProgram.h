//
//  TargetProgram.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/30/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetProgram : NSObject
@property(nonatomic,strong) NSString *id_target;
@property(nonatomic,strong) NSString *nama_aktivitas;
@property(nonatomic,strong) NSString *keterangan;
@property(nonatomic,strong) NSString *due_date;
@property(nonatomic,strong) NSString *realisasi_persen;
@property(nonatomic,strong) NSString *target_nilai;
@property(nonatomic,strong) NSString *realisasi;
@property(nonatomic,strong) NSString *revenue_target_nilai;
@property(nonatomic,strong) NSString *realisasi_revenue;
@property(nonatomic,strong) NSString *koordinat;
@property(nonatomic,strong) NSString *id_kategori;
@property(nonatomic,strong) NSString *nama_kategori;
@property(nonatomic,strong) NSString *status_revenue;
@property(nonatomic,strong) NSString *id_satuan;
@property(nonatomic,strong) NSString *nama_satuan;
@end
