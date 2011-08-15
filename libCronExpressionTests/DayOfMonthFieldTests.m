//
//  DayOfMonthFieldTests.m
//  libCronExpression
//
//  Created by c 4 on 14/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DayOfMonthFieldTests.h"
#import "DayOfMonthField.h"

@implementation DayOfMonthFieldTests

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

-(void)testValidatesField
{
    DayOfMonthField* field = [[DayOfMonthField alloc ]init];
    
    STAssertTrue([field validate: @"1"], @"1 is a valid value for day of week");
    STAssertTrue([field validate: @"*"], @"* is a valid value for day of week");
    STAssertTrue([field validate: @"*/3,1,1-12"], @"*/3,1,1-12 is a valid value for day of week");
    STAssertTrue([field validate: @"SUN-2"], @"SUN-2 is a valid value for day of week");
}

-(void)testChecksIfSatisfied
{
    DayOfMonthField* field = [[DayOfMonthField alloc ]init];
    STAssertTrue([field isSatisfiedBy: [NSDate date] byValue:@"?"], @"");
}

@end
