//
//  Equation.m
//  Graphique
//
//  Created by Yevhen Triukhan on 29.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "Equation.h"
#import "EquationToken.h"
#import "Stack.h"

static
NSString * kPathToAWK = @"/usr/bin/awk";

static NSArray *OPERATORS;
static NSArray *TRIG_FUNCTIONS;
static NSArray *SYMBOLS;


@interface Equation ()

@property (nonatomic, strong) NSString *text;

- (BOOL) produceError:(NSError**)error withCode:(NSInteger)code andMessage:(NSString*)message;
- (void) tokenize;
- (EquationToken*) newTokenFromString:(NSString*)string;

@end
@implementation Equation

+ (void) initialize{
    OPERATORS = @[@"+", @"-", @"*", @"/", @"^"];
    TRIG_FUNCTIONS = @[@"sin", @"cos"];
    SYMBOLS = @[@"pi", @"e", @"\u03c0"];
}



//- (id) init{
//    self = [self initWithString:@""];
//    
//    return self;
//}

- (id) initWithString:(NSString *)string{
    self = [super init];
    if (self) {
        _text = string;
        _tokens = [NSMutableArray array];
        [self tokenize];
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
    NSCharacterSet *operators = [NSCharacterSet characterSetWithCharactersInString:@"+-*/^"];
    

    for (int i = 0; i < self.text.length; i++) {
        unichar c = [self.text characterAtIndex: i];
        if (![cs characterIsMember:c]) {
            return [self produceError:error withCode:100 andMessage:
                    [NSString stringWithFormat:@"Invalid character typed. Only '%@' are allowed.", allowCharacters]];
        }
        else
            if (c == '(') open++;
        else
            if (c == ')') close++;
        
        if ([operators characterIsMember:c] && [operators characterIsMember:previous]) {
            return [self produceError:error withCode:101 andMessage:
                    [NSString stringWithFormat:@"Consecutive operators are not allowed."]];
        }
        if (c != ' ') {
            previous = c;
        }
    }
    
    if (open < close) {
        return [self produceError:error withCode:102 andMessage:
                [NSString stringWithFormat:@"Too many closed parentheses."]];
    }
    else if (open > close) {
        return [self produceError:error withCode:103 andMessage:
                [NSString stringWithFormat:@"Too many open parentheses."]];
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

- (void) tokenize{
    
    [self.tokens removeAllObjects];

    Stack *stack = [Stack new];
    NSString *temp = @"";
    EquationToken *token = nil;
    
    for (NSUInteger i = 0, n = self.text.length; i < n; i++) {
        unichar c = [self.text characterAtIndex:i];
        temp = [temp stringByAppendingFormat:@"%c", c];

        // Keep all digits of a number as one token
        if (isdigit(c) || c == '.'){
            // Keep reading characters until we hit the end of the string
            // n-1 т.к. далее должен учитываться следующий символ, 
            while (i < (n - 1)){
                // Increment our loop variable
                ++i;
                // Get the next character
                c = [self.text characterAtIndex:i];
                // Test to see whether to continue
                if (isdigit(c) || c == '.')
                {
                    // Append the character to the temp string
                    temp = [temp stringByAppendingFormat:@"%C", c];
                } else {
                    // Character didn't match, so back the loop counter up and exit
                    --i;
                    break;
                }
            }
        }
        // Keep all spaces
        else if (c == ' ') {
        // Keep reading characters until we hit the end of the string
            while (i < (n - 1)){
            // Increment our loop variable
            ++i;
            // Get the next character
            c = [self.text characterAtIndex:i];
            // Test to see whether to continue
            if (c == ' '){
                // Append the character to the temp string
                temp = [temp stringByAppendingFormat:@"%C", c];
            } else {
                // Character didn't match, so back the loop counter up and exit
                --i;
                break;
            }
        }
    }
        
    // Check for trig functions
    for (NSString *trig in TRIG_FUNCTIONS) {
        if (trig.length <= (n - i) && [trig isEqualToString:[[self.text substringWithRange:NSMakeRange(i, trig.length)] lowercaseString]])
        {
            temp = trig;
            i += (trig.length - 1);
            break;
        }
    }
    // Check for symbols
    for (NSString *symbol in SYMBOLS) {
        if (symbol.length <= (n - i) &&
            [symbol isEqualToString:[[self.text substringWithRange:NSMakeRange(i, symbol.length)] lowercaseString]])
        {
            temp = symbol;
            i += (symbol.length - 1);
            break;
        }
    }
        
        
        token = [self newTokenFromString:temp];
        
        // Determine if this should be an exponent
        // Check that we have a previous token to follow and that this is a number
        if (token.type == EquationTokenTypeNumber && !(self.tokens.count == 0))
        {
            // Get the previous token
            EquationToken *previousToken = [self.tokens lastObject];
            // If the previous token is a variable, close parenthesis, or the ^ operator, this is an exponent
                if (previousToken.type == EquationTokenTypeVariable || previousToken.type == EquationTokenTypeCloseParen || [previousToken.value isEqualToString:@"^"])
                {
                    token.type = EquationTokenTypeExponent;
                }
            
        }
    
        // Do parenthesis matching
        if (token.type == EquationTokenTypeOpenParen) {
//            ￼ Set the new open and push it onto
            token.valid = NO;
            [stack push:token];
            //parenthesis to invalid, as it's not yet matched, the stack
        }
        else if (token.type == EquationTokenTypeCloseParen) {
            // See if we have a matching open parenthesis
            if (![stack hasObjects])
            {
                // No open parenthesis to match, so this close parenthesis is invalid
                token.valid = NO;
            }
            else {
                // We have a matching open parenthesis, so set it (and this close parenthesis)
                // to valid and pop the open parenthesis off the stack
                EquationToken *match = [stack pop];
                match.valid = YES; }
        }
        
        // Numbers with more than one decimal point are invalid
        if (token.type == EquationTokenTypeNumber && [[token.value componentsSeparatedByString:@"."] count] > 2)
        {
            token.valid = NO;
        }
        
        [self.tokens addObject:token];
        temp = @""; //сброс строки?
    }
}

- (EquationToken*) newTokenFromString:(NSString *)string{
    EquationTokenType type;
    string = [string lowercaseString];
    
    if ([OPERATORS containsObject:string]) {
        type = EquationTokenTypeOperator;
    }
    else if ([TRIG_FUNCTIONS containsObject:string]) {
        type = EquationTokenTypeTrigFunction;
    }
    else if ([SYMBOLS containsObject:string]) {
        type = EquationTokenTypeSymbol;
    }
    else if ([string isEqualToString:@"("]) {
        type = EquationTokenTypeOpenParen;
    }
    else if ([string isEqualToString:@")"]) {
        type = EquationTokenTypeCloseParen;
    }
    else if ([string isEqualToString:@"x"]) {
        type = EquationTokenTypeVariable;
    }
    // Digits are all grouped together in the tokenize: method, so just check the first character
    else if (isdigit([string characterAtIndex:0]) || [string characterAtIndex:0] == '.') {
        type = EquationTokenTypeNumber;
    }
    // Spaces are all grouped together in the tokenize: method, so just check the first character
    else if ([string characterAtIndex:0] == ' ') {
        type = EquationTokenTypeWhitespace;
    }
    else {
        type = EquationTokenTypeInvalid;
    }
    return [[EquationToken alloc] initWithType:type andValue:string];
}
@end
