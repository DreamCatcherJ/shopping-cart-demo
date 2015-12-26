//
//  JCGoodListController.m
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "JCGoodListController.h"
#import "JCGood.h"
#import "JCGoodCell.h"
#import "JCShoppingCartController.h"

#import "JCSQLiteManager.h"
#import <YYModel.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface JCGoodListController () <JCGoodCellDelegate,JCShoppingCartControllerDelegate>

@property (nonatomic,strong) NSMutableArray *goods;

@property (nonatomic,strong) UIButton *cartButton;

@property (nonatomic,strong) UILabel *addCountLabel;

@property (nonatomic,strong) CALayer *layer;
@property (nonatomic,strong) UIBezierPath *path;

@property (nonatomic,strong) NSMutableArray *addGoodArray;

@property (nonatomic,assign) NSUInteger allGoodsCount;

@end

@implementation JCGoodListController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[JCGoodCell class] forCellReuseIdentifier:@"good"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cartButton];
    
    [self.navigationController.navigationBar addSubview:self.addCountLabel];
    
    // 从数据库加载购物车数据
    
    JCSQLiteManager *manager = [JCSQLiteManager sharedSQLiteManager];
    [manager loadGoodsWithFinished:^(NSArray *array) {
        
        for (NSDictionary *dic in array) {
            
            JCGood *good = [JCGood yy_modelWithDictionary:dic];
            NSLog(@"%@",good);
            [self.addGoodArray addObject:good];
            
        }
        // addGoodArray 和 self.goods相同的对象覆盖
        self.allGoodsCount = 0;
        for (JCGood *good in self.addGoodArray) {
            if (good.count > 0) {
                self.allGoodsCount += good.count;
            }
        }
        
        // 算商品总数量
        [self reCalculateGoodCount];
        [self goodsCountAnimation];
        self.addCountLabel.hidden = NO;
        
    }];
    
}



/**
 *  点击购物车
 */
- (void)didTappedCarButton{
    
    JCShoppingCartController *shoppingCartVc = [[JCShoppingCartController alloc] init];
    
    shoppingCartVc.addGoodArray = self.addGoodArray;
    shoppingCartVc.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:shoppingCartVc] animated:YES completion:nil];
}

- (void)saveGoods{
    // 打开数据库
    // 创建表
    JCSQLiteManager *manager = [JCSQLiteManager sharedSQLiteManager];
    [manager saveGoodsWithArr:self.addGoodArray];
}

#pragma mark - JCShoppingCartController Delegate
- (void)shoppingCartController:(JCShoppingCartController *)shoppingCartController{
    [self reCalculateGoodCount];
    [self goodsCountAnimation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JCGoodCell *cell = [JCGoodCell cellWithTableView:tableView indexPath:indexPath];
    cell.good = self.goods[indexPath.row];
    cell.delegate = self;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.userInteractionEnabled = NO;
    
    JCGoodCell *goodcell = [tableView cellForRowAtIndexPath:indexPath];
    
    JCGood *good = self.goods[indexPath.row];
    good.selected = YES;
    good.count++;
    if (![self.addGoodArray containsObject:good]) {
        [self.addGoodArray addObject:good];
    }
    UIImageView *iconView = goodcell.iconView;
    
    // 重新计算iconView的frame，并开启动画
    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
    rect.origin.y -= self.tableView.contentOffset.y;
    CGRect headRect = iconView.frame;
    headRect.origin.y = rect.origin.y + headRect.origin.y - 64;
    [self startAnimation:headRect iconView:iconView];
    // 保存数据
    [self saveGoods];
}

#pragma mark - cell Delegate
- (void)goodCell:(JCGoodCell *)goodcell{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:goodcell];
    
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}
/**
 *  开始动画
 */
