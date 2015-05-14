//
//  AppDelegate.m
//  helloworld-objective-c
//
//  Created by CHENHSIN-PANG on 2015/3/23.
//  Copyright (c) 2015年 CinnamonRoll. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // Create a key window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    // Create a view controller
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    
    

    return YES;
}





@end
