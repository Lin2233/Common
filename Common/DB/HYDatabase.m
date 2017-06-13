//
//  HYDatabase.m
//  数据库操作
//
//  Created by 黄悦 on 5/28/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import "HYDatabase.h"
#import "FMDB.h"
#import "MJExtension.h"
#import "NSObject+DHF.h"

@interface HYDatabase ()
@property (strong, nonatomic) FMDatabase *fmDB;
@end

@implementation HYDatabase

static HYDatabase * database;

+ (HYDatabase *)shareDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [[HYDatabase alloc] init];
    });
    return  database;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [super allocWithZone:zone];
    });
    return  database;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSString *fullPath = [HYDatabase filePath:@"data.db"];
        self.fmDB = [[FMDatabase alloc] initWithPath:fullPath];
        
        if ([self.fmDB open])
        {
            [self createTable:nil];
        }
    }
    return self;
}

- (void)createTable:(NSArray *)objectNameArray
{
    NSString *tableSql = @"CREATE TABLE IF NOT EXISTS %@(no integer PRIMARY KEY AUTOINCREMENT,%@)";
    // 获取每个模型类名字符串
    for (NSString *modelName in objectNameArray)
    {
        Class newClass = NSClassFromString(modelName);
        if (newClass)
        {
            NSString *createSql = [self p_createTablePropertyListSQL:newClass];
            NSString *sql = [NSString stringWithFormat:tableSql, modelName, createSql];
            NSLog(@"创建新表:%@", sql);
            BOOL bSuccess = [self.fmDB executeUpdate:sql];
            if (!bSuccess)
            {
                NSLog(@"创建表失败:%@", [self.fmDB lastErrorMessage]);
            }
        }
    }
}

- (void)insertObject:(id)obj
{
    NSDictionary *dic = [obj keyValues];
    NSArray *propertyKeys = dic.allKeys;
    NSArray *propertyValues = dic.allValues;
    
    NSString *keySql = [propertyKeys componentsJoinedByString:@","];
    
    NSMutableString *valueSql = [NSMutableString string];
    NSInteger nCount = propertyValues.count;
    for (int i = 0; i < nCount; i++)
    {
        if (i == 0)
        {
            [valueSql appendFormat:@"?"];
        }
        else
        {
            [valueSql appendFormat:@",?"];
        }
    }
    NSString *tableName = NSStringFromClass([obj class]);
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)", tableName, keySql, valueSql];
    BOOL bSuccess = [self.fmDB executeUpdate:sql withArgumentsInArray:propertyValues];
    if (!bSuccess)
    {
        NSLog(@"插入失败:%@", [self.fmDB lastErrorMessage]);
    }
}

- (void)insertArray:(NSArray *)array
{
    [self.fmDB beginTransaction];
    for (id obj in array)
    {
        [self insertObject:obj];
    }
    [self.fmDB commit];
}

- (NSArray *)selectSql:(NSString *)sql objectName:(NSString *)objectName condition:(NSString *)condition value:(id)value
{
    return [self selectSql:sql objectName:objectName conditions:condition valueArray:@[value]];
}

- (NSArray *)selectSql:(NSString *)sql objectName:(NSString *)objectName conditions:(NSString *)conditions valueArray:(NSArray *)valueArray
{
    NSString *selectSql = @"";
    FMResultSet *rs = nil;
    if (conditions)
    {
        selectSql = [NSString stringWithFormat:@"%@ %@", sql, conditions];
        rs = [self.fmDB executeQuery:selectSql withArgumentsInArray:valueArray];
    }
    else
    {
        rs = [self.fmDB executeQuery:selectSql];
    }
    
    NSLog(@"%@", [self.fmDB lastErrorMessage]);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    while ([rs next])
    {
        NSDictionary *dic = [rs resultDictionary];
        Class newClass = NSClassFromString(objectName);
        id object = [[newClass alloc] init];
        [object setKeyValues:dic];
        [resultArray addObject:object];
    }
    return [resultArray copy];
}

- (void)deleteObject:(id)obj where:(NSString *)where
{
    NSString *tableName = NSStringFromClass([obj class]);
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=?", tableName, where];
    BOOL bSuccess = [self.fmDB executeUpdate:sql, [obj valueForKey:where]];
    if (!bSuccess)
    {
        NSLog(@"删除失败:%@", [self.fmDB lastErrorMessage]);
    }
}

- (void)deleteAllObjects:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    BOOL bSuccess = [self.fmDB executeUpdate:sql];
    if (!bSuccess)
    {
        NSLog(@"全部删除失败:%@", [self.fmDB lastErrorMessage]);
    }
}

+ (NSString *)filePath:(NSString *)fileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path])
    {
        if (fileName && [fileName length] != 0)
        {
            path = [path stringByAppendingPathComponent:fileName];
        }
    }
    else
    {
        NSLog(@"指定目录不存在!");
    }
    return path;
}


#pragma mark - private methods
- (NSString *)p_createTablePropertyListSQL:(id)modelObject
{
    NSDictionary *dic = [modelObject propertyList:NO];
    NSString *sql = [[dic allKeys] componentsJoinedByString:@" text,"];
    sql = [sql stringByAppendingString:@" text"];
    NSLog(@"%@", sql);
    return sql;
}


@end

