- (void)startAnimation:(CGRect)headRect iconView:(UIImageView *)iconView{
    
    self.layer = [CALayer layer];
    self.layer.contents = iconView.layer.contents;
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.bounds = headRect;
    self.layer.cornerRadius = CGRectGetHeight(self.layer.bounds) * 0.5;
    self.layer.masksToBounds = YES;
    self.layer.position = CGPointMake(iconView.center.x, CGRectGetMaxY(headRect) + 96);
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:self.layer];
    self.path = [[UIBezierPath alloc] init];
    [self.path moveToPoint:self.layer.position];
    // 抛物线
    [self.path addQuadCurveToPoint:CGPointMake(SCREEN_WIDTH - 25, 35) controlPoint:CGPointMake(SCREEN_WIDTH * 0.5, headRect.origin.y - 80)];
    
    [self groupAnimation];
    
}
- (void)groupAnimation{
    // 帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = self.path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    // 放大动画
    CABasicAnimation *bigAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bigAnimation.duration = 0.5;
    bigAnimation.fromValue = @1;
    bigAnimation.toValue = @2;
    bigAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // 缩小动画
    CABasicAnimation *smallAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    smallAnimation.beginTime = 0.5;
    smallAnimation.duration = 1.5;
    smallAnimation.fromValue = @2;
    smallAnimation.toValue = @0.3;
    smallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation, bigAnimation, smallAnimation];
    groupAnimation.duration = 2;
    groupAnimation.removedOnCompletion = false;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.delegate = self;
    [self.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
    
    
}

#pragma mark - animationStop Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if (anim == [self.layer animationForKey:@"groupAnimation"]) {
        self.tableView.userInteractionEnabled = YES;
        self.addCountLabel.hidden = NO;
        
        [self.layer removeAllAnimations];
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        
        // 算商品总数量
        [self reCalculateGoodCount];
        [self goodsCountAnimation];
        
        
        // 购物车抖动
        CABasicAnimation *cartAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        cartAnimation.duration = 0.25;
        cartAnimation.fromValue = @-5;
        cartAnimation.toValue = @5;
        cartAnimation.autoreverses = YES;
        [self.cartButton.layer addAnimation:cartAnimation forKey:nil];
        
        
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray *)goods{
    if (!_goods) {
        _goods = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            JCGood *good = [[JCGood alloc] init];
            good.goodId = i+1;
            good.title = [NSString stringWithFormat:@"%ld个商品",i+1];
            good.iconName = [NSString stringWithFormat:@"goodicon_%ld",i];
            good.desc = [NSString stringWithFormat:@"这是第%ld个商品",i+1];
            good.NewPrice = 1000.0 + i;
            good.oldPrice = 2000.0 + i;
            [_goods addObject:good];
        }
    }
    return _goods;
}
- (UIButton *)cartButton{
    if (!_cartButton) {
        _cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cartButton setImage:[UIImage imageNamed:@"button_cart"] forState:UIControlStateNormal];
        [_cartButton addTarget:self action:@selector(didTappedCarButton) forControlEvents:UIControlEventTouchUpInside];
        [_cartButton sizeToFit];
    }
    return _cartButton;
}

- (NSMutableArray *)addGoodArray{
    
    if (!_addGoodArray) {
        _addGoodArray = [NSMutableArray array];
    }
    return _addGoodArray;
}

- (UILabel *)addCountLabel{
    
    if (!_addCountLabel) {
        
        _addCountLabel = [[UILabel alloc] init];
        
        CGRect frame = self.cartButton.frame;
        CGFloat addCountLabelX = frame.origin.x;
        CGFloat addCountLabelY = frame.origin.y;
        
        _addCountLabel.frame = CGRectMake(addCountLabelX, addCountLabelY, 15, 15);
        _addCountLabel.backgroundColor = [UIColor whiteColor];
        _addCountLabel.textColor = [UIColor redColor];
        _addCountLabel.font = [UIFont systemFontOfSize:11.];
        _addCountLabel.textAlignment = NSTextAlignmentCenter;
        _addCountLabel.text = [NSString stringWithFormat:@"%ld",self.allGoodsCount];
        _addCountLabel.layer.cornerRadius = 7.5;
        _addCountLabel.layer.masksToBounds = YES;
        _addCountLabel.layer.borderWidth = 1;
        _addCountLabel.layer.borderColor = [UIColor redColor].CGColor;
        _addCountLabel.hidden = NO;
        
    }
    return _addCountLabel;
}

- (void)reCalculateGoodCount{
    self.allGoodsCount = 0;
    // 算商品总数量
    for (JCGood *good in self.addGoodArray) {
        if (good.count > 0) self.allGoodsCount += good.count;
        
    }
}
- (void)goodsCountAnimation{
    
    // 商品数量渐出
    CATransition *goodCountAnimation = [[CATransition alloc] init];
    goodCountAnimation.duration = 0.25;
    self.addCountLabel.text = [NSString stringWithFormat:@"%ld",self.allGoodsCount];
    NSLog(@"%ld",self.allGoodsCount);
    [self.addCountLabel.layer addAnimation:goodCountAnimation forKey:nil];
}




@end
