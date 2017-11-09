//
//  AppDelegate.h
//  Graphique
//
//  Created by Yevhen Triukhan on 26.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@class EquationEntryViewController;
@class GraphTableViewController;
@class RecentlyUsedEquationViewController;
@class PreferencesController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet NSSplitView *horizontalSplitView;
@property (nonatomic, weak) IBOutlet NSSplitView *verticalSplitView;

@property (nonatomic, strong) EquationEntryViewController *equationEntryVC;
@property (nonatomic, strong) GraphTableViewController *graphTableVC;
@property (nonatomic, strong) RecentlyUsedEquationViewController *recentlyUsedEquationVC;
@property (nonatomic, strong) PreferencesController *preferencesController;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel  *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (IBAction)showPreferencesPanel:(id)sender;
- (IBAction)exportAs:(id)sender;
@end
