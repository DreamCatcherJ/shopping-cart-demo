//
//  JCShoppingCartController.h
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCGood.h"
@class JCShoppingCartController;
@protocol JCShoppingCartControllerDelegate <NSObject>

@optional
- (void)shoppingCartController:(JCShoppingCartController *)shoppingCartController;

@end

@interface JCShoppingCartController : UIViewController

@property (nonatomic,weak) id <JCShoppingCartControllerDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *addGoodArray;

@end
