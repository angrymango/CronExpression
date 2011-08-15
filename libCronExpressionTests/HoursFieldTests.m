//
//  HoursFieldTests.m
//  libCronExpression
//
//  Created by c 4 on 14/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HoursFieldTests.h"
#import "HoursField.h"

@implementation HoursFieldTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void) testValidatesField
{
    HoursField* field = [[HoursField alloc ]init];
    
    STAssertTrue([field validate: @"1"], @"1 is a valid value for hours");
    STAssertTrue([field validate: @"*"], @"* is a valid value for hours");
    STAssertTrue([field validate: @"*/3,1,1-12"], @"*/3,1,1-12 is a valid value for hours");
}


@end
