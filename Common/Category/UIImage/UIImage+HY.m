//
//  UIImage+HY.m
//  bodybuildcoach
//
//  Created by 黄悦 on 4/1/15.
//  Copyright (c) 2015 Yuson Xing. All rights reserved.
//

#import "UIImage+HY.h"

@implementation UIImage (HY)
- (UIImage *)duplicate
{
    CGImageRef newCgIm = CGImageCreateCopy(self.CGImage);
    UIImage *newImage = [UIImage imageWithCGImage:newCgIm scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(newCgIm);
    
    return newImage;
}

- (UIImage *)stretched
{
    CGSize size = self.size;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
    
    return [self resizableImageWithCapInsets:insets];
}

- (UIImage *)antiAlias
{
    int border = 1;
    CGRect rect = CGRectMake(border, border, self.size.width-2*border, self.size.height-2*border);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width,rect.size.height));
    [self drawInRect:CGRectMake(-1, -1, self.size.width, self.size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.size);
    [img drawInRect:rect];
    UIImage* antiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return antiImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image stretched];
}

+ (UIImage *)imageNoCacheWithName:(NSString *)name
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)bgImageWithName:(NSString *)name
{
    NSString *suffix = nil;
    NSString *newName = nil;
    if ([name hasSuffix:@".png"] || [name hasSuffix:@".jpg"])
    {
        suffix = [name substringFromIndex:name.length - 4];
        newName = [name substringToIndex:name.length - 4];
    }
    else
    {
        newName = name;
    }

    CGFloat screenHeight = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);

    
    if (screenHeight == 568)
    {
        newName = [newName stringByAppendingString:@"_568"];
    }
    else if (screenHeight == 667)
    {
        newName = [newName stringByAppendingString:@"_667"];
    }
    else
    {
        
    }
    if (suffix.length != 0)
    {
        newName = [newName stringByAppendingString:suffix];
    }
    else
    {
        newName = [newName stringByAppendingString:@".png"];
    }
    UIImage *image = [UIImage imageNoCacheWithName:newName];
    if (!image)
    {
        image = [UIImage imageNoCacheWithName:name];
    }
    return image;
}

@end
