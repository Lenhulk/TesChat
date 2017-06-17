//
//  LTDBHelper.m
//  TesChat
//
//  Created by Lenhulk on 2016/12/16.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

#import "LTDBHelper.h"
#import <FMDB.h>
#import "EMClient.h"
#import "LTFriendRequestModel.h"

@implementation LTDBHelper

//做一些执行一次性的操作(创建表)
+ (void)initialize{
    NSString *dbPath = [self dbPath];
    LTLog(@"数据库路径:%@", dbPath);
    
    //创建表的SQL语句
    NSString *createSQL = @"create table if not exists friendrequest(username text, message text)";
    //执行创建表的SQL语句
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]){
        BOOL success = [db executeUpdate:createSQL];
        if (!success) {
            LTLog(@"创建好友请求表失败%@", db.lastError);
            return;
        }
        [db close];
    }
}

+ (void)insertFriendRequest:(NSString *)username message:(NSString *)message{
    NSString *dbPath = [self dbPath];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        //插入数据之前,删除与username同名的数据
        NSString *deleteSQL = @"delete from friendrequest where username = ?";
        [db executeUpdate:deleteSQL withArgumentsInArray:@[username]];
        //插入新的username数据
        NSString *insertSQL = @"insert into friendrequest (username, message) values (?, ?)";
        BOOL success = [db executeUpdate:insertSQL withArgumentsInArray:@[username, message]];
        if (success) {
            LTLog(@"数据插入表成功");
        } else {
            LTLog(@"数据插入表失败%@", db.lastError);
        }
        
        [db close];
    }
    
}

+ (NSInteger)friendRequestCount{
    NSInteger frCount = 0;
    //执行SQL语句
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *querySQL = @"select count(*) from friendrequest";
        FMResultSet *result = [db executeQuery:querySQL];
        while (result.next) {
            frCount = [result intForColumnIndex:0];
        }
        [db close];
    }
    return frCount;
}

+ (NSArray *)friendRequestList{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    NSMutableArray *models = [NSMutableArray array];
    if ([db open]) {
        //执行SQL语句
        NSString *selectSQL = @"select * from friendrequest";
        FMResultSet *result = [db executeQuery:selectSQL];
        //遍历集合
        while (result.next) {
            LTFriendRequestModel *frModel = [[LTFriendRequestModel alloc] init];
            frModel.username = [result stringForColumn:@"username"];
            frModel.message = [result stringForColumn:@"message"];
            [models addObject:frModel];
        }
        [db close];
    }
    //利用"可变数组"经过copy之后变成就变成"不可变数组"的特性
    return [models copy];
}

+ (void)deleteFriendRequest:(NSString *)username{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    if ([db open]) {
        NSString *deleteSQL = @"delete from friendrequest where username = ?";
        BOOL success = [db executeUpdate:deleteSQL withArgumentsInArray:@[username]];
        if (success) {
            LTLog(@"删除数据库行%@成功", username);
        } else {
            LTLog(@"删除数据库行%@失败%@", username, db.lastError);
        }
        
        [db close];
    }
}


//获取数据库文件路径
+ (NSString *)dbPath{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbName = [EMClient sharedClient].currentUsername;
    NSString *dbPath = [NSString stringWithFormat:@"%@/HyphenateSDK/easemobDB/%@.db", docPath, dbName];
    return dbPath;
}


+ (NSString *)groupnameByID:(NSString *)groupId{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dbPath]];
    NSString *groupname = nil;
    if ([db open]){
        NSString *groupSQL = @"select groupsubject from 'group' where groupid = ?";
        FMResultSet *resultSet = [db executeQuery:groupSQL withArgumentsInArray:@[groupId]];
        while (resultSet.next) {
            groupname = [resultSet stringForColumn:@"groupsubject"];
        }
        [db close];
    }
    return groupname;
}


@end
