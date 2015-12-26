//
//  JCShoppingCartCell.h
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCGood.h"

typedef NS_ENUM(NSUInteger,Btn){
    Btnsubtraction = 10,
    BtnAdd = 11
};

@class JCShoppingCartCell;

@protocol JCShoppingCartCellDelegate <NSObject>

@optional
- (void)shoppingCartCell:(JCShoppingCartCell *)cell;
- (void)didTappedCalculateButton:(Btn)btnType cell:(JCShoppingCartCell *)cell;
@end

@interface JCShoppingCartCell : UITableViewCell

@property (nonatomic,strong) JCGood *good;

@property (nonatomic,weak) id <JCShoppingCartCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@end
