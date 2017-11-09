//
//  Equation.m
//  Graphique
//
//  Created by Yevhen Triukhan on 29.10.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "Equation.h"

@interface Equation ()

@property (nonatomic, strong) NSString *text;

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
    return 0;
}
@end
