//
//  HYDatabase.h
//  数据库操作
//
//  Created by 黄悦 on 5/28/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYDatabase : NSObject

+ (HYDatabase *)shareDatabase;

+ (NSString *)filePath:(NSString *)fileName;

- (void)createTable:(NSArray *)objectNameArray;

- (void)insertObject:(id)obj;

- (void)insertArray:(NSArray *)array;

/**
 *  单条件查询
 *
 *  @param sql        基础查询语句
 *  @param objectName 对象名称
 *  @param condition  查询附加条件
 *  @param value      条件对应的value
 *
 *  @return 对象数组
 */
- (NSArray *)selectSql:(NSString *)sql
            objectName:(NSString *)objectName
             condition:(NSString *)condition
                 value:(id)value;
/**
 *  多条件查询
 *
 *  @param sql        基础查询语句
 *  @param objectName 对象名称
 *  @param conditions 查询附加条件
 *  @param valueArray 条件对应的value数组
 *
 *  @return 对象数组
 */
- (NSArray *)selectSql:(NSString *)sql objectName:(NSString *)objectName conditions:(NSString *)conditions valueArray:(NSArray *)valueArray;

- (void)deleteObject:(id)obj where:(NSString *)where;
- (void)deleteAllObjects:(NSString *)tableName;
@end
