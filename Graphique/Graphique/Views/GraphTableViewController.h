//
//  GraphTableViewController.h
//  Graphique
//
//  Created by Yevhen Triukhan on 27.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Equation.h"

@class GraphView;

@interface GraphTableViewController : NSViewController <NSSplitViewDelegate,
                                                        NSTableViewDataSource>

@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, weak) IBOutlet NSTableView *graphTableView;
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, weak) IBOutlet NSTabView *tabView;


- (void) draw: (Equation *) equation;

@end
