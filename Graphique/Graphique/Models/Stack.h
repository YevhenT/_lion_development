//
//  Stack.h
//  Graphique
//
//  Created by Yevhen Triukhan on 03.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject
{
    @private NSMutableArray *stack;
}

- (void) push: (id)anObject;
- (id) pop;
- (BOOL) hasObjects;
@end
