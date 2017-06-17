//
//  LTSettingVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/14.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTSettingVC.h"
#import "EMClient.h"
#import "LTLoginVC.h"

@interface LTSettingVC ()
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;

@end

@implementation LTSettingVC

- (IBAction)logoutAction:(id)sender {
    //YES-只允许单个帐号登录, NO-允许多个帐号登录
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        if (!aError) {
            LTLog(@"退出登录成功");
            self.view.window.rootViewController = [[LTLoginVC alloc] init];
        } else {
            LTLog(@"退出登录失败%@", aError);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";

    self.userIDLabel.text = [NSString stringWithFormat:@"ID: %@", [EMClient sharedClient].currentUsername];
}

@end
