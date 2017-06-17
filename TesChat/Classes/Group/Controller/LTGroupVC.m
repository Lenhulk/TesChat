//
//  LTGroupVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/18.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTGroupVC.h"
#import "LTCreateGroupVC.h"
#import "LTChatVC.h"

@interface LTGroupVC ()
@property (nonatomic, strong) NSArray *groups;
@end

@implementation LTGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群列表";
    //添加右边的Item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"创建群" style:0 target:self action:@selector(gotoCreateGroupVC)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //添加搜索框
    CGRect frm = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frm];
    searchBar.placeholder = @"请输入要搜索的群名称";
    self.tableView.tableHeaderView = searchBar;

}

- (void)viewWillAppear:(BOOL)animated{
    //显示列表数据
    [self loadData];
}

// 进入创建群界面
- (void)gotoCreateGroupVC{
    LTCreateGroupVC *createVc = [[LTCreateGroupVC alloc] init];
    [self.navigationController pushViewController:createVc animated:YES];
}

// 加载数据
- (void)loadData{
    [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        self.groups = aList;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"GroupCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    EMGroup *group = self.groups[indexPath.row];
    cell.textLabel.text = group.subject;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMGroup *group = self.groups[indexPath.row];
    LTChatVC *chatVc = [[LTChatVC alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
    chatVc.group = group;
    [self.navigationController pushViewController:chatVc animated:YES];
}


@end
