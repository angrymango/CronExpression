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
    
    if(value == @"?")
    {
        return YES;
    }
    
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    
    value = [value stringByReplacingOccurrencesOfString:@"SUN" withString:@"0"];
    value = [value stringByReplacingOccurrencesOfString:@"MON" withString:@"1"];
    value = [value stringByReplacingOccurrencesOfString:@"TUE" withString:@"2"];
    value = [value stringByReplacingOccurrencesOfString:@"WED" withString:@"3"];
    value = [value stringByReplacingOccurrencesOfString:@"THU" withString:@"4"];
    value = [value stringByReplacingOccurrencesOfString:@"FRI" withString:@"5"];
    value = [value stringByReplacingOccurrencesOfString:@"SAT" withString:@"6"];
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    
    NSUInteger lastDayOfMonth = [DayOfMonthField getLastDayOfMonth:date];
    
    // Find out if this is the last specific weekday of the month
    if([value rangeOfString : @"L"].location != NSNotFound)
    {
        NSInteger weekday = [[value substringToIndex: [value rangeOfString: @"L"].location] intValue];
        NSDateComponents *tcomponents = [[calendar components: units fromDate: date] autorelease];
        tcomponents.day = lastDayOfMonth;
        NSDate* tdate = [calendar dateFromComponents:tcomponents];
    
        NSDateComponents *wcomponents = [[calendar components: units fromDate: tdate] autorelease];
        
        while (wcomponents.weekday != weekday) 
        {
            tcomponents.day = --lastDayOfMonth;
            tdate = [calendar dateFromComponents:tcomponents];
            wcomponents = [[calendar components: units fromDate: tdate] autorelease];
        }
        
        wcomponents = [[calendar components: units fromDate: date] autorelease];
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
            [NSException raise:@"Invalid Argument" format:@"Weekday must be a value between 1 and 5. %d given", weekday];
        }
        
        if (nth > 5) 
        {
            [NSException raise:@"Invalid Argument" format:@"There are never more than 5 of a given weekday in a month"];
        }
        
        NSDateComponents *tcomponents = [[calendar components: units fromDate: date] autorelease];
        
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
            
            tcomponents = [[calendar components: units fromDate: tdate] autorelease];
            tcomponents.day = ++currentDay;
            tdate = [calendar dateFromComponents:tcomponents];
        }
        
        tcomponents = [[calendar components: units fromDate: date] autorelease];
        return tcomponents.day == currentDay;
    }
    
    // Test to see which Sunday to use -- 0 == 7 == Sunday
    NSDateComponents *components = [[calendar components: units fromDate: date] autorelease];
    return [self isSatisfied: [NSString stringWithFormat:@"%d", components] withValue:value];
}

-(NSDate*) increment:(NSDate*)date
{
    /*$date->add(new DateInterval('P1D'));
     $date->setTime(0, 0, 0);
     
     return $this;*/
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
    NSDateComponents *midnightComponents = [[calendar components: NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate: date] autorelease];
    midnightComponents.hour = midnightComponents.minute = midnightComponents.second = 0;
    
    NSDateComponents* components = [[[NSDateComponents alloc] init] autorelease];
    components.day = 1;
    
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
