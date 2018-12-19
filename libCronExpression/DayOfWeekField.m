#import "DayOfWeekField.h"
#import "DayOfMonthField.h"

@implementation DayOfWeekField

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
    /*if ($value == '?') {
        return true;
     }
     
     // Convert text day of the week values to integers
     $value = strtr($value, array(
        'SUN' => 0,
        'MON' => 1,
        'TUE' => 2,
        'WED' => 3,
        'THU' => 4,
        'FRI' => 5,
        'SAT' => 6
     ));
     
     $currentYear = $date->format('Y');
     $currentMonth = $date->format('m');
     $lastDayOfMonth = DayOfMonthField::getLastDayOfMonth($date);
     
     // Find out if this is the last specific weekday of the month
     if (strpos($value, 'L')) {
        $weekday = str_replace('7', '0', substr($value, 0, strpos($value, 'L')));
        $tdate = clone $date;
        $tdate->setDate($currentYear, $currentMonth, $lastDayOfMonth);
        while ($tdate->format('w') != $weekday) {
            $tdate->setDate($currentYear, $currentMonth, --$lastDayOfMonth);
        }
     
        return $date->format('j') == $lastDayOfMonth;
     }
     
     // Handle # hash tokens
     if (strpos($value, '#')) {
        list($weekday, $nth) = explode('#', $value);
        // Validate the hash fields
        if ($weekday < 1 || $weekday > 5) {
            throw new InvalidArgumentException("Weekday must be a value between 1 and 5. {$weekday} given");
        }
        if ($nth > 5) {
            throw new InvalidArgumentException('There are never more than 5 of a given weekday in a month');
        }
        // The current weekday must match the targeted weekday to proceed
        if ($date->format('N') != $weekday) {
            return false;
        }
     
        $tdate = clone $date;
        $tdate->setDate($currentYear, $currentMonth, 1);
        $dayCount = 0;
        $currentDay = 1;
        while ($currentDay < $lastDayOfMonth + 1) {
            if ($tdate->format('N') == $weekday) {
                if (++$dayCount >= $nth) {
                    break;
                }
            }
            $tdate->setDate($currentYear, $currentMonth, ++$currentDay);
        }
     
        return $date->format('j') == $currentDay;
     }
     
     // Handle day of the week values
     if (strpos($value, '-')) {
        $parts = explode('-', $value);
        if ($parts[0] == '7') {
            $parts[0] = '0';
        } else if ($parts[1] == '0') {
            $parts[1] = '7';
        }
        $value = implode('-', $parts);
     }
     
     // Test to see which Sunday to use -- 0 == 7 == Sunday
     $format = in_array(7, str_split($value)) ? 'N' : 'w';
     $fieldValue = $date->format($format);
     
     return $this->isSatisfied($fieldValue, $value);*/
    
    if([value isEqualToString:@"?"])
    {
        return YES;
    }
    
    NSInteger units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    
    value = [value stringByReplacingOccurrencesOfString:@"SUN" withString:@"0"];
    value = [value stringByReplacingOccurrencesOfString:@"MON" withString:@"1"];
    value = [value stringByReplacingOccurrencesOfString:@"TUE" withString:@"2"];
    value = [value stringByReplacingOccurrencesOfString:@"WED" withString:@"3"];
    value = [value stringByReplacingOccurrencesOfString:@"THU" withString:@"4"];
    value = [value stringByReplacingOccurrencesOfString:@"FRI" withString:@"5"];
    value = [value stringByReplacingOccurrencesOfString:@"SAT" withString:@"6"];
    
    NSCalendar* calendar = self.calendar;
    
    NSUInteger lastDayOfMonth = [DayOfMonthField getLastDayOfMonth:date];
    
    // Find out if this is the last specific weekday of the month
    if([value rangeOfString : @"L"].location != NSNotFound)
    {
        NSInteger weekday = [[value substringToIndex: [value rangeOfString: @"L"].location] intValue];
        NSDateComponents *tcomponents = [calendar components: units fromDate: date] ;
        tcomponents.day = lastDayOfMonth;
        NSDate* tdate = [calendar dateFromComponents:tcomponents];
    
        NSDateComponents *wcomponents = [calendar components: units fromDate: tdate] ;
        
        while (wcomponents.weekday != weekday) 
        {
            tcomponents.day = --lastDayOfMonth;
            tdate = [calendar dateFromComponents:tcomponents];
            wcomponents = [calendar components: units fromDate: tdate];
        }
        
        wcomponents = [calendar components: units fromDate: date];
        return wcomponents.day == lastDayOfMonth;
    }
    
    // Handle # hash tokens
    if ([value rangeOfString : @"#"].location != NSNotFound) 
    {
        NSArray *parts = [value componentsSeparatedByString: @"#"];
        NSInteger weekday = [[parts objectAtIndex:0] intValue];
        NSInteger nth = [[parts objectAtIndex:1] intValue];
        
        if (weekday < 1 || weekday > 5) 
        {
            int i = (int)weekday;
            [NSException raise:@"Invalid Argument" format:@"Weekday must be a value between 1 and 5. %d given", i];
        }
        
        if (nth > 5) 
        {
            [NSException raise:@"Invalid Argument" format:@"There are never more than 5 of a given weekday in a month"];
        }
        
        NSDateComponents *tcomponents = [calendar components: units fromDate: date] ;
        
        // The current weekday must match the targeted weekday to proceed
        if (tcomponents.weekday != weekday) 
        {
            return NO;
        }
        
        tcomponents.day = 1;
        NSDate* tdate = [calendar dateFromComponents:tcomponents];

        NSInteger dayCount = 0;
        NSInteger currentDay = 1;
        
        while (currentDay < lastDayOfMonth + 1) 
        {
            if (tcomponents.weekday == weekday) 
            {
                if (++dayCount >= nth) 
                {
                    break;
                }
            }
            
            tcomponents = [calendar components: units fromDate: tdate];
            tcomponents.day = ++currentDay;
            tdate = [calendar dateFromComponents:tcomponents];
        }
        
        tcomponents = [calendar components: units fromDate: date];
        return tcomponents.day == currentDay;
    }
    
    NSDateComponents *components = [calendar components: units fromDate: date] ;
    // Test to see which Sunday to use -- 1 == 8 == Sunday
    long i = (long)components.weekday - 1;
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
    NSDateComponents *integralComponents = [calendar components:NSUIntegerMax fromDate: date];
    integralComponents.hour = integralComponents.minute = integralComponents.second = 0;
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = 1;
    return [calendar dateByAddingComponents:components toDate:[calendar dateFromComponents: integralComponents] options:0];
}

-(BOOL) validate:(NSString*)value
{
    /*return (bool) preg_match('/[\*,\/\-0-9A-Z]+/', $value);*/
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\*,\\?\\/\\-0-9A-Z]+" options:NSRegularExpressionCaseInsensitive error:&error];

    if(error != NULL)
    {
        NSLog(@"%@", error);
    }
    
    return [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])] > 0;
}

@end
