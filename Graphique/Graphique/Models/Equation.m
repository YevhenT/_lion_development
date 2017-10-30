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
@end
