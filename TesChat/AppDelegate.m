//
//  AppDelegate.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/12.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "AppDelegate.h"
#import "EMSDK.h"
#import "LTLoginVC.h"
#import "LTMainVC.h"
#import "LTDBHelper.h"
#import "AppDelegate+Theme.h"

@interface AppDelegate () <EMClientDelegate, EMContactManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    LTLog(@"打印沙盒路径:%@", NSHomeDirectory());
    
//    NSString *comfirmStr = NSLocalizedString(@"confirmpassword", nil);
//    LTLog(@"%@", comfirmStr);

    //设置主题
    [self setupTheme];
    
    //初始化SDK
    //AppKey:注册的AppKey
    //apnsCertName:推送证书名（不需要加后缀）
    EMOptions *options = [EMOptions optionsWithAppkey:@"1119161212178641#teschat"];
//    options.apnsCertName = @"istore_dev"; //未实现远程推送可以注销
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //监听自动登录结果
    [[EMClient sharedClient] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //添加ContactManager的代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //判断自动登录业务逻辑
    if ([[EMClient sharedClient].options isAutoLogin]){
        self.window.rootViewController = [[LTMainVC alloc] init];
        
        //设置联系人TabBar的badge
        NSInteger count =[LTDBHelper friendRequestCount];
        UIViewController *contactNav = self.window.rootViewController.childViewControllers[1];
        if (count == 0) {
            contactNav.tabBarItem.badgeValue = nil;
        } else {
            contactNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", count];
        }
        
    } else {
        self.window.rootViewController = [[LTLoginVC alloc] init];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}




@end
