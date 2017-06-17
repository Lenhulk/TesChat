//
//  LTConversationCell.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/17.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTConversationCell.h"
#import "NSDate+Category.h"
#import "LTDBHelper.h"

@interface LTConversationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountLabel;

@end

@implementation LTConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"ConversationCell";
    LTConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    
    return cell;
}


/**
 * 设置数据
 */
- (void)setConversation:(EMConversation *)conversation{
    //显示用户名
    self.titleLabel.text = conversation.conversationId;
    
    //如果是群聊, 显示群名
    if (conversation.type == EMConversationTypeGroupChat) {
        self.titleLabel.text = [LTDBHelper groupnameByID:conversation.conversationId];
    }
    
    //获取最新消息
    EMMessage *message = conversation.latestMessage;
    EMMessageBody *body = message.body;
    
    //显示未读信息
    if (body.type == EMMessageBodyTypeText){
        EMTextMessageBody *textBody = body;
        self.subTitleLabel.text = textBody.text;
    } else if (body.type == EMMessageBodyTypeImage){
        self.subTitleLabel.text = @"[图片]";
    } else if (body.type == EMMessageBodyTypeVoice){
        self.subTitleLabel.text = @"[语音]";
        self.subTitleLabel.textColor = [UIColor redColor];
    } else {
        self.subTitleLabel.text = @"未识别消息类型";
    }
    
    //显示时间
    self.timeLabel.text = [NSDate formattedTimeFromTimeInterval:message.timestamp];
    
    //显示未读消息数
    if (conversation.unreadMessagesCount == 0) {
        self.unreadCountLabel.hidden = YES;
    } else {
        self.unreadCountLabel.text = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
    }
}

@end
