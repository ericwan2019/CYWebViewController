//
//  UIColor+WHE.m
//  Horus
//
//  Created by 万鸿恩 on 15/9/17.
//  Copyright (c) 2015年 Cybersys. All rights reserved.
//

#import "UIColor+WHE.h"

@implementation UIColor (WHE)



+(UIColor*)colorFromHexString:(NSString *)hexString{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    
    //NSLog(@"alpha equals to %f  r:%f  g:%f  b:%f",alpha,red*255,green*255,blue*255);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}



@end
