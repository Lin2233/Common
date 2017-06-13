//
//  UITextField+PlaceholderColor.m
//  bodybuildcoach
//
//  Created by Yuson Xing on 15/3/3.
//  Copyright (c) 2015年 Yuson Xing. All rights reserved.
//

#import "UITextField+PlaceholderColor.h"

@implementation UITextField (PlaceholderColor)
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)placeholder:(NSString *)placeholder attributeDic:(NSDictionary *)dic
{
    if (placeholder.length == 0)
    {
        return;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:dic];
    self.attributedPlaceholder = string;
}

//- (void) drawPlaceholderInRect:(CGRect)rect
//{
//    [[UIColor lightGrayColor] setFill];
//    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:14]];
//}

@end
