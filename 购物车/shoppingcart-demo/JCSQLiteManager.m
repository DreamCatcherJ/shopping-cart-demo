//
//  JCSQLiteManager.m
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "JCSQLiteManager.h"
#import <FMDB.h>
#import "JCGood.h"
#import <YYModel.h>

@interface JCSQLiteManager ()

@property (nonatomic,strong) FMDatabaseQueue *dbQueue;

@end

@implementation JCSQLiteManager

JCSingleton_m(SQLiteManager)

- (instancetype)init{
    __block id temp = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((temp = [super init])) {// 初始化
            
            // 打开数据库
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shoppingcartGoods"];
            FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
            self.dbQueue = dbQueue;
            // 创建表
            [self createTable:@"T_Good"];

            
        }
    });
    self = temp;
    return self;
}

- (void)createTable:(NSString *)name{

    NSString *tablePath = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"sql"];
    NSData *data = [NSData dataWithContentsOfFile:tablePath];
    NSString *sqlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        if ([db executeStatements:sqlStr]) {
            NSLog(@"执行成功");
        }
        
    }];

    
}

- (void)saveGoodsWithArr:(NSArray *)array{

    NSString *sql = @"INSERT OR REPLACE INTO T_Good (goodId, good) VALUES (?, ?)";
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        for (JCGood *good in array) {
            // 数据库中不能直接存放字典,可以存放字符串
            // 字典(json) -> NSData -> String
            // 对象转为字典
#warning ...
            NSData *data = [good yy_modelToJSONData];
            NSString *goodStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if([db executeUpdate:sql withArgumentsInArray:@[@(good.goodId),goodStr]]){
                NSLog(@"添加数据库成功");
            }
        }
        
    }];
}

- (void)loadGoodsWithFinished:(finishedBlock)block{

    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM T_Good \n"];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *res = [db executeQuery:sql];
        if (!res) {
            NSLog(@"没有数据");return;
        }
        
        NSMutableArray *temp = [NSMutableArray array];
        
        while ([res next]) {
            NSString *goodStr = [res stringForColumn:@"good"];
            // String -> NSData -> JSON
            NSData *data = [goodStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            [temp addObject:dic];
        }
        block(temp);
        
    }];
    
}

@end
