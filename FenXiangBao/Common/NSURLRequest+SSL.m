//
//  NSURLRequest+SSL.m
//  FenXiaoBao
//
//  Created by YuLinpo on 2016/12/30.
//  Copyright © 2016年 Yulinpo. All rights reserved.
//

#import "NSURLRequest+SSL.h"

@implementation NSURLRequest (SSL)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host
{
    
}

@end
