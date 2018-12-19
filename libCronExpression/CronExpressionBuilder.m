//
//  CronExpressionBuilder.m
//  RichHUD
//
//  Created by 田广文 on 2018/11/20.
//  Copyright © 2018 richfit. All rights reserved.
//

#import "CronExpressionBuilder.h"

const int PROPERTY_LENGTH = 7;

@interface CronExpressionBuilder()
@property (nonatomic, strong) NSMutableArray<NSNumber*>* seconds;
@property (nonatomic, strong) NSMutableArray<NSNumber*>* minutes;
@property (nonatomic, strong) NSMutableArray<NSNumber*>* hours;
@property (nonatomic, strong) NSMutableArray<NSNumber*>* daysOfMonth;
@property (nonatomic, strong) NSMutableArray<NSNumber*>* months;
@property (nonatomic, strong) NSMutableArray<NSNumber*>* daysOfWeek;
@property (nonatomic, strong) NSMutableArray<NSNumber*>* years;
@end

@implementation CronExpressionBuilder

+ (instancetype) expressionBuiler
{
    return [[CronExpressionBuilder alloc] init];
}

+ (instancetype) expressionBuilerWithExpressionString:(NSString*)expString
{
    return [[CronExpressionBuilder alloc] initWithExpression:expString];
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.seconds = [NSMutableArray arrayWithCapacity:5];
        self.minutes = [NSMutableArray arrayWithCapacity:5];
        self.hours = [NSMutableArray arrayWithCapacity:5];
        self.daysOfMonth = [NSMutableArray arrayWithCapacity:5];
        self.months = [NSMutableArray arrayWithCapacity:5];
        self.daysOfWeek = [NSMutableArray arrayWithCapacity:5];
        self.years = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

- (instancetype) initWithExpression:(NSString*)expString
{
    self = [self init];
    if (self)
    {
        NSArray<NSString *>* components = [expString componentsSeparatedByString:@" "];
        NSInteger maxSize = components.count;
        if (components.count > PROPERTY_LENGTH)
        {
            maxSize = PROPERTY_LENGTH;
        }
        for (NSInteger i = 0; i < maxSize; i++)
        {
            if ([@"*" isEqualToString:components[i]] || [@"?" isEqualToString:components[i]])
            {
                continue;
            }
            NSMutableArray* values = [self arrayAtIndex:i];
            
            // FIXME: 数组对象错误
            NSArray<NSString *>* singleValues = [components[i] componentsSeparatedByString:@","];
            [singleValues enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber* number = [NSNumber numberWithInteger:[obj integerValue]];
                [values addObject:number];
            }];
        }
    }
    return self;
}

- (NSMutableArray<NSNumber*>*)arrayAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return self.seconds;
            break;
        case 1:
            return self.minutes;
            break;
        case 2:
            return self.hours;
            break;
        case 3:
            return self.daysOfMonth;
            break;
        case 4:
            return self.months;
            break;
        case 5:
            return self.daysOfWeek;
            break;
        case 6:
            return self.years;
            break;
        default:
            return nil;
            break;
    }
}

- (NSMutableArray<NSNumber*>*)arrayWithUnit:(NSCalendarUnit)calendarUnit
{
    switch (calendarUnit) {
        case NSCalendarUnitSecond:
            return self.seconds;
            break;
        case NSCalendarUnitMinute:
            return self.minutes;
            break;
        case NSCalendarUnitHour:
            return self.hours;
            break;
        case NSCalendarUnitDay:
            return self.daysOfMonth;
            break;
        case NSCalendarUnitMonth:
            return self.months;
            break;
        case NSCalendarUnitWeekday:
            return self.daysOfWeek;
            break;
        case NSCalendarUnitYear:
            return self.years;
            break;
        default:
            return nil;
            break;
    }
}

- (void)addValue:(NSNumber*)value toDomain:(NSCalendarUnit)calendarUnit
{
    [[self arrayWithUnit:calendarUnit] addObject:value];
}

- (void)addValues:(NSArray<NSNumber*>*)values toDomain:(NSCalendarUnit)calendarUnit
{
    [[self arrayWithUnit:calendarUnit] addObjectsFromArray:values];
}

- (NSString*)toExpressionString
{
    NSMutableString* result = [NSMutableString stringWithString:@""];
    for (int i = 0; i < PROPERTY_LENGTH; i++)
    {
        NSString* defaultString = (i == PROPERTY_LENGTH - 2)?@"?":@"*";
        [result appendString:[self arrayToExpressionString:[self arrayAtIndex:i] defaultString:defaultString]];
        if (i < PROPERTY_LENGTH - 1)
        {
            [result appendString:@" "];
        }
    }
    return [result copy];
}

- (NSString*)arrayToExpressionString:(NSMutableArray<NSNumber*>*)array defaultString:(NSString*)defaultString
{
    if (array.count == 0)
        return defaultString;
    NSMutableString* result = [[NSMutableString alloc] initWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result appendString:[NSString stringWithFormat:@"%ld", [obj integerValue]]];
        if (idx < array.count - 1)
        {
            [result appendString:@","];
        }
    }];
    return [result copy];
}

- (CronExpression*) toExpression
{
    return [CronExpression expression:[self toExpressionString] factory:nil];
}

@end
