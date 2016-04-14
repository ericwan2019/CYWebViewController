//
//  UIButton+WHE.m
//  DoctorApp
//
//  Created by 万鸿恩 on 16/1/15.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "UIButton+WHE.h"

@implementation UIButton (WHE)
+(UIButton *)buttonBackWithImage:(UIImage *)image buttontitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    // btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn sizeToFit];
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = 80;
    CGFloat btnH = 44;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    return btn;
}
@end
