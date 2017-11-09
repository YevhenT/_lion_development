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
#import "RecentlyUsedEquationViewController.h"
#import "EquationToken.h"

static NSDictionary *COLORS;

@interface EquationEntryViewController ()

@property (nonatomic, weak) IBOutlet NSTextField *feedback;
@end

@implementation EquationEntryViewController

+ (void) initialize{
    COLORS = @{@(EquationTokenTypeInvalid):[NSColor whiteColor],
               @(EquationTokenTypeNumber):[NSColor blackColor],
               @(EquationTokenTypeVariable):[NSColor blueColor],
               @(EquationTokenTypeOperator):[NSColor brownColor],
               @(EquationTokenTypeOpenParen):[NSColor purpleColor],
               @(EquationTokenTypeCloseParen):[NSColor purpleColor],
               @(EquationTokenTypeExponent):[NSColor orangeColor],
               @(EquationTokenTypeSymbol):[NSColor cyanColor],
               @(EquationTokenTypeTrigFunction):[NSColor magentaColor],
               @(EquationTokenTypeWhitespace):[NSColor whiteColor]
               };
}

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
    
    // Create a mutable attributed string, initialized with the contents of the equation text field
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self.textField stringValue]];
    
    //из главы 5
    // Get the user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // Get the selected font
    NSData *fontData = [userDefaults dataForKey:@"equationFont"];
    NSFont *equationFont = (NSFont *)[NSUnarchiver unarchiveObjectWithData:fontData];
    // Set the selected font in the font panel
    
//    [[NSFontManager sharedFontManager] setSelectedFont:equationFont isMultiple:NO];
    
    // Set the font for the equation to the selected font
    [attributedString addAttribute:NSFontAttributeName
                             value:equationFont
                             range:NSMakeRange(0, [attributedString length])];
    
    
    
    
    
    // Variable to keep track of where we are in the attributed string
    long i = 0;
    // Loop through the tokens
    for (EquationToken *token in equation.tokens) {
        // The range makes any attributes we add apply to the current token only
        NSRange range = NSMakeRange(i, [token.value length]);
        // Add the foreground color
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:COLORS [@(token.type)]
                                 range:range];
        // Add the background color
        [attributedString addAttribute:NSBackgroundColorAttributeName value:token.valid ? [NSColor whiteColor] : [NSColor redColor] range:range];
        
        // If token is an exponent, make it superscript
        if (token.type == EquationTokenTypeExponent)
        {
            
            // Calculate the height of the exponent as half the height of the selected font
            CGFloat height = [equationFont pointSize] * 0.5;
            // Set the exponent font height
            [attributedString addAttribute:NSFontAttributeName
                                     value:[NSFont fontWithName:equationFont.fontName
                                                           size:height]
                                     range:range];
            
            // Get the height of the rest of the text
//            CGFloat height = [[self.textField font] pointSize] * 0.5;
            // Set the exponent font height
//            [attributedString addAttribute:NSFontAttributeName
//                                     value:[NSFont systemFontOfSize:height]
//                                     range:range];
            // Shift the exponent upwards
            [attributedString addAttribute:NSBaselineOffsetAttributeName
                                     value:[NSNumber numberWithInt:height]
                                     range:range];
        }
        
        // Advance the index to the next token
        i = i + [token.value length];
    }
    
    
    // Adjust the height of the equation entry text field to fit the new font size
    NSSize size = [self.textField frame].size;
    size.height = ceilf([equationFont ascender]) - floorf([equationFont descender]) + 4.0;
    [self.textField setFrameSize:size];
    
    // Set the attributed string back into the equation entry field
    [self.textField setAttributedStringValue:attributedString];
    

    
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
        [delegate.recentlyUsedEquationVC remember:equation];
        [delegate.graphTableVC draw:equation];
    }
    
}



@end
