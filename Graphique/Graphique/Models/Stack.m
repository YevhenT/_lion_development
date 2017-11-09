//
//  Stack.m
//  Graphique
//
//  Created by Yevhen Triukhan on 03.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (instancetype) init{
    self = [super init];
    if (self) {
        stack = [NSMutableArray array];
    }
    
    return self;
}

- (void)push:(id)anObject{
    [stack addObject:anObject];
}

- (id) pop{
    id anObject = [stack lastObject];
    [stack removeLastObject];
    
    return anObject;
}

- (BOOL)hasObjects{
    return [stack count] > 0;
}
@end
