//
//  PreferencesController.m
//  Graphique
//
//  Created by Yevhen Triukhan on 08.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "PreferencesController.h"


static NSString *kInitialViewIsGraph = @"InitialViewIsGraph";
static NSString *kNibName = @"PreferencesController";

@interface PreferencesController ()

@end

@implementation PreferencesController

//- (id)initWithWindow:(NSWindow *)window
//{
//    self = [super initWithWindow:window];
//    if (self) {
//        // Initialization code here.
//    }
//    return self;
//}

- (id)init{
    self = [super initWithWindowNibName:kNibName];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self.initialViewIsGraph setState:[userDefaults boolForKey:kInitialViewIsGraph]];
    
}

-(IBAction)changeInitalView:(id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:[self.initialViewIsGraph state] forKey:kInitialViewIsGraph];
}

@end
