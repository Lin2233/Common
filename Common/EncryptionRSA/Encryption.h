//
//  Encryption.h
//  DaZhongChuXing
//
//  Created by tony on 16/6/1.
//  Copyright © 2016年 tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryption : NSData

+(Encryption *)shareSingle;

-(NSString *)encryptionDictionaryToString:(NSDictionary *)dic;



@end
