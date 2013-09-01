//
//  ASSqliteHandle.h
//  AppSandboxFinder
//  ASSqliteHandle，即读写数据库的Handle
//  Created by Jamin on 7/25/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "ASDBTable.h"
#import "ASDBColumn.h"

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
 * 获取table的列数据
 *  @param tableName 数据表的名称
 *  @return list of ASColumn
 */
- (NSArray *)columnsOfTable:(NSString *)tableName;


/*
 * 查询数据表tableName的行数据
 *  @param tableName 数据表的名称
 *  @param columnName 排序列名
 *  @param order 排序方式:NSOrderedAscending或者NSOrderedDescending，升序或者降序
 *  @param limit 
 *  @return 返回查询到的数据
 */
- (NSArray *)queryTableRows:(NSString *)tableName
              orderByColumn:(NSString *)columnName
                    inOrder:(NSComparisonResult)order
                  withLimit:(NSInteger)limit;



/*
 * 数据库查询操作
 *  @param result 查询结果
 *  @param sql 查询sql语句
 *  @return 返回数据库查询操作是否完成
 */
- (BOOL)queryResult:(NSArray **)result withSql:(NSString *)sql;



/*
 * 关闭数据库
 */
- (void)closeDb;


@end
