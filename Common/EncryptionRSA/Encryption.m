//
//  Encryption.m
//  DaZhongChuXing
//
//  Created by tony on 16/6/1.
//  Copyright © 2016年 tony. All rights reserved.
//

#import "Encryption.h"
#import "RSA.h"

#define PUBLICKEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDd9t/oHa1APPR8ZYoKHvH3JuoKeHxg0pxO3qPq3qwR0/pPo6c4NKEo9IkSC0iWpjSirAhPNPDblnL3YOuwMIF9/0XN/2GN0fvjOkVEt1JCXTpPT8uGZRp4l4twMYcsB2z+pzaQCEdspZnBjDKEEO+gFqK8LyJvp2qoUsFB774BnwIDAQAB" //公钥
#define PRIVATEKEY @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----"

@implementation Encryption

static Encryption *single;

/**
 *  单例
 *
 *  @return self
 */
+(Encryption *)shareSingle
{
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken,^{
      single=[[Encryption alloc] init];
   });
   return single;
}

/**
 *  公钥加密
 *
 *  @param originString 加密数据
 *
 *  @return 加密后数据
 */
-(NSString *)publicKeyEncryption:(NSString *)originString
{
   NSString *result=@"";
   if(originString!=nil && originString.length>0){
      result=[RSA encryptString:originString publicKey:PUBLICKEY];
   }
   return result;
}
/**
 *  私钥解密
 *
 *  @param encryptionString 加密字符串
 *
 *  @return 解密后字符串
 */
-(NSString *)privateKeyDecryption:(NSString *)encryptionString
{
   NSString *result=@"";
   if(encryptionString!=nil && encryptionString.length>0){
      result=[RSA decryptString:encryptionString privateKey:PRIVATEKEY];
   }
   return result;
}
/**
 *  字典转换成字符串
 *
 *  @param dic 字典
 *
 *  @return 字符串
 */
-(NSString *)dictionaryToJson:(NSDictionary *)dic
{
   NSString *result=@"";
   NSError *parseError = nil;
   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
   return result=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
/**
 *  加密
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)encryptionDictionaryToString:(NSDictionary *)dic
{
   NSString *result=@"";
   result=[self dictionaryToJson:dic];
   result=[self publicKeyEncryption:result];
   return result;
}



@end
