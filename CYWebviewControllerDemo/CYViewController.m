//
//  CYViewController.m
//  CYWebviewController
//
//  Created by 万鸿恩 on 16/5/30.
//  Copyright © 2016年 万鸿恩. All rights reserved.
//

#import "CYViewController.h"
#import "UIColor+WHE.h"
#import "UINavigationBar+Awesome.h"
#import "CYWebViewController.h"



@interface CYViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"Demo";
    
    [self setNavColor];
}

/**
 *  设置导航栏的颜色，返回按钮和标题为白色
 */
-(void)setNavColor{
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorFromHexString:@"12baaa"]];
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        
        self.navigationController.navigationBar.translucent = YES;
        
        
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor =[UIColor colorFromHexString:@"12baaa"];
        
    }
}


-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tracy"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tracy"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"测试push";
        }else{
            cell.textLabel.text = @"测试";
        }
    }else{
        cell.textLabel.text = @"测试Wechat Mode";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CYWebViewController *controller = [[CYWebViewController alloc] init];
            controller.url = [NSURL URLWithString:@"https://www.baidu.com/"];
            controller.loadingBarTintColor = [UIColor redColor];
            controller.navigationButtonsHidden = NO;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            CYWebViewController *controller = [[CYWebViewController alloc] init];
            controller.url = [NSURL URLWithString:@"https://www.baidu.com/"];
            controller.loadingBarTintColor = [UIColor redColor];
            controller.navigationButtonsHidden = NO;
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
        }
    }else{
        CYWebViewController *controller = [[CYWebViewController alloc] init];
        controller.url = [NSURL URLWithString:@"https://www.baidu.com/"];
        controller.loadingBarTintColor = [UIColor redColor];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 40) ];
        [header setBackgroundColor:[UIColor clearColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 200, 24)];
        label.text = @"Safari Mode";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16];
        [header addSubview:label];
        return header;
    }else{
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 40) ];
        [header setBackgroundColor:[UIColor clearColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 200, 24)];
        label.text = @"Wechat Mode";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16];
        [header addSubview:label];
        return header;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
