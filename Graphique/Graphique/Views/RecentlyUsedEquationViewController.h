//
//  RecentlyUsedEquationViewController.h
//  Graphique
//
//  Created by Yevhen Triukhan on 27.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

@class GroupItem;
@class Equation;

@interface RecentlyUsedEquationViewController : NSViewController <NSOutlineViewDataSource,
                                                                    NSSplitViewDelegate,
                                                                    NSOutlineViewDelegate>

@property (nonatomic, strong) GroupItem *rootItem;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet NSOutlineView *outlineView;

- (void)remember:(Equation*)equation;
- (void)loadChildrenForItem:(id)item;
@end
