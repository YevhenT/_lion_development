//
//  AppDelegate.m
//  Graphique
//
//  Created by Yevhen Triukhan on 26.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "AppDelegate.h"

#import "EquationEntryViewController.h"
#import "GraphTableViewController.h"
#import "RecentlyUsedEquationViewController.h"
#import "GraphView.h"
#import "PreferencesController.h"

static NSString *const kFileExtension = @"graphique";
static NSString *const kEquation = @"equation";
@interface AppDelegate() <NSSplitViewDelegate>




@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.equationEntryVC = [[EquationEntryViewController alloc]
                            initWithNibName: @"EquationEntryViewController"
                            bundle:nil];
    self.graphTableVC = [[GraphTableViewController alloc]
                         initWithNibName: @"GraphTableViewController"
                         bundle: nil];
    self.recentlyUsedEquationVC = [[RecentlyUsedEquationViewController alloc]
                                   initWithNibName: @"RecentlyUsedEquationViewController"
                                   bundle: nil];
    self.recentlyUsedEquationVC.managedObjectContext = self.managedObjectContext;
    
    self.verticalSplitView.delegate = self.recentlyUsedEquationVC;
    self.horizontalSplitView.delegate = self.graphTableVC;
    
    [self.verticalSplitView replaceSubview: [self.verticalSplitView subviews][1]
                                        with:self.equationEntryVC.view];
    [self.verticalSplitView replaceSubview: [self.verticalSplitView subviews][0]
                                      with:self.recentlyUsedEquationVC.view];
    [self.horizontalSplitView replaceSubview:[self.horizontalSplitView subviews][1]
                                        with:self.graphTableVC.view];
    
    [[NSColorPanel sharedColorPanel] setTarget:self];
    [[NSColorPanel sharedColorPanel] setAction:@selector(changeGraphLineColor:)];
}

+ (void) initialize{

    [NSColorPanel setPickerMask:NSColorPanelCrayonModeMask];

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Set the font to a reasonable choice and convert to an NSData object
    NSFont *equationFont = [NSFont systemFontOfSize:18.0];
    NSData *fontData = [NSArchiver archivedDataWithRootObject:equationFont];

    
    NSColor *lineColor = [NSColor blackColor];
    NSData *colorData = [NSArchiver archivedDataWithRootObject:lineColor];
    
    NSDictionary *appDefaults = @{  @"equationFont" : fontData,
                                    @"lineColor" : colorData
                                 };
    [NSColorPanel sharedColorPanel];
    [NSFontPanel sharedFontPanel];
    // Change the action for the Font Panel so that the text field doesn't swallow the changes
    [[NSFontManager sharedFontManager] setAction:@selector(changeEquationFont:)];
    
    [userDefaults registerDefaults:appDefaults];
}

- (void)changeEquationFont:(NSFontManager*)sender{
    // Get the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Get the user's font selection and convert from NSData to NSFont
    NSData *fontData = [userDefaults dataForKey:@"equationFont"];
    NSFont *equationFont = (NSFont *)[NSUnarchiver unarchiveObjectWithData:fontData];
    // Convert the font to the new selection
    NSFont *newFont = [sender convertFont:equationFont];
    // Convert the new font into an NSData object and set it back into the user defaults
    fontData = [NSArchiver archivedDataWithRootObject:newFont];
    [userDefaults setObject:fontData forKey:@"equationFont"];
    // Tell the equation entry field to update to the new font
    [self.equationEntryVC controlTextDidChange:nil];
}

- (void)changeGraphLineColor:(NSColorPanel*)sender{
    NSData *colorData = [NSArchiver archivedDataWithRootObject:[sender color]];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"lineColor"];
    
    [self.graphTableVC.graphView setNeedsDisplay:YES];
}

- (IBAction)showPreferencesPanel:(id)sender{
    if (self.preferencesController == nil) {
        self.preferencesController = [[PreferencesController alloc] init];
    }
    [self.preferencesController showWindow:self];
}

- (IBAction)exportAs:(id)sender{
    //получить изображение из вью
    NSBitmapImageRep *imageRep = [self.graphTableVC export];
    
    //сформировать изображение PNG
    NSData *data = [imageRep representationUsingType:NSPNGFileType
                                          properties:nil];
    //создать диалоговое окно SaveAs
    NSSavePanel *saveDlg = [NSSavePanel savePanel];
    [saveDlg setAllowedFileTypes:@[@"png"]];
    
    //открыть диалоговое окно и сохранить по нажатию ОК
    NSInteger result = [saveDlg runModal];
    if (result == NSOKButton) {
        [data writeToURL:saveDlg.URL atomically:YES];
    }
}

#pragma mark
#pragma mark CoreData

- (NSManagedObjectModel*)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storeURL = [NSURL fileURLWithPath:[dir stringByAppendingPathComponent:@"graphique.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"Unresolded error %@, %@", error, error.userInfo);
        abort() ;
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext*)managedObjectContext{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

#pragma mark
#pragma mark Save As
- (void)saveDocumentAs: (id)sender{
    NSString *text = self.equationEntryVC.textField.stringValue;
    
    NSSavePanel *saveDlg = [NSSavePanel savePanel];
    [saveDlg setAllowedFileTypes:@[kFileExtension]];
    
    NSInteger result = [saveDlg runModal];
    if (result == NSOKButton) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:text forKey:kEquation];
        [data writeToURL:saveDlg.URL atomically:YES];
    }
}

- (void)openDocument:(id)sender{
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    [openDlg setAllowedFileTypes:@[kFileExtension]];
    NSInteger result = [openDlg runModal];
    if (result == NSOKButton) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfURL:openDlg.URL];
        [self loadData:data];
    }
}

- (void)loadData:(NSDictionary*) data{
    NSString *equationText = [data objectForKey:kEquation];
    Equation *equation = [[Equation alloc] initWithString:equationText];
    
    [self.equationEntryVC.textField setStringValue:equation.text];
    [self.graphTableVC draw:equation];
    
    [self.equationEntryVC controlTextDidChange:nil];
}














@end
