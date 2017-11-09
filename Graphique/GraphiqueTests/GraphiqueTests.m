//
//  GraphiqueTests.m
//  GraphiqueTests
//
//  Created by Yevhen Triukhan on 26.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Equation.h"

@interface GraphiqueTests : XCTestCase

@end

@implementation GraphiqueTests

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

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void) testEquationValidation{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"( 3+4*7/(3+4))"];
    XCTAssert([equation validate:&error], @"/n/nEquation should be valid/n/n");
}

- (void)testEquationValidationInvalidCharacters{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"2*z"];
    XCTAssertFalse([equation validate:&error], @"/n/nEquation should not have been valid/n/n");
    XCTAssert([error code] == 100, @"/n/nValidation should have failed with code 100 instead of %ld/n/n",[error code]);
}
- (void)testEquationValidationWithConsecutiveOperators{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"2++3"];
    XCTAssertFalse([equation validate:&error], @"/n/nEquation should not have been valid/n/n");
    XCTAssert([error code] == 101, @"/n/nValidation should have failed with code 101 instead of %ld/n/n",[error code]);
}
- (void)testEquationValidationWithTooManyOpenBrackets{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"((2+3)"];
    XCTAssertFalse([equation validate:&error], @"/n/nEquation should not have been valid/n/n");
    XCTAssert([error code] == 103, @"/n/nValidation should have failed with code 102 instead of %ld/n/n",[error code]);
}
- (void)testEquationValidationWithTooManyClosedBrackets{
    NSError *error = nil;
    Equation *equation = [[Equation alloc] initWithString:@"(2+3))"];
    XCTAssertFalse([equation validate:&error], @"/n/nEquation should not have been valid/n/n");
    XCTAssert([error code] == 102, @"/n/nValidation should have failed with code 103 instead of %ld/n/n",[error code]);
}

@end
