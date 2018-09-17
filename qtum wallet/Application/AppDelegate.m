//
//  AppDelegate.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "AppDelegate.h"
#import "Appearance.h"

@interface AppDelegate ()

@property (assign, nonatomic) BOOL aplicationCoordinatorStarted;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {

	SLocator.iOSSessionManager;
	[ServiceLocator sharedInstance];
	[SLocator.appSettings setup];
	[Appearance setUp];
    
	[[ApplicationCoordinator sharedInstance] startSplashScreen];
	dispatch_after (dispatch_time (DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue (), ^{

		if (!self.aplicationCoordinatorStarted) {
			[[ApplicationCoordinator sharedInstance] start];
			self.aplicationCoordinatorStarted = YES;
		}
	});

	return YES;
}

- (BOOL)application:(UIApplication *) app openURL:(NSURL *) url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *) options {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    NSString *address = [NSString valueForKey:@"address" fromQueryItems:queryItems];
    NSString *amount = [NSString valueForKey:@"amount" fromQueryItems:queryItems];
    NSString *caller = [NSString valueForKey:@"caller" fromQueryItems:queryItems];
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Confirm transaction"
                                 message:[amount stringByAppendingString:@" QTUM"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self sendTransactionForDapp:amount address:address];
                                    NSURL *url = [[NSURL alloc] initWithString:[caller stringByAppendingString:@"://?success=true"]];
                                    [app openURL:url options:[[NSDictionary alloc] init] completionHandler:^(BOOL success) {}];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {}];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [_window.rootViewController presentViewController:alert animated:YES completion:nil];    
    
    
	return YES;
}

- (void)sendTransactionForDapp:(NSString *)amount address: (NSString *) address {
    NSArray *array = @[@{@"amount": [[QTUMBigNumber alloc] initWithString:amount], @"address": address}];
    NSArray<BTCKey *> *addresses = [SLocator.walletManager.wallet allKeys];
    [SLocator.transactionManager sendTransactionWalletKeys:addresses toAddressAndAmount:array fee:[[QTUMBigNumber alloc] initWithString:@"1"] andHandler:^(TransactionManagerErrorType errorType, id response, QTUMBigNumber *estimatedFee) {}];
}

- (void)applicationWillEnterForeground:(UIApplication *) application {

	[SLocator.popupService dismissLoader];
}

#pragma mark - Notifications

- (void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken {
	[SLocator.notificationManager application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *) application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
	[SLocator.notificationManager application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo {
	[SLocator.notificationManager application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result)) completionHandler {
	[SLocator.notificationManager application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

@end
