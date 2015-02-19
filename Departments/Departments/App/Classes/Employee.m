//
//  Employee.m
//  Departments
//
//  Created by Amarjit on 19/02/2015.
//  Copyright (c) 2015 Amarjit. All rights reserved.
//

#import "Employee.h"

@implementation Employee

- (instancetype)initWithName:(NSString *)empName
{
    self = [super init];
    if (self) {
        self.name = empName;
    }
    return self;
}

@end
