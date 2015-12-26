//
//  JCGoodCell.m
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "JCGoodCell.h"
#import <Masonry.h>

@interface JCGoodCell ()

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleView;
@property (nonatomic,strong) UILabel *descView;
@property (nonatomic,strong) UIButton *addCartButton;

@end

@implementation JCGoodCell


- (void)didTappedAddCartButton{

    if ([self.delegate respondsToSelector:@selector(goodCell:)]) {
        [self.delegate goodCell:self];
    }
}

#pragma mark - lazy
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 30;
        _iconView.clipsToBounds = YES;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)titleView{

    if (!_titleView) {
        _titleView = [[UILabel alloc] init];
        [self.contentView addSubview:_titleView];
    }
    return _titleView;
}
- (UILabel *)descView{
    
    if (!_descView) {
        _descView = [[UILabel alloc] init];
        [self.contentView addSubview:_descView];
    }
    return _descView;
}
- (UIButton *)addCartButton{

    if (!_addCartButton) {
        _addCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_addCartButton];
        [_addCartButton setBackgroundImage:[UIImage imageNamed:@"button_add_cart"] forState:UIControlStateNormal];
        [_addCartButton setTitle:@"购买" forState:UIControlStateNormal];
        [_addCartButton addTarget:self action:@selector(didTappedAddCartButton) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addCartButton;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    JCGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"good" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.top.equalTo(@10);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_right).offset(12);
        }];
        [self.descView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom).offset(10);
            make.left.equalTo(self.iconView.mas_right).offset(12);
        }];
        [self.addCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-12);
            make.top.equalTo(@25);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (void)setGood:(JCGood *)good{
    _good = good;
    self.iconView.image = [UIImage imageNamed:good.iconName];
    self.titleView.text = good.title;
    self.descView.text = good.desc;
    
}

@end
