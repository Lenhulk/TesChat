//
//  LTFriendRequestListVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/16.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTFriendRequestListVC.h"
#import "LTDBHelper.h"
#import "LTFriendRequestModel.h"
#import "EMClient.h"

@interface LTFriendRequestListVC ()
@property (nonatomic, strong) NSMutableArray *friendRequestListM;
@end

@implementation LTFriendRequestListVC

- (NSMutableArray *)friendRequestListM{
    if (!_friendRequestListM) {
        _friendRequestListM = [NSMutableArray array];
    }
    return _friendRequestListM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友请求列表";
    
    //加载好友请求数据
    NSArray *frList = [LTDBHelper friendRequestList];
    [self.friendRequestListM addObjectsFromArray:frList];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendRequestListM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"frCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        //添加按钮
        UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agreeBtn.backgroundColor = [UIColor greenColor];
        CGFloat btnW = 60;
        CGFloat btnH = 44;
        agreeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - btnW, 0, btnW, btnH);
        [agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];

        cell.accessoryView = agreeBtn;
    }
    
    //显示数据
    LTFriendRequestModel *model = self.friendRequestListM[indexPath.row];
    cell.textLabel.text = model.username;
    cell.detailTextLabel.text = model.message;
    
    return cell;
}

// 实现同意好友请求
- (void)agreeAction:(UIButton *)btn{
    //获取添加的好友名称
    LTFriendRequestModel *model = self.friendRequestListM[btn.tag];
    NSString *username = model.username;
    //发同意的网络请求
    [[EMClient sharedClient].contactManager approveFriendRequestFromUser:username completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            LTLog(@"你已同意了%@的好友请求", aUsername);
            [self reloadData:model];
        } else {
            LTLog(@"通过好友请求发送失败", aError);
        }
    }];
}

// 实现此方法可删除cell(实现删除好友请求)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    LTFriendRequestModel *model = self.friendRequestListM[indexPath.row];
    NSString *username = model.username;
    //发拒绝的网络请求
    [[EMClient sharedClient].contactManager declineFriendRequestFromUser:username completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            LTLog(@"你已拒绝了%@的好友请求", aUsername);
            [self reloadData:model];
        } else {
            LTLog(@"拒绝好友请求发送失败%@", aError);
        }
    }];
}

/**
 * 刷新tableView的数据源和数据库信息
 */
- (void)reloadData:(LTFriendRequestModel *)model{
    [self.friendRequestListM removeObject:model];
    [self.tableView reloadData];
    [LTDBHelper deleteFriendRequest:model.username];
}

@end
