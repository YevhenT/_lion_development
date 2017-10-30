//
//  EquationEntryViewController.m
//  Graphique
//
//  Created by Yevhen Triukhan on 26.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "EquationEntryViewController.h"

#import "Equation.h"
#import "AppDelegate.h"
#import "GraphTableViewController.h"

@interface EquationEntryViewController ()
@property (nonatomic, weak) IBOutlet NSTextField *textField;
@property (nonatomic, weak) IBOutlet NSTextField *feedback;
@end

@implementation EquationEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) alertDidEnd:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo{
    ;
}

- (void) controlTextDidChange:(NSNotification *)notification{
    Equation *equation = [[Equation alloc] initWithString:[self.textField stringValue]];
    NSError *error = nil;
    if ([equation validate:&error] == NO) {
        self.feedback.stringValue = [NSString stringWithFormat:@"Error %ld : %@", [error code], [error localizedDescription]];
    }
    else {
        self.feedback.stringValue = @"";
    }
}

#pragma mark -
#pragma mark Actions
- (IBAction)equationEntered:(id)sender{
    
    AppDelegate *delegate = NSApplication.sharedApplication.delegate;
    Equation *equation = [[Equation alloc] initWithString:[self.textField stringValue]];
    
    NSError *error = nil;
    if ([equation validate:&error] == NO) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Something went wrong"];
        [alert setInformativeText:[NSString stringWithFormat:@"Error %ld: %@.", [error code], [error localizedDescription]]];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:delegate.window
                          modalDelegate:self
                         didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                            contextInfo:nil];
    }
    else {
        [delegate.graphTableVC draw:equation];
    }
    

}

@end
