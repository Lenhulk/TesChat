//
//  LTMainVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/14.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTMainVC.h"
#import "LTSettingVC.h"
#import "LTContactVC.h"
#import "LTConversationVC.h"

@interface LTMainVC ()

@end

@implementation LTMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildsVCs];
}

/// 初始化子控制器
- (void)setupChildsVCs{

    LTConversationVC *sessionVc = [[LTConversationVC alloc] init];
    [self addChildVC:sessionVc title:@"微信" normalImg:@"tabbar_mainframe" selectedImg:@"tabbar_mainframeHL"];
    
    LTContactVC *contactVc = [[LTContactVC alloc] init];
    [self addChildVC:contactVc title:@"联系人" normalImg:@"tabbar_contacts" selectedImg:@"tabbar_contactsHL"];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LTSettingVC" bundle:nil];
    UIViewController *meVc = sb.instantiateInitialViewController;
    [self addChildVC:meVc title:@"我" normalImg:@"tabbar_me" selectedImg:@"tabbar_meHL"];
}

/// 创建导航控制器
- (void)addChildVC:(UIViewController *)vc title:(NSString *)title normalImg:(UIImage *)norImg selectedImg:(UIImage *)selImg{
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.image = [UIImage imageNamed:norImg];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selImg];
    nav.tabBarItem.title = title;
    [self addChildViewController:nav];
}

@end
