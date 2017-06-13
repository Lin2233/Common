//
//  UIView+Postion.h
//  BDHAddTagsTest
//
//  Created by Yue Huang on 7/7/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define vAlertTag    10086

@interface UIView (Postion)
@property (nonatomic, assign) CGFloat   x;
@property (nonatomic, assign) CGFloat   y;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, assign) CGPoint   origin;
@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) CGFloat   bottom;
@property (nonatomic, assign) CGFloat   right;
@property (nonatomic, assign) CGFloat   centerX;
@property (nonatomic, assign) CGFloat   centerY;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnX;
@property (nonatomic, strong, readonly) UIView *lastSubviewOnY;

/**
 * @brief 移除此view上的所有子视图
 */
- (void)removeAllSubviews;
@end
