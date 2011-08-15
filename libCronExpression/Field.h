/**
 * Abstract CRON expression field
 *
 */

#import <Foundation/Foundation.h>

@interface Field : NSObject

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

@end
