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
    return (item == nil) ? [self.rootItem numberOfChildren] : [item numberOfChildren];
}
//есть потомки или нет
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    return (item == nil) ? ([self.rootItem numberOfChildren] > 0) : ([item numberOfChildren] > 0);
    
}
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if (item == nil) {
        return [self.rootItem childAtIndex:index];
    }
    else {
        return [item childAtIndex:index];
    }

}


- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    return (item == nil) ? @"" : [item text];
}


@end
