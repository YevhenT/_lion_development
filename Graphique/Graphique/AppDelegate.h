//
//  AppDelegate.h
//  Graphique
//
//  Created by Yevhen Triukhan on 26.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EquationEntryViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, weak) IBOutlet NSSplitView *horizontalSplitView;
@property (nonatomic, weak) IBOutlet NSSplitView *verticalSplitView;
@property (nonatomic, strong) IBOutlet EquationEntryViewController *equationEntryVC;

@end
