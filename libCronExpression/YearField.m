//
//  YearField.m
//  Vision
//
//  Created by c 4 on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearField.h"

@implementation YearField

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)isSatisfiedBy: (NSDate*)date byValue:(NSString*)value
{
    /*return $this->isSatisfied($date->format('Y'), $value);*/
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    NSDateComponents *components = [[calendar components: NSYearCalendarUnit fromDate: date] autorelease];
    
    return [self isSatisfied: [NSString stringWithFormat:@"%d", components.year] withValue:value];
}

-(NSDate*) increment:(NSDate*)date
{
    /*$date->add(new DateInterval('P1Y'));
     $date->setDate($date->format('Y'), 1, 1);
     $date->setTime(0, 0, 0);
     
     return $this;*/
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    NSDateComponents *midnightComponents = [[calendar components: NSUIntegerMax fromDate: date] autorelease];
    midnightComponents.hour = midnightComponents.minute = midnightComponents.second = 0;
    
    NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
    components.year = 1;
    
    return [calendar dateByAddingComponents: components toDate: [calendar dateFromComponents: midnightComponents] options: 0];
}

-(BOOL) validate:(NSString*)value
{
    /*return (bool) preg_match('/[\*,\/\-0-9]+/', $value);*/
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\*,\\/\\-0-9]+" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(error != NULL)
    {
        NSLog(@"%@", error);
    }
    
    return [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])] > 0;
}

@end
