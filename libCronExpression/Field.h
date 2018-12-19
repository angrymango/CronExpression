/**
 * Abstract CRON expression field
 *
 */

#import <Foundation/Foundation.h>

@interface Field : NSObject

@property (nonatomic, strong, readwrite) NSCalendar* calendar;

/**
 * Check to see if a field is satisfied by a value
 *
 * @param string dateValue Date value to check
 * @param string value Value to test
 *
 * @return bool
 */
-(BOOL)isSatisfied: (NSString*)dateValue withValue:(NSString*)value;

/**
 * Check if a value is a range
 *
 * @param string value Value to test
 *
 * @return bool
 */
-(BOOL)isRange: (NSString*)value;

/**
 * Check if a value is an increments of ranges
 *
 * @param string value Value to test
 *
 * @return bool
 */
-(BOOL)isIncrementsOfRanges: (NSString*)value;

/**
 * Test if a value is within a range
 *
 * @param string dateValue Set date value
 * @param string value Value to test
 *
 * @return bool
 */
-(BOOL)isInRange: (NSString*)dateValue withValue:(NSString*)value;

/**
 * Test if a value is within an increments of ranges
 *
 * @param string dateValue Set date value
 * @param string value Value to test
 *
 * @return bool
 */
-(BOOL)isInIncrementsOfRanges: (NSString*)dateValue withValue:(NSString*)value;

// 由于性能问题，增加各个字段的命中缓存，但是需要在执行前，清除相关缓存
-(void)resetCache;
// 命中后，调用该方法将命中部分缓存
-(void)hasSatisfied:(NSNumber*)value;
// 返回缓存中下一个命中值
-(NSNumber*)minisSatisfied:(NSNumber*)number;
// 返回是否可以使用缓存
-(BOOL)canUseCache;

@end
