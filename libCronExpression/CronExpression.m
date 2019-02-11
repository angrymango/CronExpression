#import "CronExpression.h"

@implementation CronExpression

int const SECOND = 0;
int const MINUTE = 1;
int const HOUR = 2;
int const DAY = 3;
int const MONTH = 4;
int const WEEKDAY = 5;
int const YEAR = 6;

-(id)init:(NSString*)schedule withFieldFactory:(FieldFactory*) fieldFactory
{
    /*$this->cronParts = explode(' ', $schedule);
     $this->fieldFactory = $fieldFactory;
     
     if (count($this->cronParts) < 5) {
        throw new InvalidArgumentException(
            $schedule . ' is not a valid CRON expression's
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
        // 顺序很重要，需要从粒度最小的单位开始适配，这样低产生进位后，可以保证正常的匹配
        order = [NSArray arrayWithObjects: [NSNumber numberWithInteger:SECOND], [NSNumber numberWithInteger:MINUTE], [NSNumber numberWithInteger:HOUR], [NSNumber numberWithInteger:DAY], [NSNumber numberWithInteger:WEEKDAY], [NSNumber numberWithInteger:MONTH], [NSNumber numberWithInteger:YEAR], nil];
        _fieldFactory = fieldFactory;
        cronParts = [schedule componentsSeparatedByString: @" "];
        
        if([cronParts count] < 6)
        {
            [NSException raise:@"Invalid cron expression" format:@"%@ is not a valid CRON expression", schedule];
        }
        
        [cronParts enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            if(![[_fieldFactory getField: idx] validate: (NSString*)object])
            {
                [NSException raise:@"Invalid cron part" format:@"Invalid CRON field value %@ as position %lu", object, (unsigned long)idx];
            }
        }];
    }
    
    return self;
}

+(CronExpression*)expression:(NSString*)expression factory:(FieldFactory*) fieldFactory
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

-(NSDate*)getNextRunDate:(NSDate*)currentTime nth:(NSInteger)nth
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

    NSDate* nextRun = currentTime;
    // Set a hard limit to bail on an impossible date
    // 实测最坏运算次数为1078次，先设置1500次/每轮
    NSInteger limit = 1500;
    if (nth > 0)
    {
        // 由于nth表示需要循环多少次，所以此处将极限值乘以次数，得出循环的最大值
        limit = (nth + 1) * limit;
    }
    for (NSInteger i = 0; i < limit; i++)
    {
        BOOL satisfied = NO;
        for(int fieldIndex = 0; fieldIndex < order.count; fieldIndex++)
        {
            NSNumber *position = [order objectAtIndex:fieldIndex];
            //由于变量移动到了外部循环，每次内部循环时需要重置标识位
            satisfied = NO;
            NSString* part = [self getExpression: [position intValue]];
            if (part == nil) 
            {
                continue;
            }
            
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
                nextRun = [field increment: nextRun];
                break;
            }
        }
        // 此处由于无法直接从内层循环直接continue外层循环，所以增加标识位，在外层循环处再判断一次。
        if (!satisfied) {
            continue;
        }
        // Skip this match if needed
        if (--nth > -1)
        {
            nextRun = [[_fieldFactory getField: 0] increment: nextRun];
            continue;
        }
        return nextRun;
    }
    
//    [NSException raise:@"Invalid Argument" format:@"Impossible CRON expression"];
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

- (NSArray<NSDate*>*)getNextRunDays:(NSDate*)startTime
                            endTime:(NSDate*)endTime
{
    NSDate* resultDate = startTime;
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:20];
    while (resultDate.timeIntervalSince1970 < endTime.timeIntervalSince1970 && resultDate)
    {
        resultDate = [self getNextRunDate:resultDate nth:0];
        if ([endTime compare:resultDate] == NSOrderedDescending)
        {
            [result addObject:resultDate];
        }
        resultDate = [resultDate dateByAddingTimeInterval:1];
    }
    return [result copy];
}

@end
