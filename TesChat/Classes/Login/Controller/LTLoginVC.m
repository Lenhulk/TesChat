//
//  LTLoginVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/12.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTLoginVC.h"
#import "EMClient.h"
#import "LTMainVC.h"

@interface LTLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@end

@implementation LTLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 登录
- (IBAction)loginAction:(id)sender {
    NSString *username = self.usernameTF.text;
    NSString *password = self.pwdTF.text;
    
    //发送登录请求
#warning 只第一次登录成功，第二次再登录，内部实现是没有发请求
    [[EMClient sharedClient] loginWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        NSLog(@"登录状态 %@", aError.errorDescription);
        
        //设置自动登录开关
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        
        //登录成功进入主界面
        if (!aError) {
            LTMainVC *mainVc = [[LTMainVC alloc] init];
            self.view.window.rootViewController = mainVc;
        }
    }];
}

#pragma mark - 注册
- (IBAction)registerAction:(id)sender {
    NSString *username = self.usernameTF.text;
    NSString *password = self.pwdTF.text;
    
    //发送注册请求给服务器
    [[EMClient sharedClient] registerWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        
        if (aError.code == EMErrorUserAlreadyExist) {
            NSLog(@"用户名已经存在！");
        }
        NSLog(@"注册状态 %@", aError.errorDescription);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
