//
//  UIImage+HY.h
//  bodybuildcoach
//
//  Created by 黄悦 on 4/1/15.
//  Copyright (c) 2015 Yuson Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HY)
/**
 *  复制图片
 *
 *  @return
 */
- (UIImage *)duplicate;
/**
 *  使当前图片抗锯齿(当图片在旋转时有用, 原理就是在图片周围加1px的透明像素)
 *
 *  @return
 */
- (UIImage *)antiAlias;
/**
 *  创建纯色的图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size;
/**
 *  无缓存
 *
 *  @param name
 *
 *  @return
 */
+ (UIImage *)imageNoCacheWithName:(NSString *)name;
/**
 *  缩放图片
 *
 *  @param image 原始图片
 *  @param size  尺寸
 *
 *  @return 缩放后的图片
 */
+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size;

+ (UIImage *)bgImageWithName:(NSString *)name;

@end
