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


@end
