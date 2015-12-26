//
//  AppDelegate.m
//  shoppingcart-demo
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "JCGoodListController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[JCGoodListController alloc]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}
@end
