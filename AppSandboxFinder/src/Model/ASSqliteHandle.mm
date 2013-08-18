//
//  ASSqliteHandle.m
//  AppSandboxFinder
//
//  Created by Jamin on 7/25/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASSqliteHandle.h"
#import "ASConstants.h"

@interface ASSqliteHandle()
{
    NSString *              _dbName;
}

@end

@implementation ASSqliteHandle

#pragma mark - Lifecycle
- (id)initWithDbPath:(NSString *)dbPath
{
    self = [super init];
    if (self) {
        _dbName = ASReturnRetained([dbPath lastPathComponent]);
        const char * cDbPath = [dbPath UTF8String];
        if (SQLITE_OK != sqlite3_open(cDbPath, &_sqliteDB)) {
            sqlite3_close(_sqliteDB);
			NSAssert(NO, @"Failed to open database");
        }
    }

    return self;
}


- (void)dealloc {
	sqlite3_close(_sqliteDB);

#if ! __has_feature(objc_arc)
    [_dbName release];
    [super dealloc];
#endif
}

#pragma mark - Public
- (NSArray *)getDbTableInfos
{
    NSArray * tablesResult = nil;
    NSString * sqlStr = @"SELECT * FROM sqlite_master WHERE type='table';";//[NSString stringWithFormat:@"SELECT * FROM %@.sqlite_master WHERE type='table';", _dbName];
    [self queryResult:&tablesResult withSql:sqlStr];
    NSLog(@"query tables:%@", tablesResult);

    NSMutableArray * tableNames = [NSMutableArray arrayWithCapacity:(tablesResult.count - 1)];
    for (NSDictionary * tableRecord in tablesResult) {
        NSString * name = [tableRecord objectForKey:@"name"];
        if (nil != name) {
            [tableNames addObject:name];
        }
    }

    return [tableNames sortedArrayUsingComparator:^NSComparisonResult(NSString * name1, NSString * name2) {
        return [name1 localizedStandardCompare:name2];
    }];
}


- (NSArray *)columnsOfTable:(NSString *)tableName
{
    NSArray * columnsResult = nil;
    NSString * sqlStr = [NSString stringWithFormat:@"PRAGMA table_info(%@);", tableName];
    [self queryResult:&columnsResult withSql:sqlStr];
    NSLog(@"query tables:%@", columnsResult);

    NSMutableArray * columnInfos = [NSMutableArray arrayWithCapacity:columnsResult.count];
    for (NSDictionary * columnDict in columnsResult)
    {
        ASDBColumn * column = [[ASDBColumn alloc] init];
        column.cid = [[columnDict objectForKey:@"cid"] integerValue];
        column.name = [columnDict objectForKey:@"name"];
        column.isNotNull = [[columnDict objectForKey:@"notnull"] boolValue];
        column.isPK = [[columnDict objectForKey:@"pk"] boolValue];
        column.type = [columnDict objectForKey:@"type"];

        [columnInfos addObject:column];
    }

    return columnInfos;
}



- (NSArray *)queryTableRows:(NSString *)tableName
              orderByColumn:(NSString *)columnName
                    inOrder:(NSComparisonResult)order
                  withLimit:(NSInteger)limit
{

    NSAssert((nil != tableName), @"table name can't be nil!");

    limit = (limit > 0 ? limit : NSUIntegerMax);

    NSArray * rowsResult = nil;
    NSString * sqlStr = nil;
    if (nil != columnName) {
        NSString * dbOrder = [NSString stringWithFormat:@"ORDER BY %@ %@ ", columnName, [self dbOrderOfComparion:order]];
        sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ %@ LIMIT %d;", tableName, dbOrder, limit];
    } else {
        sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d;", tableName, limit];
    }

    [self queryResult:&rowsResult withSql:sqlStr];
    NSLog(@"query tables:%@", rowsResult);

    return rowsResult;
}



