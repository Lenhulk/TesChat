//
//  LTIDCardCell.h
//  TesChat
//
//  Created by Lenhulk on 2016/12/20.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTIDCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (nonatomic, strong) EMMessage *message;

/**
 * 创建发送方IDCard的cell
 */
+ (instancetype)senderCellWithTableView:(UITableView *)tableView;

/**
 * 创建接收方IDCard的cell
 */
+ (instancetype)receiverCellWithTableView:(UITableView *)tableView;

@end
