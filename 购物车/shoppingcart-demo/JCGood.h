//
//  JCGood.h
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCGood : NSObject

@property (nonatomic,copy) NSString *iconName;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,assign) double NewPrice;
@property (nonatomic,assign) double oldPrice;
@property (nonatomic,assign) BOOL alreadyAddShoppingCart;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) NSUInteger count;
@property (nonatomic,assign) NSInteger goodId;
@end
