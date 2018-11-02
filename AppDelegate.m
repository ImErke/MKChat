//
//  AppDelegate.m
//  MKChat
//
//  Created by tusm on 2018/9/20.
//  Copyright © 2018年 tusm. All rights reserved.
//

#import "AppDelegate.h"
#import <Hyphenate/Hyphenate.h>
#import "MKChatViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    EMOptions *options = [EMOptions optionsWithAppkey:@"petcircle#app"];
    options.apnsCertName = @"zhubaoProCer";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    //登录
    [[EMClient sharedClient] loginWithUsername:@"62" password:@"5b90dd3378962" completion:^(NSString *aUsername, EMError *aError) {
        if (!aError)
        {
            NSLog(@"登录成功");
        }else
        {
            NSLog(@"登录失败=====> %@",aError.errorDescription);
        }
    }];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MKChatViewController *vc = [[MKChatViewController alloc] initWithConversationChatter:@"57" conversationType:EMConversationTypeChat];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
