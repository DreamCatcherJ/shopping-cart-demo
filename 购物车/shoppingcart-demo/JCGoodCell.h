//
//  JCGoodCell.h
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCGood.h"
@class JCGoodCell;

@protocol JCGoodCellDelegate <NSObject>

@optional
- (void)goodCell:(JCGoodCell *)goodcell;
@end

@interface JCGoodCell : UITableViewCell

@property (nonatomic,strong,readonly) UIImageView *iconView;

@property (nonatomic,strong) JCGood *good;
@property (nonatomic,weak) id <JCGoodCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
