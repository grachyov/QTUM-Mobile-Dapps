//
//  TabBarControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TabBarControllerDark.h"

@interface TabBarControllerDark ()

@end

@implementation TabBarControllerDark

- (void)viewDidLoad {

	[super viewDidLoad];
	[self configTabBar];
}

#pragma mark - Configuration

- (void)configTabBar {

	self.tabBar.translucent = NO;
	self.tabBar.tintColor = customBlueColor ();
	self.tabBar.barTintColor = customBlackColor ();
}

- (void)configTabsWithNews:(UIViewController *) newsController
                      send:(UIViewController *) sendController
                    wallet:(UIViewController *) walletController
                   profile:(UIViewController *) profileController
                   browser:(UIViewController *) browserController {

	[self setViewControllers:@[walletController, profileController, newsController, sendController, browserController] animated:YES];

	profileController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Profile", "Tabs") image:[UIImage imageNamed:@"profile"] tag:0];
	walletController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Wallet", "Tabs") image:[UIImage imageNamed:@"history"] tag:1];
	newsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"News", "Tabs") image:[UIImage imageNamed:@"news"] tag:2];
	sendController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Send", "Tabs") image:[UIImage imageNamed:@"send"] tag:3];
    browserController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Browser" image:[UIImage imageNamed:@"ic-browser"] tag:4];
    
	[profileController.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
	[walletController.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
	[newsController.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
	[sendController.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
    [browserController.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
}

#pragma mark TabbarOutput

- (void)setControllerForNews:(UIViewController *) newsController
					 forSend:(UIViewController *) sendController
				   forWallet:(UIViewController *) walletController
                  forProfile:(UIViewController *) profileController
                  forBrowser:(UIViewController *) browserController {

	[self configTabsWithNews:newsController send:sendController wallet:walletController profile:profileController browser:browserController];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleDefault;
}


@end
