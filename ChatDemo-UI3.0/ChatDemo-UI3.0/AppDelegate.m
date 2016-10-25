//
//  AppDelegate.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/9/19.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>
#import "EMMainViewController.h"
#import "EMLoginViewController.h"
#import "EMLaunchViewController.h"
#import "EMChatDemoHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [[UITabBar appearance] setBarTintColor:RGBACOLOR(250, 251, 252, 1.0)];
        [[UITabBar appearance] setTintColor:RGBACOLOR(0, 186, 110, 1)];
        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(255, 255, 255, 1)];
        [[UINavigationBar appearance] setTintColor:RGBACOLOR(12, 18, 24, 1)];
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    // init HyphenateSDK
    EMOptions *options = [EMOptions optionsWithAppkey:@"easemob-demo#chatdemoui"];
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"chatdemoui_dev";
#else
    apnsCertName = @"chatdemoui";
#endif

//aws
#if DEBUG
    apnsCertName = @"DevelopmentCertificate";
#else
    apnsCertName = @"ProductionCertificate";
#endif
    
    [options setApnsCertName:apnsCertName];
    [options setEnableConsoleLog:YES];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [EaseCallManager sharedManager];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    EMLaunchViewController *launch = [[EMLaunchViewController alloc] init];
    self.window.rootViewController = launch;
    [self.window makeKeyAndVisible];
    
    [self _registerRemoteNotification];
    
    return YES;
}

- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {

        EMMainViewController *main = [[EMMainViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:main];
        self.window.rootViewController = navigationController;
        [EMChatDemoHelper shareHelper].mainVC = main;
        
    } else {
        EMLoginViewController *login = [[EMLoginViewController alloc] init];
        self.window.rootViewController = login;
        [EMChatDemoHelper shareHelper].mainVC = nil;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - App Delegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[EMClient sharedClient] bindDeviceToken:deviceToken];
//    });
    [[EMClient sharedClient] registerForRemoteNotificationsWithDeviceToken:deviceToken completion:^(EMError *aError) {
        
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}


@end
