//
//  Equation.h
//  Graphique
//
//  Created by Yevhen Triukhan on 29.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Equation : NSObject

- (id) initWithString: (NSString*) string;
- (CGFloat) evaluateForX: (CGFloat) x;

@end
