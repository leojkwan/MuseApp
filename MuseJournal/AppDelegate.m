//
//  AppDelegate.m
//  MuseJournal
//
//  Created by Leo Kwan on 9/28/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//


#import "AppDelegate.h"
#import "RKSwipeBetweenViewControllers.h"
#import "MUSAllEntriesViewController.h"
#import "MUSHomeViewController.h"
//#import "MUSColorSheet.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationNone];
    
    
    // WHEN KEYBOARD AVOID HAPPENS.. MAKE SURE BLACK DOES NOT SHOW
    self.window.backgroundColor = [UIColor whiteColor];
    
    // system font color
    NSDictionary *systemFontColor = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Medium" size:18.0], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:systemFontColor forState:UIControlStateNormal];
    
    // username First Name
    NSArray *components = [[[UIDevice currentDevice] name] componentsSeparatedByString: @"'"];
    NSString *userFirstName = (NSString*) [components objectAtIndex:0];
    
    

    // FIRST TIME USER SETTINGS
    
    // USER NAME
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:userFirstName forKey:@"userFirstName"];

    }

    // APP WALKTHROUGH
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"firstTimeUser"] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTimeUser"];
    }
    
    // ENTRY WALKTHROUGH
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"firstTimeEntry"] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTimeEntry"];
    }
    
    // MUSIC AUTOPLAY
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"autoplay"] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoplay"];
    }
    
    // AUTOPAUSE MUSIC ON EXIT
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"autopause"] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autopause"];
    }
    
    // BACKGROUND IMAGE
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"background"] == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"background"];
    }
    
    
    NSDictionary *wallpaperDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         [NSNumber numberWithBool:YES], @"Vintage Camera",
                                         [NSNumber numberWithBool:YES], @"Seagull",
                                         [NSNumber numberWithBool:YES], @"Venice",
                                         [NSNumber numberWithBool:YES], @"Vinyl",
                                         [NSNumber numberWithBool:YES], @"Balloons",
                                         [NSNumber numberWithBool:YES], @"Electric",
                                         
                                         [NSNumber numberWithBool:NO], @"Shooting Star",
                                         [NSNumber numberWithBool:NO], @"Coffee Bean",
                                         [NSNumber numberWithBool:NO], @"Calm",
                                         [NSNumber numberWithBool:NO], @"Rose",
                                         [NSNumber numberWithBool:NO], @"Hammer",
                                         [NSNumber numberWithBool:NO], @"Spark",
                                         [NSNumber numberWithBool:NO], @"Tiger",
                                         [NSNumber numberWithBool:NO], @"Jellyfish",
                                         
                                         nil];
    
    
    // IAP
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"purchasedWallpapers"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:wallpaperDictionary forKey:@"purchasedWallpapers"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}




-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.leojkwan.MuseApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MuseApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MuseApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

