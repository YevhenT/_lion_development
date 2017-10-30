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

#pragma mark -
#pragma mark Actions
- (IBAction)equationEntered:(id)sender{
    
    AppDelegate *delegate = NSApplication.sharedApplication.delegate;
    Equation *equation = [[Equation alloc] initWithString:[self.textField stringValue]];
    [delegate.graphTableVC draw:equation];

}

@end
