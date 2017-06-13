//
//  NSURLRequest+SSL.h
//  FenXiaoBao
//
//  Created by YuLinpo on 2016/12/30.
//  Copyright © 2016年 Yulinpo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (SSL)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end
