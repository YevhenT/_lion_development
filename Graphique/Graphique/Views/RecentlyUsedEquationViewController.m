//
//  RecentlyUsedEquationViewController.m
//  Graphique
//
//  Created by Yevhen Triukhan on 27.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "RecentlyUsedEquationViewController.h"

#import "EquationItem.h"
#import "GroupItem.h"

#define EQUATION_ENTRY_MIN_WIDTH 175.0
#define PREFERRED_RECENT_EQUATIONS_MIN_WIDTH 150.0
//#define EQUATION_ENTRY_MAX_WIDTH 240.0

@interface RecentlyUsedEquationViewController ()

@end

@implementation RecentlyUsedEquationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rootItem = [[GroupItem alloc] init];
        
        for (int i = 0; i < 2; i++) {
            GroupItem *temp = [[GroupItem alloc] init];
            temp.name = [NSString stringWithFormat:@"GroupItem %i", i + 1];
            
            for (int j = 0; j < 5; j++) {
                EquationItem *item = [[EquationItem alloc] init];
            
                [temp addChild:item];
            }
            [self.rootItem addChild:temp];
        }
    
    }
    return self;
}

#pragma mark - 
#pragma mark <NSOutlineDataSource>

//количество потомков узла
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    
 
    
    NSInteger numberOfChildren = 0;
    if (!item) {//"корневое" или "узловое" обращение
        numberOfChildren = [self.rootItem numberOfChildren];
    }
    else {
        numberOfChildren = [item numberOfChildren];
    }
    return numberOfChildren;
}
//есть потомки или нет
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
 

    BOOL isItemExpandable = false;
    
    if (!item) {//"корневое" или "узловое" обращение
        isItemExpandable = ([self.rootItem numberOfChildren] > 0);
    }
    else {
        isItemExpandable = ([item numberOfChildren] > 0);
    }
    
    return isItemExpandable;
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
 

    if (item == nil) {
        return [self.rootItem childAtIndex:index];//здесь возвращаются GroupItem
    }
    else {
        return [item childAtIndex:index];//здесь возвращаются EquationItem
    }

}


- (id)outlineView:(NSOutlineView *)outlineView
objectValueForTableColumn:(NSTableColumn *)tableColumn
           byItem:(id)item{
    id objectValue = nil;
 
    if (!item) {//"корневое" или "узловое" обращение
        objectValue = @"";
    }
    else {
        objectValue = [item text];
    }
    
    return objectValue;
}

#pragma mark -
#pragma mark <NSSplitViewDelegate>
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex{
    CGFloat max = splitView.frame.size.width - EQUATION_ENTRY_MIN_WIDTH;
    return max;
}

//- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex{
//    CGFloat max = splitView.frame.origin.x + EQUATION_ENTRY_MAX_WIDTH;
//    return max;
//}

- (BOOL) splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view{
    
    CGFloat windowSize = splitView.bounds.size.width;
    NSView *recentlyUsedView = [splitView.subviews objectAtIndex:0];
    NSView *equationEntryView = [splitView.subviews objectAtIndex:1];

    if ( windowSize <= (EQUATION_ENTRY_MIN_WIDTH + PREFERRED_RECENT_EQUATIONS_MIN_WIDTH)) {
        if (view == equationEntryView) {
            [view setFrameSize: CGSizeMake(EQUATION_ENTRY_MIN_WIDTH, view.frame.size.height)];
            return NO;
        }
        if (view == recentlyUsedView) {
            return YES;
        }
    }
    else {
        if (view == equationEntryView) {
            return YES;
        }
        if (view == recentlyUsedView) {
            [view setFrameSize: CGSizeMake(PREFERRED_RECENT_EQUATIONS_MIN_WIDTH, view.frame.size.height)];
            return NO;
        }
    }

    return NO;
}
@end
