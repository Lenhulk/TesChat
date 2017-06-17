//
//  LTConversationCell.h
//  TesChat
//
//  Created by Lenhulk on 2016/12/17.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTConversationCell : UITableViewCell

/**
 * 创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) EMConversation *conversation;

@end
