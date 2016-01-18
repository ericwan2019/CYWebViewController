# CYWebViewController
类似微信内置浏览器，顶部导航栏提供webview后退和关闭按钮 

效果：
===
![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/1.PNG),![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/2.PNG),![image](https://github.com/wheying/CYWebViewController/blob/master/Screenshot/3.PNG)

使用:
===
把项目中的CY文件夹拉近自己的项目就可以了

例子：
=====
CYWebViewController *controller = [[CYWebViewController alloc] init];
controller.url = @"https://www.baidu.com/";
controller.loadingBarTintColor = [UIColor redColor];
[self.navigationController pushViewController:controller animated:YES];
