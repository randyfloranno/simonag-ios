//
//  AppDelegate.h
//  simonag
//
//  Created by Randy Floranno Hasdi on 7/20/17.
//  Copyright © 2017 randyfloranno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

