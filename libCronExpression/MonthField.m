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
    NSCalendar* calendar = self.calendar;
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate: date];
    long i = (long)components.month;
    return [self isSatisfied: [NSString stringWithFormat:@"%ld", i] withValue:value];
}

-(NSDate*) increment:(NSDate*)date
{
    // 此处需要考虑多个数值匹配的问题，所以每次自增的时候，需要自增后，将下一级单位清零
    /*
     具体情况比如：
     1.当前时间12:31:21，表达式0/5 2 *
     2.则在秒钟计算正确后为12:31:25，而分钟不匹配
     3.此时如果分钟自增而不清零秒钟，则为12:32:25，会跳过应该匹配的12:32:00等时间
     4.所以每次自增后，需要将下一级单位清零
     */
    NSCalendar* calendar = self.calendar;
    NSDateComponents *integralComponents = [calendar components:NSUIntegerMax fromDate:date];
    integralComponents.hour = integralComponents.minute = integralComponents.second = 0;
    integralComponents.day = 1;
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = 1;
    return [calendar dateByAddingComponents:components toDate:[calendar dateFromComponents: integralComponents] options:0];
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
