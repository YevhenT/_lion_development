//
//  GroupItem.h
//  Graphique
//
//  Created by Yevhen Triukhan on 27.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupItem : NSObject
{
//    @private
//    NSString *name;
//    NSMutableArray *children;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, assign) BOOL loaded;

- (NSInteger) numberOfChildren;
- (id) childAtIndex: (NSUInteger) n;
- (NSString*) text;

- (void) addChild: (id)childNode;
- (void)reset;
@end
