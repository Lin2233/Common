//
//  macro.h
//  Ford-Rec
//
//  Created by YuLinpo on 2017/5/24.
//  Copyright © 2017年 Yulinpo. All rights reserved.
//
#import "UIColor+SNFoundation.h"

#ifndef macro_h
#define macro_h

#define APIKEY @"76916aa2c99d5d987ee757994fc83fd5"
#define TABLEID @"5934b5a0305a2a4ed7a8b8f2"

#define kScreenSize           [[UIScreen mainScreen] bounds].size
//屏幕高度
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
//屏幕宽度
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define JPushKey @"13f41a6df77f4134cded0ebc"

#define RGBAColor(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
//16进制
#undef	UIColorFromHex
#define UIColorFromHex(V)		[UIColor colorWithHexString:V]

#endif /* macro_h */
