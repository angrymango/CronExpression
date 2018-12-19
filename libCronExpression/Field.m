#import "Field.h"

@interface Field()
@property (nonatomic, strong) NSMutableArray<NSNumber*>* cacheArray;
@property (nonatomic, assign) BOOL canUseCache;
@end

@implementation Field

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.cacheArray = [NSMutableArray arrayWithCapacity:10];
        self.canUseCache = NO;
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
    
    return [value isEqualToString:@"*"] || [dateValue isEqualToString:value];
}

-(BOOL)isRange: (NSString*)value
{
    /*return strpos($value, '-') !== false;*/
    
    return [value rangeOfString:@"-"].location != NSNotFound;
}

-(BOOL)isIncrementsOfRanges: (NSString*)value
{
    /*return strpos($value, '/') !== false;*/
    
    return [value rangeOfString:@"/"].location != NSNotFound;
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
    
    NSArray *parts = [value componentsSeparatedByString:@"/"];
    if([[parts objectAtIndex:0] isEqualToString:@"*"] && [[parts objectAtIndex:0] intValue] != 0)
    {
        if([[parts objectAtIndex:0] rangeOfString:@"-"].location == NSNotFound)
        {
            [NSException raise:@"Invalid argument" format:@"Invalid increments of ranges value: %@", value];
        }
        else
        {
            NSArray *range = [[parts objectAtIndex:0] componentsSeparatedByString:@"-"];
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

// 由于性能问题，增加各个字段的命中缓存，但是需要在执行前，清除相关缓存
/*
   缓存处理方案：
    1.计算执行前调用resetCache防止上次的缓存影响计算结果。
    2.子类每次匹配到数值时，调用hasSatisfied，将所匹配的数值记录缓存。
    3.记录缓存数值时，判断数组中是否已经有该值存在，如果存在则表示可以使用缓存了
    4.在字段自增时，首先判断是否能够使用缓存，如果能够使用缓存，则直接增加到缓存中比当前值大的最小值上，减少非命中值的循环造成性能下降
 */
-(void)resetCache
{
    self.cacheArray = [NSMutableArray arrayWithCapacity:10];
    self.canUseCache = NO;
}

// 命中后，调用该方法将命中部分缓存
-(void)hasSatisfied:(NSNumber*)value
{
    if (_canUseCache)
    {
        return;
    }
    if ([self.cacheArray containsObject:value])
    {
        self.canUseCache = YES;
        [self.cacheArray sortUsingComparator:^NSComparisonResult(NSNumber* _Nonnull obj1, NSNumber* _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
    } else {
        [self.cacheArray addObject:value];
    }
}

// 获取下一个缓存值
-(NSNumber*)minisSatisfied:(NSNumber*)number
{
    if (_canUseCache)
    {
        __block NSNumber* biggerNumber = nil;
        [self.cacheArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj compare:number] == NSOrderedDescending)
            {
                biggerNumber = obj;
                *stop = YES;
            }
        }];
        if (biggerNumber)
            return biggerNumber;
    }
    return nil;
}

-(BOOL)canUseCache
{
    return _canUseCache;
}

@end