- (BOOL)queryResult:(NSArray **)result withSql:(NSString *)sql
{
    NSAssert(_sqliteDB, @"database is available");
	NSAssert(sql != nil, @"empty query");

	// 如果SQL返回了一个单行结果集，sqlite3_step() 函数将返回 SQLITE_ROW ,
    // 如果SQL语句执行成功或者正常将返回 SQLITE_DONE , 否则将返回错误代码.
    // 如果不能打开数据库文件则会返回 SQLITE_BUSY .
    // 如果函数的返回值是 SQLITE_ROW, 那么下边的这些方法可以用来获得记录集行中的数据:
	// sqlite3_column_name() 返回第N列的字段名.
	// sqlite3_column_bytes() 用来返回 UTF-8 编码的BLOBs列的字节数或者TEXT字符串的字节数.
	// sqlite3_column_bytes16() 对于BLOBs列返回同样的结果，但是对于TEXT字符串则按 UTF-16 的编码来计算字节数.
    // sqlite3_column_blob() 返回 BLOB 数据.
    // sqlite3_column_text() 返回 UTF-8 编码的 TEXT 数据.
    // sqlite3_column_text16() 返回 UTF-16 编码的 TEXT 数据.
    // sqlite3_column_int() 以本地主机的整数格式返回一个整数值.
    // sqlite3_column_int64() 返回一个64位的整数.
    // sqlite3_column_double() 返回浮点数.
	// sqlite3_column_count()函数返回结果集中包含的列数. sqlite3_column_count() 可以在执行了 sqlite3_prepare()之后的任何时刻调用.
	// sqlite3_data_count()除了必需要在sqlite3_step()之后调用之外，其他跟sqlite3_column_count() 大同小异.
    // 如果调用sqlite3_step() 返回值是 SQLITE_DONE 或者一个错误代码, 则此时调用sqlite3_data_count() 将返回 0 ，然而 sqlite3_column_count() 仍然会返回结果集中包含的列数.

    sqlite3_stmt * sqlStmt;
    *result = nil;

    int prepare_ret = sqlite3_prepare_v2(_sqliteDB, [sql UTF8String], -1, &sqlStmt, nil);

    if (prepare_ret != SQLITE_OK) {
        NSAssert1(NO, @"sqlite prepare error,ret is %d", prepare_ret);
        return NO;
    }

    int columnCount = sqlite3_column_count(sqlStmt);
    NSMutableArray * columnNames = [NSMutableArray arrayWithCapacity:columnCount];
    for (int i = 0; i < columnCount; i++) {
        char * name = (char *)sqlite3_column_name(sqlStmt, i);
        NSString * fieldName = [[NSString alloc] initWithUTF8String:name];
        [columnNames addObject:fieldName];
        ASRelease(fieldName);
    }

    NSMutableArray * queryResult = [NSMutableArray arrayWithCapacity:10];
    while (sqlite3_step(sqlStmt) == SQLITE_ROW) {
        NSMutableDictionary * record = [[NSMutableDictionary alloc] init];
        for (int column = 0; column < columnCount; column++) {
            char * rowData = (char *)sqlite3_column_text(sqlStmt, column);
            NSString * fieldValue = nil;
            if (NULL != rowData) {
                fieldValue = [[NSString alloc] initWithUTF8String:rowData];
            } else {
                continue;
            }
            NSString * columnName = columnNames[column];
            [record setValue:fieldValue forKey:columnName];
            ASRelease(columnName);
        }
        [queryResult addObject:record];
        ASRelease(record);
    } //while

    *result = queryResult;
    sqlite3_finalize(sqlStmt);

    return YES;
}



- (void)closeDb
{
	sqlite3_close(_sqliteDB);
}

#pragma mark - Private
- (NSString *)dbOrderOfComparion:(NSComparisonResult)comparsion
{
    if (comparsion == NSOrderedDescending) {
        return @"DESC";
    } else {
        return @"ASC";
    }
}

@end
