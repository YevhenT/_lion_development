//
//  GraphTableViewController.m
//  Graphique
//
//  Created by Yevhen Triukhan on 27.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "GraphTableViewController.h"

#import "GraphView.h"

#define PREFERRED_RECENT_AND_EQUATIONS_MIN_HEIGHT 150.0
#define GRAPH_MIN_HEIGHT 100.0

static NSString *kInitialViewIsGraph = @"InitialViewIsGraph";

@interface GraphTableViewController () 

@end

@implementation GraphTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _values = [[NSMutableArray alloc]init];
        _interval = 1.0;
    }
    return self;
}



- (void) draw: (Equation *) equation{
    //очистить кэш
    [self.values removeAllObjects];
    
    for (float x = -50; x <= 50; x+=self.interval) {
        float y = [equation evaluateForX:x];
//        NSLog(@"Adding Point (%0.2f, %0.2f)", x, y);
        [self.values addObject:[NSValue valueWithPoint:CGPointMake(x, y)]];
    }
    [self.graphTableView reloadData];
    [self.graphView setNeedsDisplay:YES];
    
}

- (void)awakeFromNib{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger selectedTab = [userDefaults boolForKey:kInitialViewIsGraph]? 0 : 1;
    [self.tabView selectTabViewItemAtIndex:selectedTab];
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
    return PREFERRED_RECENT_AND_EQUATIONS_MIN_HEIGHT;
}
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex{
    CGFloat max = splitView.frame.size.height - GRAPH_MIN_HEIGHT;
    return max;
}


#pragma mark -
#pragma mark ***** NSTableViewDataSource *****

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.values.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    CGPoint point = [[self.values objectAtIndex:row] pointValue];
    float value = [[tableColumn identifier] isEqualToString:@"X"] ? point.x : point.y;
    return [NSString stringWithFormat:@"%0.2f", value];
    
}


@end
