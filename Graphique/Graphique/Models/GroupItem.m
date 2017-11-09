//
//  GroupItem.m
//  Graphique
//
//  Created by Yevhen Triukhan on 27.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "GroupItem.h"

@implementation GroupItem

- (id) init {
    self = [super init];
    if (self) {
        self.children = [[NSMutableArray alloc] init];
        self.loaded = NO;
    }
    
    return self;
}

- (void) addChild:(id)childNode {
    [self.children addObject: childNode];
}

- (NSInteger) numberOfChildren {
    return [self.children count];
}

- (id) childAtIndex:(NSUInteger)n {
    return [self.children objectAtIndex:n];
}

- (NSString*) text {
    return self.name;
}

- (void)reset{
    [self.children removeAllObjects];
    self.loaded = NO;
}
@end
