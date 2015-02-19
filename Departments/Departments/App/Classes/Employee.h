//
//  Employee.h
//  Departments
//
//  Created by Amarjit on 19/02/2015.
//  Copyright (c) 2015 Amarjit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject
@property (nonatomic, strong) NSString *name;
- (instancetype)initWithName:(NSString *)empName;
@end
