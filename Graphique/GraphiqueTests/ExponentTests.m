//
//  ExponentTests.m
//  Graphique
//
//  Created by Yevhen Triukhan on 02.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EquationToken.h"
#import "Equation.h"

@interface ExponentTests : XCTestCase

@end

@implementation ExponentTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testExponents {
    Equation *equation = [[Equation alloc] initWithString:@"32x2+(x+7)45+3^3"];
    
    NSArray *tokens = equation.tokens;
    
    XCTAssertTrue(tokens.count == 14, @"");
    EquationToken *token = nil;    
    
    token = [tokens objectAtIndex:0];
    XCTAssertEqual(EquationTokenTypeNumber, token.type, @"");
    XCTAssertEqualObjects(@"32", token.value, @"");
    
    token = [tokens objectAtIndex:2];
    XCTAssertEqual(EquationTokenTypeExponent, token.type, @"");
    XCTAssertEqualObjects(@"2", token.value, @"");
    
    token = [tokens objectAtIndex:7];
    XCTAssertEqual(EquationTokenTypeNumber, token.type, @"");
    XCTAssertEqualObjects(@"7", token.value, @"");
    
    token = [tokens objectAtIndex:9];
    XCTAssertEqual(EquationTokenTypeExponent, token.type, @"");
    XCTAssertEqualObjects(@"45", token.value, @"");
    
    token = [tokens objectAtIndex:11];
    XCTAssertEqual(EquationTokenTypeNumber, token.type, @"");
    XCTAssertEqualObjects(@"3", token.value, @"");
    
    token = [tokens objectAtIndex:13];
    XCTAssertEqual(EquationTokenTypeExponent, token.type, @"");
    XCTAssertEqualObjects(@"3", token.value, @""); }

@end
