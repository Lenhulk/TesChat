//
//  LTConversationVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/17.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTConversationVC.h"
#import "EMClient.h"
#import "LTConversationCell.h"
#import "LTChatVC.h"

@interface LTConversationVC () <EMChatManagerDelegate>
/**
 * 表格数据源
 */
@property (nonatomic, strong) NSMutableArray *conversationM;
@end

@implementation LTConversationVC

- (NSMutableArray *)conversationM{
    if (!_conversationM) {
        _conversationM = [NSMutableArray array];
    }
    return _conversationM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"微信";
    
    //1.获取历史数据
    NSArray *convs = [[EMClient sharedClient].chatManager getAllConversations];
    [self.conversationM addObjectsFromArray:convs];
    
    //2.显示总的未读消息数
    [self setupUnreadCountBadge];
    
    //3.监听接收到消息
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

/**
 * 设置tabbarItem的badge(未读消息)
 */
- (void)setupUnreadCountBadge{
    NSInteger count = 0;
    for (EMConversation *conver in self.conversationM) {
        count += conver.unreadMessagesCount;
    }
    if (count == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    } else {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", count];
    }
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.conversationM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LTConversationCell *cell = [LTConversationCell cellWithTableView:tableView];
    
    //显示数据
    EMConversation *conversation = self.conversationM[indexPath.row];
    cell.conversation = conversation;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出会话对象
    EMConversation *conversation = self.conversationM[indexPath.row];
    
    //删除会话对象
    [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        LTLog(@"成功删除会话");
        [self.conversationM removeObject:conversation];
        [self.tableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMConversation *conver = self.conversationM[indexPath.row];

    //进入聊天界面
    LTChatVC *chatVc = [[LTChatVC alloc] initWithConversationChatter:conver.conversationId conversationType:EMConversationTypeChat];
    chatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark - EMChatManagerDelegate 
/**
 * 接收到新聊天信息
 */
- (void)messagesDidReceive:(NSArray *)aMessages{
    [self setupUnreadCountBadge];
    [self.tableView reloadData];
}

/**
 * 会话列表更新
 */
- (void)conversationListDidUpdate:(NSArray *)aConversationList{
    //移除所有会话消息重新添加
    [self.conversationM removeAllObjects];
    [self.conversationM addObjectsFromArray:aConversationList];
    [self setupUnreadCountBadge];
    [self.tableView reloadData];
}

@end
