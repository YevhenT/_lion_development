//
//  SteckTests.m
//  Graphique
//
//  Created by Yevhen Triukhan on 03.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Stack.h"

@interface SteckTests : XCTestCase

@end

@implementation SteckTests

- (void)setUp
{
    [super setUp];
    NSLog(@"####     STACK TESTS    #####\n");
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    NSLog(@"####     STACK TESTS    #####\n");

}

- (void)testPushAndPop
{
    Stack *stack = [Stack new];
    for (NSUInteger i = 0; i < 1000; i++) {
        [stack push:[NSString stringWithFormat:@"Strig #%lu", i]];
    }
    
    XCTAssertTrue([stack hasObjects], @"Stack should not be empty after pushing 1000 objects");
    
    for ( NSInteger i = 999; i >= 0; i--) {
        NSString *string = [stack pop];
        NSString *comp = [NSString stringWithFormat:@"Strig #%lu", i];
        XCTAssertEqualObjects(string, comp, @"Error comparasing");
    }
    
    XCTAssertFalse([stack hasObjects], @"Stack should be empty after poping 1000 objects");
    
}

@end
