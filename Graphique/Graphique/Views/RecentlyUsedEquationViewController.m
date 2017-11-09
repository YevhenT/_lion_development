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
#import "Equation.h"
#import "AppDelegate.h"
#import "EquationEntryViewController.h"
#import "GraphTableViewController.h"

#define EQUATION_ENTRY_MIN_WIDTH 175.0
#define PREFERRED_RECENT_EQUATIONS_MIN_WIDTH 150.0

static NSString *kGroup = @"Group";
static NSString *kEquation = @"Equation";
static NSString *kName = @"name";


@interface RecentlyUsedEquationViewController ()

@end

@implementation RecentlyUsedEquationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rootItem = [[GroupItem alloc] init];
    }
    return self;
}

#pragma mark - 
#pragma mark <NSOutlineDataSource>

//количество потомков узла
- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id)item
{
    [self loadChildrenForItem:(item == nil ? self.rootItem : item)];
    return (item == nil) ? [self.rootItem numberOfChildren] : [item numberOfChildren];
}
//- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
//    
// 
//    
//    NSInteger numberOfChildren = 0;
//    if (!item) {//"корневое" или "узловое" обращение
//        numberOfChildren = [self.rootItem numberOfChildren];
//    }
//    else {
//        numberOfChildren = [item numberOfChildren];
//    }
//    return numberOfChildren;
//}
//есть потомки или нет
- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item
{
    return [self outlineView:outlineView numberOfChildrenOfItem:item] > 0;
}
//- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
// 
//
//    BOOL isItemExpandable = false;
//    
//    if (!item) {//"корневое" или "узловое" обращение
//        isItemExpandable = ([self.rootItem numberOfChildren] > 0);
//    }
//    else {
//        isItemExpandable = ([item numberOfChildren] > 0);
//    }
//    
//    return isItemExpandable;
//}
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

#pragma mark
#pragma mark <NSOutlineDelegate>


- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSOutlineView *outlineView_ = [notification object];
    NSInteger row = [outlineView_ selectedRow];
    id item = [outlineView_ itemAtRow:row];
    // If an equation was selected, deal with it
    if([item isKindOfClass:EquationItem.class]) {
        EquationItem *equationItem = item;
        Equation *equation = [[Equation alloc] initWithString:equationItem.text];
        AppDelegate *delegate = [NSApplication sharedApplication].delegate;
        [delegate.equationEntryVC.textField setStringValue: equation.text];
        [delegate.graphTableVC draw:equation];
        [delegate.equationEntryVC controlTextDidChange: nil];
    }
}
- (BOOL)    outlineView:(NSOutlineView *)outlineView
  shouldEditTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    return NO;
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

#pragma mark
#pragma mark CoreData

- (void)remember:(Equation *)equation{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *groupName = [dateFormat stringFromDate:today];
    
    //создать запрос на выборку
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //определить тип искомой сущности
    NSEntityDescription *entity = [NSEntityDescription entityForName:kGroup inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //добавить предикат для уточнения поиска
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", groupName];
    [fetchRequest setPredicate:predicate];
    
    NSArray *groups = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                               error:nil];
    NSManagedObject *groupMO = nil;
    
    if (groups.count > 0) {
        //группа сегодня уже была создана, пользуемся еЮ
        groupMO = groups[0];
    }
    else {
        //создать новую группу
        groupMO = [NSEntityDescription insertNewObjectForEntityForName:kGroup
                                                inManagedObjectContext:self.managedObjectContext];
        //задать имя группы
        [groupMO setValue:groupName forKeyPath:kName];
    }
    
    //создаем объект формулы
    NSManagedObject *equationMO =
    [NSEntityDescription insertNewObjectForEntityForName:kEquation
                                  inManagedObjectContext:self.managedObjectContext];
    //установить атрибуты метки времения и представления
    [equationMO setValue:equation.text forKey:@"representation"];
    [equationMO setValue:[NSDate date] forKey:@"timeStamp"];
    [equationMO setValue:groupMO forKey:@"group"];
    
    //фиксация изменений в постоянном хранилище
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort() ;
    }
    
    [self.rootItem reset];
    [self.outlineView reloadData];
    
}

- (void)loadChildrenForItem:(id)item{
    // If the item isn't a group, there's nothing to load
    if(![item isKindOfClass:GroupItem.class])
        return;
    GroupItem *group = (GroupItem*)item;
    // No point reloading if it's already been loaded
    if(group.loaded) return;
    // Wipe out the nodes children since we're about to reload them
    [group reset];
    // If the group is the rootItem, then we need to load all the available groups. If not, then we only load the
    // equations for that group based on its name
    if(group == self.rootItem) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Group"
                                                  inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSArray *groups = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        for(NSManagedObject *obj in groups) {
            GroupItem *groupItem = [[GroupItem alloc] init];
            groupItem.name = [obj valueForKey:@"name"];
            [group addChild:groupItem]; }
    }
    else
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Equation"
                                                  inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Add a predicate to further specify what we are looking for
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group.name=%@", group.name];
        [fetchRequest setPredicate:predicate];
        NSArray *equations = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        for(NSManagedObject *obj in equations) {
            EquationItem *equationItem = [[EquationItem alloc] init];
            equationItem.text = [obj valueForKey:@"representation"];
            [group addChild:equationItem];
        }
    }
    // Mark the group as properly loaded
    group.loaded = YES;
}



@end
