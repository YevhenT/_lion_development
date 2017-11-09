//
//  EquationToken.h
//  Graphique
//
//  Created by Yevhen Triukhan on 02.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    EquationTokenTypeInvalid = 0,
    EquationTokenTypeNumber,
    EquationTokenTypeVariable,
    EquationTokenTypeOperator,
    EquationTokenTypeOpenParen,
    EquationTokenTypeCloseParen,
    EquationTokenTypeExponent,
    EquationTokenTypeSymbol,
    EquationTokenTypeTrigFunction,
    EquationTokenTypeWhitespace
} EquationTokenType;




@interface EquationToken : NSObject

@property (nonatomic, assign) EquationTokenType type;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) BOOL valid;

- (instancetype) initWithType:(EquationTokenType)type andValue:(NSString*)value;



@end
