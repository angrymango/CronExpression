#import "CronExpression.h"

@implementation CronExpression

int const MINUTE = 0;
int const HOUR = 1;
int const DAY = 2;
int const MONTH = 3;
int const WEEKDAY = 4;
int const YEAR = 5;

-(id)init:(NSString*)schedule withFieldFactory:(FieldFactory*) fieldFactory
{
    /*$this->cronParts = explode(' ', $schedule);
     $this->fieldFactory = $fieldFactory;
     
     if (count($this->cronParts) < 5) {
        throw new InvalidArgumentException(
            $schedule . ' is not a valid CRON expression'
        );
     }
     
     foreach ($this->cronParts as $position => $part) {
        if (!$this->fieldFactory->getField($position)->validate($part)) {
            throw new InvalidArgumentException(
                'Invalid CRON field value ' . $part . ' as position ' . $position
            );
        }
     }*/
    
    self = [super init];
    if (self) {
        order = [NSArray arrayWithObjects: [NSNumber numberWithInteger:YEAR], [NSNumber numberWithInteger:MONTH], [NSNumber numberWithInteger:DAY], [NSNumber numberWithInteger:WEEKDAY], [NSNumber numberWithInteger:HOUR], [NSNumber numberWithInteger:MINUTE], nil];
        _fieldFactory = fieldFactory;
        cronParts = [schedule componentsSeparatedByString: @" "];
        
        if([cronParts count] < 5)
        {
            [NSException raise:@"Invalid cron expression" format:@"%@ is not a valid CRON expression", schedule];
        }
        
        [cronParts enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            if(![[_fieldFactory getField: idx] validate: (NSString*)object])
            {
                [NSException raise:@"Invalid cron part" format:@"Invalid CRON field value %@ as position %@", object, idx];
            }
        }];
    }
    
    return self;
}

+(CronExpression*) factory:(NSString*)expression: (FieldFactory*) fieldFactory
{
    /*$mappings = array(
     '@yearly' => '0 0 1 1 *',
     '@annually' => '0 0 1 1 *',
     '@monthly' => '0 0 1 * *',
     '@weekly' => '0 0 * * 0',
     '@daily' => '0 0 * * *',
     '@hourly' => '0 * * * *'
     );
     
     if (isset($mappings[$expression])) {
        $expression = $mappings[$expression];
     }
     
     return new self($expression, $fieldFactory ?: new FieldFactory());*/
    
    NSDictionary* mappings = [NSDictionary dictionaryWithObjects:
                              [NSArray arrayWithObjects: @"@yearly", 
                                                            @"@annually", 
                                                            @"@monthly", 
                                                            @"@weekly", 
                                                            @"@daily", 
                                                            @"@hourly", nil] 
                                forKeys:[NSArray arrayWithObjects: @"0 0 1 1 *", 
                                                                    @"0 0 1 1 *", 
                                                                    @"0 0 1 * *", 
                                                                    @"0 0 * * 0", 
                                                                    @"0 0 * * *", 
                                                                    @"0 * * * *", nil]];
    
    if([mappings objectForKey: expression])
    {
        expression = [mappings objectForKey: expression];
    }
    
    if(fieldFactory == nil)
    {
        fieldFactory = [[FieldFactory alloc] init];
    }
    
    return [[CronExpression alloc] init: expression withFieldFactory:fieldFactory];
}

