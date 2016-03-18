//
//  UIButton+WHE.h
//  DoctorApp
//
//  Created by 万鸿恩 on 16/1/15.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WHE)
+(UIButton *)buttonBackWithImage:(UIImage *)image buttontitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
