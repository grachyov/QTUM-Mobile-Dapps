//
//  NSUserDefaults+Settings.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSUserDefaults+Settings.h"

NSString *const kSettingIsMainnet = @"kSettingExtraMessages";
NSString *const kSettingIsRPCOn = @"kSettingLongMessage";
NSString *const kFingerpringAllowed = @"kFingerpringAllowed";
NSString *const kFingerpringEnabled = @"kFingerpringEnabled";
NSString *const kLanguageSaveKey = @"kLanguageSaveKey";
NSString *const kDeviceTokenKey = @"kDeviceTokenKey";
NSString *const kPrevDeviceTokenKey = @"kPrevDeviceTokenKey";
NSString *const kWalletAddressKey = @"kWalletAddressKey";
NSString *const kIsHaveWallet = @"kIsHaveWallet";
NSString *const kIsDarkScheme = @"kIsDarkScheme";
NSString *const kIsNotFirstTimeLaunch = @"kIsNotFirstTimeLaunch";
NSString *const kCurrentVersion = @"kCurrentVersion";
NSString *const kPublicAddresses = @"kPublicAddresses";
NSString *const kFailedPinCount = @"kFailedPinCount";
NSString *const kLastFailedDate = @"kLastFailedDate";
NSString *const kRemovingContractPassed = @"kRemovingContractPassed";



NSString *const kGroupIdentifire = @"group.qtum.hack";



@implementation NSUserDefaults (Settings)

+ (void)saveIsMainnetSetting:(BOOL) value {
	[[self groupDefaults] setBool:value forKey:kSettingIsMainnet];
}

+ (void)saveIsRPCOnSetting:(BOOL) value {
	[[self groupDefaults] setBool:value forKey:kSettingIsRPCOn];
}

+ (void)saveIsFingerpringAllowed:(BOOL) value {
	[[self groupDefaults] setBool:value forKey:kFingerpringAllowed];
}

+ (void)saveIsFingerpringEnabled:(BOOL) value {
	[[self groupDefaults] setBool:value forKey:kFingerpringEnabled];
}

+ (void)saveLanguage:(NSString *) lang {
	[[self groupDefaults] setObject:lang forKey:kLanguageSaveKey];
}

+ (NSString *)getLanguage {
	return [[self groupDefaults] objectForKey:kLanguageSaveKey];
}

+ (BOOL)isRPCOnSetting {
	return [[self groupDefaults] boolForKey:kSettingIsRPCOn];
}

+ (BOOL)isFingerprintAllowed {
	return [[self groupDefaults] boolForKey:kFingerpringAllowed];
}

+ (BOOL)isFingerprintEnabled {
	return [[self groupDefaults] boolForKey:kFingerpringEnabled];
}

+ (BOOL)isMainnetSetting {
	return [[self groupDefaults] boolForKey:kSettingIsMainnet];
}

+ (void)saveDeviceToken:(NSString *) lang {
	[[self groupDefaults] setObject:lang forKey:kDeviceTokenKey];
}

+ (NSString *)getDeviceToken {
	return [[self groupDefaults] objectForKey:kDeviceTokenKey];
}

+ (void)savePrevDeviceToken:(NSString *) lang {
	[[self groupDefaults] setObject:lang forKey:kPrevDeviceTokenKey];
}

+ (NSString *)getPrevDeviceToken {
	return [[self groupDefaults] objectForKey:kPrevDeviceTokenKey];
}

+ (void)saveWalletAddressKey:(NSString *) key {
	[[self groupDefaults] setObject:key forKey:kWalletAddressKey];
}

+ (NSString *)getWalletAddressKey {
	return [[self groupDefaults] objectForKey:kWalletAddressKey];
}

+ (void)saveIsHaveWalletKey:(NSString *) key {
	[[self groupDefaults] setObject:key forKey:kIsHaveWallet];

}

+ (NSString *)isHaveWalletKey {
	return [[self groupDefaults] objectForKey:kIsHaveWallet];
}

+ (NSUserDefaults *)groupDefaults {
	return [[NSUserDefaults alloc] initWithSuiteName:kGroupIdentifire];
}

+ (void)saveIsDarkSchemeSetting:(BOOL) value {
	[[self groupDefaults] setBool:value forKey:kIsDarkScheme];
}

+ (BOOL)isDarkSchemeSetting {
	return [[self groupDefaults] boolForKey:kIsDarkScheme];
}

+ (void)saveIsNotFirstTimeLaunch:(BOOL) value {

	[[self groupDefaults] setBool:value forKey:kIsNotFirstTimeLaunch];
}

+ (BOOL)isNotFirstTimeLaunch {

	return [[self groupDefaults] boolForKey:kIsNotFirstTimeLaunch];
}

+ (void)saveCurrentVersion:(NSString *) value {

	[[self groupDefaults] setObject:value forKey:kCurrentVersion];
}

+ (void)saveFailedPinCount:(NSInteger) count {

	[[self groupDefaults] setObject:@(count) forKey:kFailedPinCount];
}

+ (NSInteger)getCountOfPinFailed {

	NSNumber *failedCount = [[self groupDefaults] objectForKey:kFailedPinCount];

	if (failedCount) {
		return failedCount.integerValue;
	} else {
		return 0;
	}
}

+ (void)saveLastFailedPinDate:(NSDate *) date {
	[[self groupDefaults] setObject:date forKey:kLastFailedDate];
}

+ (NSDate *)getLastFailedPinDate {
	return [[self groupDefaults] objectForKey:kLastFailedDate];
}

+ (NSString *)currentVersion {
	return [[self groupDefaults] objectForKey:kCurrentVersion];
}

+ (void)saveIsRemovingContractTrainingPassed:(BOOL) value {

	[[self groupDefaults] setBool:value forKey:kRemovingContractPassed];
}

+ (BOOL)isRemovingContractTrainingPassed {

	return [[self groupDefaults] boolForKey:kRemovingContractPassed];
}

// Public addresses

+ (void)savePublicAddresses:(NSArray *) addresses {
    
	[[self groupDefaults] setObject:addresses forKey:kPublicAddresses];
	[[self groupDefaults] synchronize];
}

+ (NSArray *)getPublicAddresses {
	return [[self groupDefaults] objectForKey:kPublicAddresses];
}

@end
