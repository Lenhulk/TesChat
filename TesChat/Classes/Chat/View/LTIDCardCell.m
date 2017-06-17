//
//  LTIDCardCell.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/20.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTIDCardCell.h"
#import "UIImageView+EMWebCache.h"

static NSString *sendIDCardID = @"SenderIDCardCell";
static NSString *recvIDCardID = @"ReceiverIDCardCell";

@interface LTIDCardCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation LTIDCardCell

+ (instancetype)senderCellWithTableView:(UITableView *)tableView{
    LTIDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:sendIDCardID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    }
    return cell;
}

+ (instancetype)receiverCellWithTableView:(UITableView *)tableView{
    LTIDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:recvIDCardID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置背景图片
    UIImage *bgImg = nil;
        //判断是发送方还是接收方
    BOOL isSender = [self.reuseIdentifier isEqualToString:sendIDCardID];
    if (isSender) {
        bgImg = [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_bg"];
    } else {
        bgImg = [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"];
    }
        //拉伸图片
    bgImg = [bgImg stretchableImageWithLeftCapWidth:bgImg.size.width * 0.5 topCapHeight:bgImg.size.height * 0.7];
    self.bgImageView.image = bgImg;
}


/**
 * 设置名片信息
 */
- (void)setMessage:(EMMessage *)message{
    _message = message;
    
    NSString *iconImgURL = message.ext[@"headURL"];
    [self.iconImageView sd_setImageWithURL:iconImgURL];
    
    self.usernameLabel.text = message.ext[@"username"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
