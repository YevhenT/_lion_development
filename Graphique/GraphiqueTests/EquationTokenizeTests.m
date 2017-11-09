//
//  EquationTokenizeTests.m
//  Graphique
//
//  Created by Yevhen Triukhan on 03.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "EquationToken.h"
#import "Equation.h"

@interface EquationTokenizeTests : XCTestCase
@end

@implementation EquationTokenizeTests

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

- (void)helperTestToken:(EquationToken *)token type:(EquationTokenType)type value:(NSString *)value
{
    NSLog(@"\n--->> token.type = %d, type = %d\n", token.type, type);
    XCTAssertEqual(token.type, type, @"\n--->> token.type = %d, type = %d\n", token.type, type);
    XCTAssertEqualObjects(token.value, value, @"\n--->> token.type = %@, type = %@\n", token.value, value);
}

- (void)testSimple{
    Equation *equation = [[Equation alloc] initWithString:@"22*x-1"];
    NSArray *tokens = equation.tokens;
    XCTAssertTrue(tokens.count == 5, @"");
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeNumber
                    value:@"22"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeOperator
                    value:@"*"];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeVariable
                    value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeOperator
                    value:@"-"];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeNumber
                    value:@"1"];
}
- (void)testExponent{
    Equation *equation = [[Equation alloc] initWithString:@"x2"];
    NSArray *tokens = equation.tokens;
    
    XCTAssertTrue(tokens.count == 2, @"");
    EquationToken *tempToken = [tokens objectAtIndex:0];
    XCTAssertEqual(tempToken.type, EquationTokenTypeVariable, @"%d ! = %d", tempToken.type, EquationTokenTypeVariable);
    XCTAssertEqualObjects(tempToken.value, @"x", @"%@ != x", tempToken.value);
    
    tempToken = [tokens objectAtIndex:1];
    XCTAssertEqual(tempToken.type, EquationTokenTypeExponent, @"%d != %d",tempToken.type, EquationTokenTypeExponent);
    XCTAssertEqualObjects(tempToken.value, @"2", @"%@ != 2", tempToken.value);


//    XCTAssertEqualObjects(token.value, value, @"");
//    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeVariable
//                    value:@"x"];
//    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeExponent
//                    value:@"2"];
}
- (void)testExponentWithCaret{
    Equation *equation = [[Equation alloc] initWithString:@"x^2"];
    NSArray *tokens = equation.tokens;
    XCTAssertTrue(tokens.count == 3, @"");
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeVariable
                    value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeOperator
                    value:@"^"];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeExponent
                    value:@"2"];
}
- (void)testExponentWithParens{
    Equation *equation = [[Equation alloc] initWithString:@"(3x+7)2"];
    NSArray *tokens = equation.tokens;
    XCTAssertTrue(tokens.count == 7, @"");
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeOpenParen
                    value:@"("];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeNumber
                    value:@"3"];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeVariable
                    value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeNumber
                    value:@"7"];
    [self helperTestToken:[tokens objectAtIndex:5] type:EquationTokenTypeCloseParen
                    value:@")"];
    [self helperTestToken:[tokens objectAtIndex:6] type:EquationTokenTypeExponent
                    value:@"2"];
}
- (void)testWhitespace{
    Equation *equation = [[Equation alloc]initWithString:@"x + 7"];
    NSArray *tokens = equation.tokens;
    XCTAssertTrue(tokens.count == 5, @"");
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeVariable value:@"x"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeWhitespace value:@" "];

    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeOperator value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeWhitespace value:@" "];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeNumber value:@"7"];

}
- (void)testTrigFunctionsAndSymbols{
    Equation *equation = [[Equation alloc] initWithString:@"sin(0.3)+cos(3.3)+pi+e+\u03c0"];
    NSArray *tokens = equation.tokens;
    XCTAssertTrue(tokens.count == 15, @"");
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeTrigFunction
                    value:@"sin"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeOpenParen
                    value:@"("];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeNumber
                    value:@"0.3"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeCloseParen
                    value:@")"];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:5] type:EquationTokenTypeTrigFunction
                    value:@"cos"];
    [self helperTestToken:[tokens objectAtIndex:6] type:EquationTokenTypeOpenParen
                    value:@"("];
    [self helperTestToken:[tokens objectAtIndex:7] type:EquationTokenTypeNumber
                    value:@"3.3"];
    [self helperTestToken:[tokens objectAtIndex:8] type:EquationTokenTypeCloseParen
                    value:@")"];
    [self helperTestToken:[tokens objectAtIndex:9] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:10] type:EquationTokenTypeSymbol
                    value:@"pi"];
    [self helperTestToken:[tokens objectAtIndex:11] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:12] type:EquationTokenTypeSymbol
                    value:@"e"];
    [self helperTestToken:[tokens objectAtIndex:13] type:EquationTokenTypeOperator
                    value:@"+"];
    [self helperTestToken:[tokens objectAtIndex:14] type:EquationTokenTypeSymbol
                    value:@"\u03c0"];
}
- (void)testParenthesisMatching{
    {
        Equation *equation = [[Equation alloc]initWithString:@"()"];
        NSArray *tokens = equation.tokens;
        XCTAssertTrue(tokens.count == 2, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, @"");
    }
    {
        Equation *equation = [[Equation alloc]initWithString:@"(())"];
        NSArray *tokens = equation.tokens;
        XCTAssertTrue(tokens.count == 4, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:2]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:3]).valid, @"");
    }
    {
        Equation *equation = [[Equation alloc]initWithString:@"()()"];
        NSArray *tokens = equation.tokens;
        XCTAssertTrue(tokens.count == 4, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:2]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:3]).valid, @"");
    }
    {
        Equation *equation = [[Equation alloc]initWithString:@")("];
        NSArray *tokens = equation.tokens;
        XCTAssertTrue(tokens.count == 2, @"");
        XCTAssertFalse(((EquationToken *)[tokens objectAtIndex:0]).valid, @"");
        XCTAssertFalse(((EquationToken *)[tokens objectAtIndex:1]).valid, @"");
    }
    {
        Equation *equation = [[Equation alloc]initWithString:@"())"];
        NSArray *tokens = equation.tokens;
        XCTAssertTrue(tokens.count == 3, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, @"");
        XCTAssertFalse(((EquationToken *)[tokens objectAtIndex:2]).valid, @"");
    }
    {
        Equation *equation = [[Equation alloc]initWithString:@"(()))("];
        NSArray *tokens = equation.tokens;
        XCTAssertTrue(tokens.count == 6, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:0]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:1]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:2]).valid, @"");
        XCTAssertTrue(((EquationToken *)[tokens objectAtIndex:3]).valid, @"");
        XCTAssertFalse(((EquationToken *)[tokens objectAtIndex:4]).valid, @"");
        XCTAssertFalse(((EquationToken *)[tokens objectAtIndex:5]).valid, @"");
    }
}
- (void)testInvalid{
    Equation *equation = [[Equation alloc] initWithString:@"invalid0.3.3"];
    NSArray *tokens = equation.tokens;
    XCTAssertTrue(tokens.count == 8, @"");
    [self helperTestToken:[tokens objectAtIndex:0] type:EquationTokenTypeInvalid
                    value:@"i"];
    [self helperTestToken:[tokens objectAtIndex:1] type:EquationTokenTypeInvalid
                    value:@"n"];
    [self helperTestToken:[tokens objectAtIndex:2] type:EquationTokenTypeInvalid
                    value:@"v"];
    [self helperTestToken:[tokens objectAtIndex:3] type:EquationTokenTypeInvalid
                    value:@"a"];
    [self helperTestToken:[tokens objectAtIndex:4] type:EquationTokenTypeInvalid
                    value:@"l"];
    [self helperTestToken:[tokens objectAtIndex:5] type:EquationTokenTypeInvalid
                    value:@"i"];
    [self helperTestToken:[tokens objectAtIndex:6] type:EquationTokenTypeInvalid
                    value:@"d"];
    [self helperTestToken:[tokens objectAtIndex:7] type:EquationTokenTypeNumber
                    value:@"0.3.3"];
    XCTAssertFalse(((EquationToken *)[tokens objectAtIndex:7]).valid, @"");
    
}

@end
