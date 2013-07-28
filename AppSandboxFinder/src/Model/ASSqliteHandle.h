//
//  ASSqliteHandle.h
//  AppSandboxFinder
//  ASSqliteHandle，即读写数据库的Handle
//  Created by Jamin on 7/25/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ASSqliteHandle : NSObject
{
    sqlite3 * _sqliteDB;
}


/*
 * 使用sqlite db路径进行初始化
 */
- (id)initWithDbPath:(NSString *)dbPath;

/*
 * 获取sqlite db的表
 */
- (NSArray *)getDbTableInfos;

/*
 * 使用sqlite db路径进行初始化
 */
- (BOOL)queryResult:(NSArray **)result withSql:(NSString *)sql;



- (void)closeDb;


@end
