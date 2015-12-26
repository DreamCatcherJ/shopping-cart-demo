//
//  JCShoppingCartController.m
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "JCShoppingCartController.h"
#import "JCShoppingCartCell.h"
#import <Masonry.h>
#import "JCSQLiteManager.h"
@interface JCShoppingCartController () <UITableViewDelegate,UITableViewDataSource,JCShoppingCartCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,strong) UILabel *totalPriceLabel;

@property (nonatomic,strong) UIButton *buyButton;

@property (nonatomic,assign) double price;

@end

@implementation JCShoppingCartController
/**
 *  底部全选按钮
 */
- (void)didTappedSelectButton{
    self.selectButton.selected = !self.selectButton.selected;
    if (!self.selectButton.selected) {
        for (JCGood *good in self.addGoodArray) {
            good.selected = NO;
        }
    }
    else{
        for (JCGood *good in self.addGoodArray) {
            good.selected = YES;
        }
    }
    [self.tableView reloadData];
    [self reCalculateGoodPrice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[JCShoppingCartCell class] forCellReuseIdentifier:@"JCShoppingCartCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [self reCalculateGoodPrice];
}

- (void)reCalculateGoodPrice{

    for (JCGood *good in self.addGoodArray) {
        if (good.selected == YES) {
            self.price += (good.NewPrice * good.count);
        }
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总共价格：%.2f",self.price]];
    [attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, attrStr.length - 5)];
    self.totalPriceLabel.attributedText = attrStr;
    
    self.price = 0;
}

- (void)viewWillAppear:(BOOL)animated{

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(@0);
        make.height.equalTo(@49);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.centerY.equalTo(_bottomView.mas_centerY);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_bottomView);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.top.equalTo(@9);
        make.width.equalTo(@88);
        make.height.equalTo(@30);
    }];
}

- (void)dismiss{
    
    if ([self.delegate respondsToSelector:@selector(shoppingCartController:)]) {
        [self.delegate shoppingCartController:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addGoodArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JCShoppingCartCell *cell = [JCShoppingCartCell cellWithTableView:tableView indexPath:indexPath];
    cell.delegate = self;
    cell.good = self.addGoodArray[indexPath.row];
    return cell;
    
}

#pragma mark - cell Delegate
- (void)shoppingCartCell:(JCShoppingCartCell *)cell{
    [self reCalculateGoodPrice];
}
- (void)didTappedCalculateButton:(Btn)btnType cell:(JCShoppingCartCell *)cell{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    JCGood *good = self.addGoodArray[indexPath.row];
    
    if (btnType == BtnAdd) {
        good.count++;
    }
    else{
        if (good.count ==0)return;
        good.count--;
    }
    [self reCalculateGoodPrice];
    [self.tableView reloadData];
    // 保存到数据库
    [self saveGoods];
}

- (void)saveGoods{
    // 打开数据库
    // 创建表
    JCSQLiteManager *manager = [JCSQLiteManager sharedSQLiteManager];
    [manager saveGoodsWithArr:self.addGoodArray];
}

#pragma mark - lazy

- (UIButton *)buyButton{
    
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bottomView addSubview:_buyButton];
        [_buyButton setTitle:@"付款" forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:[UIImage imageNamed:@"button_add_cart"] forState:UIControlStateNormal];
        _buyButton.layer.cornerRadius = 15;
        _buyButton.layer.masksToBounds = YES;
    }
    return _buyButton;
}

- (UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        [self.bottomView addSubview:_totalPriceLabel];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总共价格：%.2f",self.price]];
        [attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, attrStr.length - 5)];
        _totalPriceLabel.attributedText = attrStr;
        [_totalPriceLabel sizeToFit];
    }
    return _totalPriceLabel;
}

- (UIButton *)selectButton{
    
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bottomView addSubview:_selectButton];
        [_selectButton setImage:[UIImage imageNamed:@"check_n"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"check_p"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(didTappedSelectButton) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setTitle:@"全选/取消" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _selectButton.selected = YES;
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:12.];
        [_selectButton sizeToFit];
        
    }
    return _selectButton;
}

- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)addGoodArray{
    
    if (!_addGoodArray) {
        _addGoodArray = [NSMutableArray array];
    }
    return _addGoodArray;
}

@end
