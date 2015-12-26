//
//  JCShoppingCartCell.m
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//
#import "JCShoppingCartCell.h"
#import <Masonry.h>


@interface JCShoppingCartCell ()

@property (nonatomic,strong) UIButton *selectButton;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *NewPriceLabel;
@property (nonatomic,strong) UILabel *oldPriceLabel;
@property (nonatomic,strong) UIView *addAndsubtraction;
@property (nonatomic,strong) UIButton *subtractionButton;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UILabel *goodCountLabel;

@end

@implementation JCShoppingCartCell

- (void)setGood:(JCGood *)good{
    _good = good;
    self.iconView.image = [UIImage imageNamed:good.iconName];
    self.titleLabel.text = good.title;
    self.NewPriceLabel.text = [NSString stringWithFormat:@"%.2f",good.NewPrice];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"%.2f",good.oldPrice];
    self.goodCountLabel.text = [NSString stringWithFormat:@"%ld",good.count];
    
    self.selectButton.selected = good.selected;
    
}
/**
 *  点击加减
 */
- (void)didTappedCalculateButton:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(didTappedCalculateButton:cell:)]) {
        [self.delegate didTappedCalculateButton:btn.tag cell:self];
    }
}
/**
 *   头像旁的选择按钮
 */
- (void)didSelectedButton{  
    self.selectButton.selected = !self.selectButton.selected;
    self.good.selected = self.selectButton.selected;
    // 传给控制器
    if ([self.delegate respondsToSelector:@selector(shoppingCartCell:)]) {
        [self.delegate shoppingCartCell:self];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    JCShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JCShoppingCartCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // constrains
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@42);
            make.top.equalTo(@10);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_right).offset(12);
        }];
        [self.NewPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_top).offset(5);
            make.right.equalTo(@-12);
        }];
        [self.oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.NewPriceLabel.mas_bottom).offset(5);
            make.right.equalTo(@-12);
        }];
        [self.addAndsubtraction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@120);
            make.top.equalTo(@40);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
        [self.subtractionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@70);
            make.top.equalTo(@0);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        [self.goodCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@30);
            make.top.equalTo(@0);
            make.width.equalTo(@40);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

#pragma mark - lazy
- (UILabel *)goodCountLabel{
    if (!_goodCountLabel) {
        _goodCountLabel = [[UILabel alloc] init];
        [self.addAndsubtraction addSubview:_goodCountLabel];
        _goodCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodCountLabel;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addAndsubtraction addSubview:_addButton];
        _addButton.tag = BtnAdd;
        [_addButton setBackgroundImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(didTappedCalculateButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addButton;
}

- (UIButton *)subtractionButton{
    if (!_subtractionButton) {
        _subtractionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addAndsubtraction addSubview:_subtractionButton];
        _subtractionButton.tag = Btnsubtraction;
        [_subtractionButton setBackgroundImage:[UIImage imageNamed:@"subtraction_icon"] forState:UIControlStateNormal];
        [_subtractionButton addTarget:self action:@selector(didTappedCalculateButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subtractionButton;
}

- (UIView *)addAndsubtraction{
    if (!_addAndsubtraction) {
        _addAndsubtraction = [[UIView alloc] init];
        [self.contentView addSubview:_addAndsubtraction];
        _addAndsubtraction.backgroundColor = [UIColor colorWithWhite:.9 alpha:.8];
    }
    return _addAndsubtraction;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)NewPriceLabel{
    if (!_NewPriceLabel) {
        _NewPriceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_NewPriceLabel];
        _NewPriceLabel.textColor = [UIColor redColor];
    }
    return _NewPriceLabel;
}
- (UILabel *)oldPriceLabel{
    if (!_oldPriceLabel) {
        _oldPriceLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_oldPriceLabel];
        _oldPriceLabel.textColor = [UIColor grayColor];
    }
    return _oldPriceLabel;
}


- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        _iconView.layer.cornerRadius = 30;
        _iconView.clipsToBounds = YES;
    }
    return _iconView;
}
- (UIButton *)selectButton{
    
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_selectButton];
        [_selectButton setImage:[UIImage imageNamed:@"check_n"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"check_p"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(didSelectedButton) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton sizeToFit];
        
    }
    return _selectButton;
}

@end
