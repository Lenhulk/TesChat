//
//  LTAddNewFriendVC.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/14.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTAddNewFriendVC.h"
#import "EMClient.h"

@interface LTAddNewFriendVC ()
@property (weak, nonatomic) IBOutlet UITextField *idTextField;

@end

@implementation LTAddNewFriendVC

- (IBAction)addNewFriendAction:(id)sender {
    NSString *username = self.idTextField.text;
    [[EMClient sharedClient].contactManager addContact:username message:@"我是日天哥" completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            LTLog(@"添加好友请求 发送成功");
        } else {
            LTLog(@"添加好友请求 发送失败%@", aError);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
