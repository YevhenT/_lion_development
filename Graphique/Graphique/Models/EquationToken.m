//
//  EquationToken.m
//  Graphique
//
//  Created by Yevhen Triukhan on 02.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "EquationToken.h"

@implementation EquationToken

//- (instancetype) init{
//    self = [self initWithType:EquationTokenTypeInvalid andValue:@""];
//    
//    return self;
//}

- (instancetype) initWithType:(EquationTokenType)type andValue:(NSString *)value{
    self = [super init];
    if (self) {
        _type = type;
        _value = value;
        _valid = (type != EquationTokenTypeInvalid);
    }
    
    return self;
}

@end
