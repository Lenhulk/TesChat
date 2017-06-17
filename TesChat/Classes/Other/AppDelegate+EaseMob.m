//
//  AppDelegate+EaseMob.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/16.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "EMClient.h"
#import "LTLoginVC.h"
#import "LTDBHelper.h"
#import "LTContactVC.h"

@implementation AppDelegate (EaseMob)

#pragma mark - EMClientDelegate代理
/// 返回自动登录结果
- (void)autoLoginDidCompleteWithError:(EMError *)aError{
    if (!aError) {
        LTLog(@"自动登录成功");
    } else {
        LTLog(@"自动登录失败");
    }
}

/// 帐号在其他设备登录
- (void)userAccountDidLoginFromOtherDevice{
    //切换回登录界面
    self.window.rootViewController = [[LTLoginVC alloc] init];
    
    //提示用户
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录提醒" message:@"当前帐号在其它设备登录，如非本人，请及时修改密码" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAc =  [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmAc];
    
    //弹框
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - EMContactManagerDelegate代理
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    LTLog(@"好友请求被%@通过~", aUsername);
}

- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
    LTLog(@"好友请求被%@拒绝!", aUsername);
}

- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage{
    LTLog(@"接收到好友请求:%@, %@", aUsername, aMessage);
    //把好友请求添加到数据库
    [LTDBHelper insertFriendRequest:aUsername message:aMessage];
    
    //查询有多少"好友请求记录条数"
//    NSInteger *frCount =  [LTDBHelper friendRequestCount];
    //设置badge
//    UIViewController *vc = self.window.rootViewController.childViewControllers[1];
//    vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", frCount];
    
    UINavigationController *contactNav = self.window.rootViewController.childViewControllers[1];
    LTContactVC *contactVc = contactNav.childViewControllers[0];
    [contactVc setupBadge];
}


@end
