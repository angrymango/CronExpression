#import "MonthField.h"

@implementation MonthField

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
    /*// Convert text month values to integers
     $value = strtr($value, array(
        'JAN' => 1,
        'FEB' => 2,
        'MAR' => 3,
        'APR' => 4,
        'MAY' => 5,
        'JUN' => 6,
        'JUL' => 7,
        'AUG' => 8,
        'SEP' => 9,
        'OCT' => 10,
        'NOV' => 11,
        'DEC' => 12
     ));
     
     return $this->isSatisfied($date->format('m'), $value);*/
    
    NSDictionary* monthMap = [NSDictionary dictionaryWithObjects:
                              [NSArray arrayWithObjects:@"JAN", @"FEB", @"MAR", @"APR", @"MAY", @"JUN", @"JUL", @"AUG", @"SEP", @"OCT", @"NOV", @"DEC", nil] 
                                                         forKeys:[NSArray arrayWithObjects:
                                                                    [NSNumber numberWithInteger: 1], 
                                                                    [NSNumber numberWithInteger: 2], 
                                                                    [NSNumber numberWithInteger: 3], 
                                                                    [NSNumber numberWithInteger: 4], 
                                                                    [NSNumber numberWithInteger: 5], 
                                                                    [NSNumber numberWithInteger: 6], 
                                                                    [NSNumber numberWithInteger: 7], 
                                                                    [NSNumber numberWithInteger: 8],
                                                                    [NSNumber numberWithInteger: 9],
                                                                    [NSNumber numberWithInteger: 10],
                                                                    [NSNumber numberWithInteger: 11],
                                                                    [NSNumber numberWithInteger: 12],nil]];

    return [self isSatisfied: [NSString stringWithFormat:@"%d", [monthMap objectForKey:value]] withValue:value];;
}

-(NSDate*) increment:(NSDate*)date
{
    /*$date->add(new DateInterval('P1M'));
     $date->setDate($date->format('Y'), $date->format('m'), 1);
     $date->setTime(0, 0, 0);
     
     return $this;*/
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    NSDateComponents *midnightComponents = [[calendar components: NSUIntegerMax fromDate: date] autorelease];
    midnightComponents.hour = midnightComponents.minute = midnightComponents.second = 0;
    
    NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
    components.month = 1;
    
    return [calendar dateByAddingComponents: components toDate: [calendar dateFromComponents: midnightComponents] options: 0];
}

-(BOOL) validate:(NSString*)value
{
     /*return (bool) preg_match('/[\*,\/\-0-9A-Z]+/', $value);*/
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\*,\\/\\-0-9A-Z]+" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(error != NULL)
    {
        NSLog(@"%@", error);
    }
    
    return [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])] > 0;
}

@end
