//
//  PreferencesController.h
//  Graphique
//
//  Created by Yevhen Triukhan on 08.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController

@property (nonatomic, strong) IBOutlet NSButton *initialViewIsGraph;

-(IBAction)changeInitalView:(id)sender;

@end
