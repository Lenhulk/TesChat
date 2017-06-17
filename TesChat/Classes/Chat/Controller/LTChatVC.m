//
//  LTChatVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/17.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTChatVC.h"
#import "LTIDCardCell.h"
#import "LTDBHelper.h"

@interface LTChatVC () <EaseChatBarMoreViewDelegate>

@end

@implementation LTChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导入下拉刷新功能
    self.showRefreshHeader = YES;
    
    //设置数据源(表情数据..)
    self.dataSource = self;
    
    //设置代理方法
    self.delegate = self;
    
    //设置标题
    self.title = self.conversation.conversationId;
    
    //群聊标题应该是群名称
    if (self.conversation.type == EMConversationTypeGroupChat) {
        self.title = [LTDBHelper groupnameByID:self.conversation.conversationId];
//        self.title = self.group.subject;
    }
    
    //在chatBar中添加按钮
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"IDCard"] highlightedImage:nil title:nil];
    self.chatBarMoreView.delegate = self;
}

//发名片
- (void)sendIDCardMsg{
    NSMutableDictionary *idCardInfo = [NSMutableDictionary dictionary];
    idCardInfo[@"type"] = @"1";
    idCardInfo[@"headURL"] = @"http://diy.qqjay.com/u2/2012/0924/7032b10ffcdfc9b096ac46bde0d2925b.jpg";
    idCardInfo[@"username"] = @"Liuhui";
    
    [self sendTextMessage:@"名片" withExt:idCardInfo];
}

//发红包
- (void)sendRedBagMsg{
    NSMutableDictionary *redBagInfo = [NSMutableDictionary dictionary];
    redBagInfo[@"amout"] = @"88.88";
    redBagInfo[@"redBagType"] = @"1";  //1.单聊  2.群红包
    
    [self sendTextMessage:@"红包来啦" withExt:redBagInfo];
}


#pragma mark - EaseChatBarMoreViewDelegate

/**
 * 可在此方法实现额外的点击事件(发红包/名片等...)
 */
- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index{
    [self sendIDCardMsg];
//    [self sendRedBagMsg];
}

// 返回自定义cell
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel{
    EMMessage *msg = [messageModel message];
    //type == 1, 名片信息(自已定义type等于的类型)
    if ([msg.ext[@"type"] isEqualToString:@"1"]) {
        BOOL isSender = [msg.from isEqualToString:[EMClient sharedClient].currentUsername];
        LTIDCardCell *cell = nil;
        if (isSender) {   //发送方
            cell = [LTIDCardCell senderCellWithTableView:tableView];
        } else {    //接收方
            cell = [LTIDCardCell receiverCellWithTableView:tableView];
        }
        cell.message = msg;
        return cell;
    }
    return nil;
}

// 返回自定义cell的高度
- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth{
    EMMessage *msg = [messageModel message];
    if ([msg.ext[@"type"] isEqualToString:@"1"]) {
        return 95;
    }
    return 0;
}



@end
