//
//  AppDelegate.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/20/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import <RESideMenu.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate, UITabBarControllerDelegate, UITabBarDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

