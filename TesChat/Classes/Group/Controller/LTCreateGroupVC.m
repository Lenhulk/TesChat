//
//  LTCreateGroupVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/18.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTCreateGroupVC.h"

@interface LTCreateGroupVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *groupnameTF;
@property (weak, nonatomic) IBOutlet UITableView *friendsListTV;
@property (nonatomic, strong) NSArray *contacts;        //显示的好友
@property (nonatomic, strong) NSMutableArray *inviteFriends;   //将要邀请加入群的好友
@end

@implementation LTCreateGroupVC

- (NSMutableArray *)inviteFriends{
    if (!_inviteFriends) {
        _inviteFriends = [NSMutableArray array];
    }
    return _inviteFriends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建群";
    //从本地获取联系人
    self.contacts = [[EMClient sharedClient].contactManager getContacts];
    //设置为可编辑
    self.friendsListTV.editing = YES;
    //添加右边的item
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:0 target:self action:@selector(createGroup)];
    self.navigationItem.rightBarButtonItem = item;
}

// 创建群方法
- (void)createGroup{
    NSString *subject = self.groupnameTF.text;
    NSString *description = @"全世界最帅的人们";
    NSString *message = @"欢迎你进入颜值最高的人群!";
    
    //群组属性
    EMGroupOptions *groupOp = [[EMGroupOptions alloc] init];
    groupOp.style = EMGroupStylePublicOpenJoin;
    
    //创建群
    [[EMClient sharedClient].groupManager createGroupWithSubject:subject description:description invitees:self.inviteFriends message:message setting:groupOp completion:^(EMGroup *aGroup, EMError *aError) {
        if (!aError) {
            LTLog(@"创建群成功, 群成员: %@", self.inviteFriends);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"创建群成功" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ac];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            LTLog(@"创建群失败, 错误: %@", aError);
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate/DataSource
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Insert&Delete结合变成可勾选类型
    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}

- (NSInteger)tableView:(UITableView *)friendsListTV numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)friendsListTV cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"CreateGroupCell";
    UITableViewCell *cell = [friendsListTV dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.contacts[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.inviteFriends addObject:self.contacts[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.inviteFriends removeObject:self.contacts[indexPath.row]];
}

@end
