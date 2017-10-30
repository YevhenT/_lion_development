//
//  Equation.m
//  Graphique
//
//  Created by Yevhen Triukhan on 29.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "Equation.h"

static
NSString * kPathToAWK = @"/usr/bin/awk";


@interface Equation ()

@property (nonatomic, strong) NSString *text;

- (BOOL) produceError:(NSError**)error withCode:(NSInteger)code andMessage:(NSString*)message;

@end
@implementation Equation

- (id) init{
    self = [self initWithString:@""];
    
    return self;
}

- (id) initWithString:(NSString *)string{
    self = [super init];
    if (self) {
        _text = string;
    }
    
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"Equation [ %@ ]", self.text];
}

- (CGFloat) evaluateForX: (CGFloat) x{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: kPathToAWK];
    
    NSArray *arguments = @[
                           [NSString stringWithFormat:@"BEGIN { x = %f ; print %@ ;}", x, self.text]
                           ];
    [task setArguments:arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    float value = [string floatValue];

    return value;
}

- (BOOL)validate: (NSError**)error{
    NSUInteger open = 0;
    NSUInteger close = 0;
    unichar previous = 0;
    NSString *allowCharacters = @"x()+-*/^0123456789. ";
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:allowCharacters];
    NSCharacterSet *operators = [NSCharacterSet characterSetWithCharactersInString:@"x+-*/^"];
    

    for (int i = 0; i < self.text.length; i++) {
        unichar c = [self.text characterAtIndex: i];
        if (![cs characterIsMember:c]) {
            return [self produceError:error withCode:100 andMessage:
                    [NSString stringWithFormat:@"Invalid character typed. Only '%@' are allowed", allowCharacters]];
        }
        else
            if (c == '(') open++;
        else
            if (c == ')') close++;
        
        if ([operators characterIsMember:c] && [operators characterIsMember:previous]) {
            return [self produceError:error withCode:101 andMessage:
                    [NSString stringWithFormat:@"Consecutive operators are not allowed"]];
        }
        if (c != ' ') {
            previous = c;
        }
    }
    
    if (open < close) {
        return [self produceError:error withCode:102 andMessage:
                [NSString stringWithFormat:@"Too many closed parentheses"]];
    }
    else if (open > close) {
        return [self produceError:error withCode:103 andMessage:
                [NSString stringWithFormat:@"Too many open parentheses"]];
    }
    
    return YES;
}

- (BOOL) produceError:(NSError *__autoreleasing *)error withCode:(NSInteger)code andMessage:(NSString *)message{
    if (error != NULL) {
        NSMutableDictionary *errorDetail = @{NSLocalizedDescriptionKey: message}.mutableCopy;
        *error = [NSError errorWithDomain:@"Graphique" code:code userInfo:errorDetail];
    }
    
    return NO;
}
@end
