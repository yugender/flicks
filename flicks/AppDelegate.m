//
//  AppDelegate.m
//  flicks
//
//  Created by  Yugender Boini on 1/23/17.
//  Copyright © 2017 sample. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    // Set up the first View Controller
    UINavigationController *nowPlayingNavigationController = [storyboard instantiateViewControllerWithIdentifier: @"moviesNavigationController"];
    MoviesViewController *nowPlayingViewController = (MoviesViewController*)[nowPlayingNavigationController topViewController];
    nowPlayingViewController.movieListType = MovieListTypeNowPlaying;
    nowPlayingNavigationController.tabBarItem.title = @"Now Playing";
    nowPlayingNavigationController.tabBarItem.image = [UIImage imageNamed:@"now_playing.png"];
    
    // Set up the second View Controller
    UINavigationController *topRatedNavigationController = [storyboard instantiateViewControllerWithIdentifier: @"moviesNavigationController"];
    MoviesViewController *topRatedViewController = (MoviesViewController*)[topRatedNavigationController topViewController];
    topRatedViewController.movieListType = MovieListTypeTopRated;
    topRatedNavigationController.tabBarItem.title = @"Top Rated";
    topRatedNavigationController.tabBarItem.image = [UIImage imageNamed:@"top_rated.png"];
    
    // Set up the Tab Bar Controller to have two tabs
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[nowPlayingNavigationController, topRatedNavigationController]];
    tabBarController.tabBar.tintColor = [UIColor blackColor];
    
    // Make the Tab Bar Controller the root view controller
    self.window.rootViewController = tabBarController;
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
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
