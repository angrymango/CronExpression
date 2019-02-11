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
-(NSDate*)getNearestWeekday:(NSInteger)currentYear month:(NSInteger)currentMonth day:(NSInteger)targetDay;
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
    NSDateComponents *comps = [cal components:NSCalendarUnitMonth fromDate:date];
    
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay
                              inUnit:NSCalendarUnitMonth
                             forDate:[cal dateFromComponents:comps]];
    
    return range.length;
}

-(NSDate*)getNearestWeekday:(NSInteger)currentYear month:(NSInteger)currentMonth day:(NSInteger)targetDay
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
    
    NSCalendar* calendar = self.calendar;
    NSDateComponents* components = [[NSDateComponents alloc]init];
    components.day = targetDay;
    components.month = currentMonth;
    components.year = currentYear;
    
    NSDate* target = [calendar dateFromComponents: components];
    
    NSDateComponents *weekdayComponents = [calendar components: NSCalendarUnitWeekday fromDate: target];
    if(weekdayComponents.weekday < 6)
    {
        return target;
    }
    
    NSUInteger lastDayOfMonth = [DayOfMonthField getLastDayOfMonth: target];
    NSArray* adjustments = [NSArray arrayWithObjects:[NSNumber numberWithInt: -1], [NSNumber numberWithInt: 1], [NSNumber numberWithInt: -2], [NSNumber numberWithInt: 2], nil];
    NSNumber* adjustment;
    
    for (adjustment in adjustments)
	{
        NSInteger adjusted = targetDay + [adjustment intValue];
        
        if(adjusted > 0 && adjusted <= lastDayOfMonth)
        {
            components.day = adjusted;
            NSDate* adjustedTarget = [calendar dateFromComponents: components];
            NSDateComponents *adjustedWeekdayComponents = [calendar components: NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate: adjustedTarget];
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
    
    if ([value isEqualToString:@"?"])
    {
        return YES;
    }
    
    NSCalendar* calendar = self.calendar;
    NSDateComponents* components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    if ([value isEqualToString:@"L"])
    {
        return components.day == [DayOfMonthField getLastDayOfMonth: date];
    }
    
    NSRange range = [value rangeOfString:@"W"];
    
    if (range.location != NSNotFound) {
        NSString* targetDay = [value substringWithRange:NSMakeRange(0, range.location)];
        NSDate* nearestWeekday = [self getNearestWeekday:components.year month:components.month day:[targetDay integerValue]];
        
        NSDateComponents* nearestWeekdayComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:nearestWeekday];
        
        return components.day == nearestWeekdayComponents.day;
    }
    long i = (long)components.day;
    BOOL result = [self isSatisfied: [NSString stringWithFormat:@"%ld", i] withValue:value];
    if (result)
    {
        [self hasSatisfied:[NSNumber numberWithLong:i]];
    }
    return result;
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
    NSDateComponents *integralComponents = [calendar components:NSUIntegerMax fromDate: date];
    NSNumber* newValue = nil;
    integralComponents.hour = integralComponents.minute = integralComponents.second = 0;
    if (self.canUseCache)
    {
        newValue = [self minisSatisfied:[NSNumber numberWithInteger:integralComponents.day]];
    }
    if (newValue)
    {
        integralComponents.day = [newValue integerValue];
        return [calendar dateFromComponents:integralComponents];
    } else {
        NSDateComponents* components = [[NSDateComponents alloc] init];
        components.day = 1;
        return [calendar dateByAddingComponents:components toDate:[calendar dateFromComponents: integralComponents] options:0];
    }
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
