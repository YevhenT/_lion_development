//
//  AppDelegate.m
//  Graphique
//
//  Created by Yevhen Triukhan on 26.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "AppDelegate.h"

#import "EquationEntryViewController.h"
#import "GraphTableViewController.h"
#import "RecentlyUsedEquationViewController.h"

@interface AppDelegate() <NSSplitViewDelegate>




@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.equationEntryVC = [[EquationEntryViewController alloc]
                            initWithNibName: @"EquationEntryViewController"
                            bundle:nil];
    self.graphTableVC = [[GraphTableViewController alloc]
                         initWithNibName: @"GraphTableViewController"
                         bundle: nil];
    self.recentlyUsedEquationVC = [[RecentlyUsedEquationViewController alloc]
                                   initWithNibName: @"RecentlyUsedEquationViewController"
                                   bundle: nil];
    
    self.verticalSplitView.delegate = self.recentlyUsedEquationVC;
    
    [self.verticalSplitView replaceSubview: [self.verticalSplitView subviews][1]
                                        with:self.equationEntryVC.view];
    [self.verticalSplitView replaceSubview: [self.verticalSplitView subviews][0]
                                      with:self.recentlyUsedEquationVC.view];
    [self.horizontalSplitView replaceSubview:[self.horizontalSplitView subviews][1]
                                        with:self.graphTableVC.view];
    
    

}



@end
