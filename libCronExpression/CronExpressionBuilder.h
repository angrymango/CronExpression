//
//  CronExpressionBuilder.h
//  RichHUD
//
//  Created by 田广文 on 2018/11/20.
//  Copyright © 2018 richfit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CronExpression.h"

@interface CronExpressionBuilder : NSObject

+ (instancetype) expressionBuiler;
+ (instancetype) expressionBuilerWithExpressionString:(NSString*)expString;

- (void)addValue:(NSNumber*)value toDomain:(NSCalendarUnit)calendarUnit;
- (void)addValues:(NSArray<NSNumber*>*)values toDomain:(NSCalendarUnit)calendarUnit;

- (NSString*)toExpressionString;
- (CronExpression*) toExpression;
- (NSMutableArray<NSNumber*>*)arrayWithUnit:(NSCalendarUnit)calendarUnit;

@end