-(NSDate*)getNextRunDate: (NSDate*)currentTime: (NSInteger)nth
{
    /*$currentDate = $currentTime instanceof DateTime
     ? $currentTime
     : new DateTime($currentTime ?: 'now');
     
     $nextRun = clone $currentDate;
     $nextRun->setTime($nextRun->format('H'), $nextRun->format('i'), 0);
     $nth = (int) $nth;
     
     // Set a hard limit to bail on an impossible date
     for ($i = 0; $i < 1000; $i++) {
     
     foreach (self::$order as $position) {
        $part = $this->getExpression($position);
        if (null === $part) {
            continue;
        }
     
        $satisfied = false;
        // Get the field object used to validate this part
        $field = $this->fieldFactory->getField($position);
        // Check if this is singular or a list
        if (strpos($part, ',') === false) {
            $satisfied = $field->isSatisfiedBy($nextRun, $part);
        } else {
            foreach (array_map('trim', explode(',', $part)) as $listPart) {
                if ($field->isSatisfiedBy($nextRun, $listPart)) {
                    $satisfied = true;
                    break;
                }
            }
        }
     
        // If the field is not satisfied, then start over
        if (!$satisfied) {
            $field->increment($nextRun);
            continue 2;
        }
     }
     
     // Skip this match if needed
     if (--$nth > -1) {
        $this->fieldFactory->getField(0)->increment($nextRun);
        continue;
     }
     
        return $nextRun;
     }
     
     // @codeCoverageIgnoreStart
     throw new RuntimeException('Impossible CRON expression');
     // @codeCoverageIgnoreEnd*/
    
    NSCalendar* calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents* components = [[calendar components:NSUIntegerMax fromDate:currentTime]autorelease];
    components.second = 0;
    NSDate* nextRun = [calendar dateFromComponents:components];
    
    // Set a hard limit to bail on an impossible date
    for (int i = 0; i < 1000; i++) 
    {
        for(NSNumber *position in order)
        {
            NSString* part = [self getExpression: [position intValue]];
            if (part == nil) 
            {
                continue;
            }
            
            BOOL satisfied = NO;
            
            id<FieldInterface> field = [_fieldFactory getField: [position intValue]];
            
            if ([part rangeOfString: @","].location == NSNotFound) 
            {
                satisfied = [field isSatisfiedBy:nextRun byValue:part];
            } 
            else 
            {
                for (NSString* listPart in [part componentsSeparatedByString:@","]) 
                {
                    if ([field isSatisfiedBy: nextRun byValue:listPart]) 
                    {
                        satisfied = YES;
                        break;
                    }
                }
            }
            
            // If the field is not satisfied, then start over
            if (!satisfied) {
                [field increment: nextRun];
                break;
            }
            
            // Skip this match if needed
            if (--nth > -1) 
            {
                [[_fieldFactory getField: 0] increment: nextRun];
                continue;
            }
            
            return nextRun;
        }
    }
    
    [NSException raise:@"Invalid Argument" format:@"Impossible CRON expression"];
    return nil;
}

-(NSString*)getExpression: (int)part
{
    /*if (null === $part) {
        return implode(' ', $this->cronParts);
     } else if (array_key_exists($part, $this->cronParts)) {
        return $this->cronParts[$part];
     }
     
     return null;*/
    
    if(part < 0)
    {
        return [cronParts componentsJoinedByString:@" "];
    }
    else if(part < [cronParts count])
    {
        return [cronParts objectAtIndex:part];
    }
    
    return nil;
}

-(BOOL)isDue: (NSDate*)currentTime
{
    /*if (null === $currentTime || 'now' === $currentTime) {
        $currentDate = date('Y-m-d H:i');
        $currentTime = strtotime($currentDate);
     } else if ($currentTime instanceof DateTime) {
        $currentDate = $currentTime->format('Y-m-d H:i');
        $currentTime = strtotime($currentDate);
     } else {
        $currentTime = new DateTime($currentTime);
        $currentTime->setTime($currentTime->format('H'), $currentTime->format('i'), 0);
        $currentDate = $currentTime->format('Y-m-d H:i');
        $currentTime = $currentTime->getTimeStamp();
     }
     
     return $this->getNextRunDate($currentDate)->getTimestamp() == $currentTime;*/

    
    return YES;
}

-(void)dealloc
{
    [super dealloc];
    [cronParts release];
    [order release];
    [_fieldFactory release];
}

@end
