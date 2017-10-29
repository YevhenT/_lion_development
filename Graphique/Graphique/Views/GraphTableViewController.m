//
//  GraphTableViewController.m
//  Graphique
//
//  Created by Yevhen Triukhan on 27.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "GraphTableViewController.h"

#define PREFERRED_RECENT_AND_EQUATIONS_MIN_WIDTH 150.0
#define GRAPH_MIN_HEIGHT 100.0


@interface GraphTableViewController () 

@end

@implementation GraphTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

#pragma mark -
#pragma mark <NSSplitViewDelegate>
- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview{
    return (subview == self.view);
}
- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex {
    return (subview == self.view);
}


- (CGFloat)splitView:(NSSplitView *)splitView
constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex{
    return PREFERRED_RECENT_AND_EQUATIONS_MIN_WIDTH;
}
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex{
    CGFloat max = splitView.frame.size.height - GRAPH_MIN_HEIGHT;
    return max;
}

@end
