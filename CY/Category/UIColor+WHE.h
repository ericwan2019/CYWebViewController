//
//  UIColor+WHE.h
//  DoctorApp
//
//  Created by 万鸿恩 on 15/10/29.
//  Copyright © 2015年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (WHE)
/**
 * hex color to rgd color, where hexString, such as: #FF00FF
 **/
+ (UIColor *) colorFromHexString:(NSString *)hexString;
@end
