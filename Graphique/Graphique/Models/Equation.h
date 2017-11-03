//
//  Equation.h
//  Graphique
//
//  Created by Yevhen Triukhan on 29.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Equation : NSObject

@property (nonatomic, strong) NSMutableArray *tokens;

- (id) initWithString: (NSString*) string;
- (CGFloat) evaluateForX: (CGFloat) x;
- (BOOL)validate: (NSError**)error;
@end
