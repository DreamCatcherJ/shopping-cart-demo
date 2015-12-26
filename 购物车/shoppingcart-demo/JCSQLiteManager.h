//
//  JCSQLiteManager.h
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCSingleton.h"

typedef void (^finishedBlock)(NSArray *array);

@interface JCSQLiteManager : NSObject

JCSingleton_h(SQLiteManager)

- (void)saveGoodsWithArr:(NSArray *)array;
- (void)loadGoodsWithFinished:(finishedBlock)block;
@end
