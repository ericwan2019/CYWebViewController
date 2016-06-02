# CYWebViewController
Contain two mode:wechat browser and Safari browser. A web view controller class for iOS that allows users to view web pages directly within an app similar as wechat.Using Safari mode, contains goBack,goForward,shareAction,refresh and stop function at toolbar<br>

分为两种模式，一种是类似微信内置浏览器模式，一种是Safari浏览器模式。类似微信内置浏览器，顶部导航栏提供webview后退和关闭按钮.Safari模式，底部toolbar带有前进，后退，分享，刷新的功能。

效果：
===
![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/1.PNG) ![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/2.PNG) ![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/3.PNG)
![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/4.PNG)
![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/5.PNG)
![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/6.PNG)

使用:
===
把项目中的CY文件夹拉近自己的项目就可以了<br>
Push "CY" file to your project
<br/>
```
#import "CYWebViewController.h"
```
<br>#import "UINavigationBar+Awesome.h"可以设置UINavigationBar
```
#import "UIButton+WHE.h"
```
<br>#import "UIButton+WHE.h"自定义返回按钮
```
#import "UIButton+WHE.h"
```
<br>#import "UIColor+WHE.h"HEX颜色转为RGB颜色
```
#import "UIColor+WHE.h"
```

例子Example：
=====
<br>import
```
#import "CYWebViewController.h"
```
<br>使用微信内置浏览器模式 (Using Wechat mode)
```
CYWebViewController *controller = [[CYWebViewController alloc] init];
controller.url = @"https://www.baidu.com/";
controller.loadingBarTintColor = [UIColor redColor];
[self.navigationController pushViewController:controller animated:YES];
```
<br>使用Safari 模式，底部toolbar带有前进，后退，分享，刷新的功能。Using Safari mode, contains goBack,goForward,shareAction,refresh and stop function at toolbar.  Push ViewController
```
CYWebViewController *controller = [[CYWebViewController alloc] init];
controller.url = [NSURL URLWithString:@"https://www.baidu.com/"];
controller.loadingBarTintColor = [UIColor redColor];
controller.navigationButtonsHidden = NO;
[self.navigationController pushViewController:controller animated:YES];
```
<br>presentViewController
```
CYWebViewController *controller = [[CYWebViewController alloc] init];
controller.url = [NSURL URLWithString:@"https://www.baidu.com/"];
controller.loadingBarTintColor = [UIColor redColor];
controller.navigationButtonsHidden = NO;         
[self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
```
