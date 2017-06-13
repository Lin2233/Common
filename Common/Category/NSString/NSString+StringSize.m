//
//  NSString+StringSize.m
//  badianhou
//
//  Created by Yue Huang on 6/10/15.
//  Copyright (c) 2015 careerfrog. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)
- (CGSize)limitSize:(CGSize)size font:(UIFont *)font
{
    NSDictionary *attributesDic = @{
                                    NSFontAttributeName : font
                                    };
    return [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil].size;
}

- (CGSize)limitSize:(CGSize)size attributes:(NSDictionary *)attributes
{
    return [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

@end
