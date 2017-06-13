//
//  NSString+StringSize.h
//  badianhou
//
//  Created by Yue Huang on 6/10/15.
//  Copyright (c) 2015 careerfrog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (StringSize)
- (CGSize)limitSize:(CGSize)size font:(UIFont *)font;
- (CGSize)limitSize:(CGSize)size attributes:(NSDictionary *)attributes;
@end
