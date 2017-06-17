//
//  LTContactHeaderView.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/14.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTContactHeaderView.h"

@implementation LTContactHeaderView

+ (instancetype)headerView{
    LTContactHeaderView *headerView = [[LTContactHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
    return headerView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self setupButton:@"新朋友" img:@"add_friend_icon_offical"];
        [self setupButton:@"群聊" img:@"add_friend_icon_addgroup"];
    }
    return self;
}

- (void)setupButton:(NSString *)title img:(NSString *)image{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;   //左对齐
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.tag = self.subviews.count;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)btnClick:(UIButton *)btn{
    if (_selectedBlock) {
        _selectedBlock(btn.tag);
    }
}

- (UIView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[UIView alloc] initWithFrame:CGRectMake(35, 0, 16, 16)];
        _badgeView.backgroundColor = [UIColor redColor];
        _badgeView.layer.cornerRadius = 8;
        _badgeView.layer.masksToBounds = YES;
        [self addSubview:_badgeView];
    }
    return _badgeView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.frame = CGRectMake(0, btn.tag * 45, [UIScreen mainScreen].bounds.size.width, 44);
        }
    }
}

@end
