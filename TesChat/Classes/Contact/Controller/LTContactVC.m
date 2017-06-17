//
//  LTContactVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/14.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTContactVC.h"
#import "LTAddNewFriendVC.h"
#import "EMClient.h"
#import "LTContactHeaderView.h"
#import "LTDBHelper.h"
#import "LTFriendRequestListVC.h"
#import "LTChatVC.h"
#import "LTGroupVC.h"

@interface LTContactVC ()
/**
 * 存储好友列表数据
 */
@property (nonatomic, strong) NSMutableArray *contactsM;
@end

@implementation LTContactVC

- (NSMutableArray *)contactsM{
    if (!_contactsM) {
        _contactsM = [NSMutableArray array];
    }
    return _contactsM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    //1添加导航栏按钮
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(jumptoAddVC)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    //2显示好友列表数据
    //获取本地存储的所有好友
    NSArray *contacts = [[EMClient sharedClient].contactManager getContacts];
    [self.contactsM addObjectsFromArray:contacts];
    //本地没有好友数据，从服务获取
    if (self.contactsM.count == 0) {
        [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
            if (!aError) {
                LTLog(@"从服务器获取好友列表...");
                [self.contactsM addObjectsFromArray:aList];
                [self.tableView reloadData];
            } else {
                LTLog(@"从服务器获取好友列表失败!");
            }
        }];
    }
    
    //3添加headerView
    LTContactHeaderView *headerV = [LTContactHeaderView headerView];
    self.tableView.tableHeaderView = headerV;
    
    //4显示headerView的BadgeView
//    headerV.badgeView.hidden = ([LTDBHelper friendRequestCount] == 0);
    
    //5监听headerView的点击
    headerV.selectedBlock = ^(NSInteger index){
        UIViewController *vc = nil;
        if (index == 0) {   //进入好友请求列表界面
            vc = [[LTFriendRequestListVC alloc] init];
        } else {    //进入群界面
            vc = [[LTGroupVC alloc] init];
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
}

/// 跳转到添加好友页面
- (void)jumptoAddVC{
    LTAddNewFriendVC *addVc = [[LTAddNewFriendVC alloc] init];
    [self.navigationController pushViewController:addVc animated:true];
}

- (void)viewWillAppear:(BOOL)animated{
    [self setupBadge];
}

/**
 * 重新设置badge
 */
- (void)setupBadge{
    NSInteger count = [LTDBHelper friendRequestCount];
    //1 设置headerView的badge
    LTContactHeaderView *headerView = self.tableView.tableHeaderView;
    headerView.badgeView.hidden = count==0;
    //2 设置tabbarItem的badge
    if (count == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    } else {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", count];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contactsM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.contactsM[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *username = self.contactsM[indexPath.row];
    LTChatVC *chatVc = [[LTChatVC alloc] initWithConversationChatter:username conversationType:EMConversationTypeChat];
    chatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVc animated:true];
}


@end
