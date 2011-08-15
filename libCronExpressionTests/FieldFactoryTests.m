//
//  FieldFactoryTests.m
//  libCronExpression
//
//  Created by c 4 on 14/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FieldFactoryTests.h"
#import "FieldFactory.h"

@implementation FieldFactoryTests

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

-(void)testRetrievesFieldInstances
{
    NSDictionary* mappings = [NSDictionary dictionaryWithObjects:
                                [NSArray arrayWithObjects:@"MinutesField", @"HoursField",@"DayOfMonthField",@"MonthField",@"DayOfWeekField",@"YearField",nil]
                                                         forKeys:
                              [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],nil]];
    
    FieldFactory* factory = [[FieldFactory alloc] init];
    
    for(NSNumber* key in mappings)
    {
        NSObject* o = [factory getField: [key intValue]];
        STAssertEqualObjects(NSStringFromClass([o class]), [mappings objectForKey:key], nil);
    }
}

-(void)testValidatesFieldPosition
{
    FieldFactory* factory = [[FieldFactory alloc]init];
    STAssertThrows([factory getField: 10], @"Should raise exception!");
}

@end
