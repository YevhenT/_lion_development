//
//  GraphView.h
//  Graphique
//
//  Created by Yevhen Triukhan on 31.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GraphTableViewController;

@interface GraphView : NSView

@property (nonatomic, strong) IBOutlet GraphTableViewController *controller;

@end
