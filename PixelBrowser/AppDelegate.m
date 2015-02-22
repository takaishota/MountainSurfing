//
//  AppDelegate.m
//  PixelBrowser
//
//  Created by  on 12/02/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window, vc;


//For scheme
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    /*
    NSString* msg = [NSString stringWithFormat:@"[URL]%@\n[schame]%@\n[Query]%@", 
                     [url absoluteString], [url scheme], [url query]];    
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"debug"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];    
     [alert show]; 
     */
    //vc.navBar.text = [NSString stringWithFormat:@"http://www.google.com/search?q=aa&ie=utf-8&oe=utf-8"];
    NSString* newURL = [[url absoluteString] stringByReplacingOccurrencesOfString:@"mthttp://" withString:@"http://"];
    NSString* newURL2 = [newURL stringByReplacingOccurrencesOfString:@"mthttps://" withString:@"https://"];
    DLog(@"appdelegate handleOpen");
    vc = (ViewController*)(_window.rootViewController);
    [vc startLoading:newURL2];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //NSLog(@"%@",@"didFinishLaunchingWithOptions");
    // Override point for customization after application launch.
    DLog(@"appdelegate finish");
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    //vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainViewController"];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
