#import "DayOfMonthField.h"

@interface DayOfMonthField()

/**
 * Get the nearest day of the week for a given day in a month
 *
 * @param int currentYear Current year
 * @param int currentYear Current month
 * @param int targetDay Target day of the month
 *
 * @return DateTime Returns the nearest date
 */
-(NSDate*)getNearestWeekday: (NSUInteger)currentYear: (NSUInteger)currentMonth: (NSUInteger)targetDay;

@end

@implementation DayOfMonthField

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(NSUInteger)getLastDayOfMonth: (NSDate*) date
{
    /*switch ($date->format('n')) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 4: case 6: case 9: case 11:
            return 30;
        case 2:
            return (bool) $date->format('L') ? 29 : 28;
     }*/
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSMonthCalendarUnit fromDate:date];
    
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                              inUnit:NSMonthCalendarUnit
                             forDate:[cal dateFromComponents:comps]];
    
    return range.length;
}

-(NSDate*)getNearestWeekday: (NSUInteger)currentYear: (NSUInteger)currentMonth: (NSUInteger)targetDay
{
    /*$tday = str_pad($targetDay, 2, '0', STR_PAD_LEFT);
     $target = DateTime::createFromFormat('Y-m-d', "$currentYear-$currentMonth-$tday");
     $currentWeekday = (int) $target->format('N');
     
     if ($currentWeekday < 6) {
        return $target;
     }
     
     $lastDayOfMonth = self::getLastDayOfMonth($target);
     
     foreach (array(-1, 1, -2, 2) as $i) {
        $adjusted = $targetDay + $i;
        if ($adjusted > 0 && $adjusted <= $lastDayOfMonth) {
            $target->setDate($currentYear, $currentMonth, $adjusted);
            if ($target->format('N') < 6 && $target->format('m') == $currentMonth) {
                return $target;
            }
        }
     }*/
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents* components = [[[NSDateComponents alloc]init] autorelease];
    components.day = targetDay;
    components.month = currentMonth;
    components.year = currentYear;
    
    NSDate* target = [calendar dateFromComponents: components];
    
    NSDateComponents *weekdayComponents = [[calendar components: NSWeekdayCalendarUnit fromDate: target] autorelease];
    if(weekdayComponents.weekday < 6)
    {
        return target;
    }
    
    NSUInteger lastDayOfMonth = [DayOfMonthField getLastDayOfMonth: target];
    NSArray* adjustments = [NSArray arrayWithObjects:[NSNumber numberWithInt: -1], [NSNumber numberWithInt: 1], [NSNumber numberWithInt: -2], [NSNumber numberWithInt: 2], nil];
    NSNumber* adjustment;
    
    for (adjustment in adjustments)
	{
        int adjusted = targetDay + [adjustment intValue]; 
        
        if(adjusted > 0 && adjusted <= lastDayOfMonth)
        {
            components.day = adjusted;
            
            NSDate* adjustedTarget = [calendar dateFromComponents: components];
            NSDateComponents *adjustedWeekdayComponents = [[calendar components: NSWeekdayCalendarUnit | NSMonthCalendarUnit fromDate: adjustedTarget] autorelease];
            
            if(adjustedWeekdayComponents.weekday < 6 && adjustedWeekdayComponents.month == currentMonth)
            {
                return adjustedTarget;
            }
        }
	}
    
    return nil;
}

-(BOOL)isSatisfiedBy: (NSDate*)date byValue:(NSString*)value
{
    /*// ? states that the field value is to be skipped
     if ($value == '?') {
        return true;
     }
     
     $fieldValue = $date->format('d');
     
     // Check to see if this is the last day of the month
     if ($value == 'L') {
        return $fieldValue == self::getLastDayOfMonth($date);
     }
     
     // Check to see if this is the nearest weekday to a particular value
     if (strpos($value, 'W')) {
        // Parse the target day
        $targetDay = substr($value, 0, strpos($value, 'W'));
        // Find out if the current day is the nearest day of the week
        return $date->format('j') == self::getNearestWeekday($date->format('Y'), $date->format('m'), $targetDay)->format('j');
     }
     
     return $this->isSatisfied($date->format('d'), $value);*/
    
    if (value == @"?") 
    {
        return YES;
    }
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents* components = [[calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date]autorelease];
    
    if (value == @"L") 
    {
        return components.day == [DayOfMonthField getLastDayOfMonth: date];
    }
    
    NSRange range = [value rangeOfString : @"W"];
    
    if (range.location != NSNotFound) {
        NSString* targetDay = [value substringWithRange:NSMakeRange(0, range.location)];
        NSDate* nearestWeekday = [self getNearestWeekday:components.year :components.month : [targetDay integerValue]];
        
        NSDateComponents* nearestWeekdayComponents = [[calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:nearestWeekday]autorelease];
        
        return components.day == nearestWeekdayComponents.day;
    }
    
    return [self isSatisfied:[NSString stringWithFormat:@"%02d", components.day] withValue:value];
}

-(NSDate*) increment:(NSDate*)date
{
    /*$date->add(new DateInterval('P1D'));
     $date->setTime(0, 0, 0);
     
     return $this;*/
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    NSDateComponents *midnightComponents = [[calendar components: NSUIntegerMax fromDate: date] autorelease];
    midnightComponents.hour = midnightComponents.minute = midnightComponents.second = 0;
    
    NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
    components.day = 1;
    
    return [calendar dateByAddingComponents: components toDate: [calendar dateFromComponents: midnightComponents] options: 0];
}

-(BOOL) validate:(NSString*)value
{
    /*return (bool) preg_match('/[\*,\/\-\?LW0-9A-Za-z]+/', $value);*/
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\*,\\/\\-\\?LW0-9A-Za-z]+" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(error != NULL)
    {
        NSLog(@"%@", error);
    }
    
    return [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])] > 0;
}

@end
