//
//  AppDelegate+Theme.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/18.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "AppDelegate+Theme.h"

@implementation AppDelegate (Theme)

- (void)setupTheme{
    //设置tabBar图标颜色
    [UITabBar appearance].tintColor = [UIColor colorWithRed:26/255.0 green:178/255.0 blue:10/255.0 alpha:1];
    
    //设置导航栏
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_64"] forBarMetrics:UIBarMetricsDefault];
    navBar.tintColor = [UIColor whiteColor];    //设置导航栏图标颜色
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]; //设置导航栏标题颜色
    
    //设置statusBar
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    #warning 如果要使用appliction设置状态栏的样式 ，需要在info.plist文件配置，添加一个Key 
    //View controller-based status bar appearance = NO
}

@end
