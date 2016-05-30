//
//  CYWebViewController.h
//  CYWebViewController
//
//  Created by 万鸿恩 on 16/1/18.
//  Copyright © 2016年 万鸿恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYWebViewController : UIViewController
/**
 set webview url
 */
@property (nonatomic,strong) NSString *url;

/**
 The tint colour of the page loading progress bar.
 If not set on iOS 7 and above, the loading bar will defer to the app's global UIView tint color.
 If not set on iOS 6 or below, it will default to the standard system blue tint color.
 
 Default value is nil.
 */
@property (nonatomic,copy)      UIColor *loadingBarTintColor;



/**
 webview bg color
 */
@property (nonatomic,copy)      NSString *bgcolor;


@end
