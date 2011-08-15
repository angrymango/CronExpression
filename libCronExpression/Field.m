#import "Field.h"

@implementation Field

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)isSatisfied: (NSString*)dateValue withValue:(NSString*)value
{
    /*if ($this->isIncrementsOfRanges($value)) {
        return $this->isInIncrementsOfRanges($dateValue, $value);
     } else if ($this->isRange($value)) {
        return $this->isInRange($dateValue, $value);
     }
     
     return $value == '*' || $dateValue == $value;*/
    
    if([self isIncrementsOfRanges:value])
    {
        return [self isInIncrementsOfRanges:dateValue withValue:value];
    }
    else if([self isRange:value])
    {
        return [self isInRange:dateValue withValue:value];
    }
    
    return value == @"*" || dateValue == value;
}

-(BOOL)isRange: (NSString*)value
{
    /*return strpos($value, '-') !== false;*/
    
    return [value rangeOfString : @"-"].location != NSNotFound;
}

-(BOOL)isIncrementsOfRanges: (NSString*)value
{
    /*return strpos($value, '/') !== false;*/
    
    return [value rangeOfString : @"/"].location != NSNotFound;
}

-(BOOL)isInRange: (NSString*)dateValue withValue:(NSString*)value
{
    /*$parts = array_map('trim', explode('-', $value, 2));
     
     return $dateValue >= $parts[0] && $dateValue <= $parts[1];*/
    
    NSArray *parts = [value componentsSeparatedByString: @"-"];
    
    return [dateValue intValue] >= [[parts objectAtIndex:0] intValue] && [dateValue intValue] <= [[parts objectAtIndex:1] intValue];
}

-(BOOL)isInIncrementsOfRanges: (NSString*)dateValue withValue:(NSString*)value
{
    /*$parts = array_map('trim', explode('/', $value, 2));
     if ($parts[0] != '*' && $parts[0] != 0) {
        if (!strpos($parts[0], '-')) {
            throw new InvalidArgumentException('Invalid increments of ranges value: ' . $value);
        } else {
            list($after, $denominator) = explode('-', $parts[0]);
            if ($dateValue == $after) {
                return true;
            } else if ($dateValue < $after) {
                return false;
            }
        }
     }
     
     return (int) $dateValue % (int) $parts[1] == 0;*/
    
    NSArray *parts = [value componentsSeparatedByString: @"/"];
    if([parts objectAtIndex:0] != @"*" && [[parts objectAtIndex:0] intValue] != 0)
    {
        if([[parts objectAtIndex:0] rangeOfString : @"-"].location == NSNotFound)
        {
            [NSException raise:@"Invalid argument" format:@"Invalid increments of ranges value: %@", value];
        }
        else
        {
            NSArray *range = [[parts objectAtIndex:0] componentsSeparatedByString: @"-"];
            if([dateValue intValue] == [[range objectAtIndex:0] intValue])
            {
                return YES;
            }
            else if([dateValue intValue] < [[range objectAtIndex:0] intValue])
            {
                return NO;
            }
        }
    }
    
    return [dateValue intValue] % [[parts objectAtIndex:1] intValue] == 0;
}

@end
