//
//  LTDBHelper.h
//  TesChat
//
//  Created by Lenhulk on 2016/12/16.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTDBHelper : NSObject


/**
 * 插入好友请求
 */
+ (void)insertFriendRequest:(NSString *)username message:(NSString *)message;

/**
 * 返回好友请求记录条数
 */
+ (NSInteger)friendRequestCount;

/**
 * 返回好友请求列表
 */
+ (NSArray *)friendRequestList;

/**
 * 移除好友请求
 */
+ (void)deleteFriendRequest:(NSString *)username;

/**
 * 通过ID查找群名称
 */
+ (NSString *)groupnameByID:(NSString *)groupID;


@end
