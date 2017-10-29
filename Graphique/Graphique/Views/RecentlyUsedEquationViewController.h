//
//  RecentlyUsedEquationViewController.h
//  Graphique
//
//  Created by Yevhen Triukhan on 27.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GroupItem;

@interface RecentlyUsedEquationViewController : NSViewController <NSOutlineViewDataSource, NSSplitViewDelegate>

@property (nonatomic, strong) GroupItem *rootItem;

@end
