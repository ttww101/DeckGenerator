//
//  AppDelegate.m
//  ClashRoyaleRandom
//
//  Created by master on 2016/6/27.
//  Copyright © 2016年 7ML2DVJ9Q4. All rights reserved.
//


#import "AppDelegate.h"
#import "JPUSHService.h" // 極光
#import <UserNotifications/UserNotifications.h>
#import "JANALYTICSService.h"
#import "ADWKWebViewController.h"
//#import "NSString+URL/NSString+URL.h"
//#import "ViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // setup nav bar
//    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    // Add this code to change StateNormal text Color,
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorWithRed:0x15/255.0 green:0x77/255.0 blue:0x68/255.0 alpha:1.0]}
                                           forState:UIControlStateNormal];
    
    // then if StateSelected should be different, you should add this code
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateSelected];
    
    
    
    
    [AVOSCloud setApplicationId:@"eQaKMl3A0UcFFFSsex7IVQ7C-gzGzoHsz" clientKey:@"ldH0b6HQB9GxtsPpAw50aKgb"];
    [AVOSCloud setAllLogsEnabled:NO];
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"Users"];
    query.w = self.window;
//    ADWKWebViewController *logView = [ADWKWebViewController initWithURL:@"https://youtube.com"];
//    self.window.rootViewController = logView;
//    [self.window makeKeyAndVisible];
    
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
}];
    // jpush
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    

    [JPUSHService setupWithOption:launchOptions appKey:@"3ccb4e1169254e5f4d971ee8" channel:@"Publish channel" apsForProduction:YES advertisingIdentifier:NULL];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:@"isFirstLaunch"]) {
        [userDefault setBool:NO forKey:@"buyPro"];
        [userDefault setBool:NO forKey:@"useRule"];
        [userDefault setBool:YES forKey:@"isFirstLaunch"];
        [userDefault setFloat:7.0 forKey:@"arena"];
        [userDefault setFloat:3.0 forKey:@"minCost"];
        [userDefault setFloat:5.0 forKey:@"maxCost"];
        [userDefault setInteger:0 forKey:@"generateCount"];
    }
    
    return YES;
}

#pragma mark - Push Service

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


// delegate 點擊 notifcation 進入
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) { // 經 APN 進行推送
        //从通知界面直接进入应用
    }else{ // 其他推送模式
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
