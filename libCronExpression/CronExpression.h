/**
 * CRON expression parser that can determine whether or not a CRON expression is
 * due to run and the next run date of a cron schedule.  The determinations made
 * by this class are accurate if checked run once per minute.
 *
 * Schedule parts must map to:
 * minute [0-59], hour [0-23], day of month, month [1-12|JAN-DEC], day of week
 * [1-7|MON-SUN], and an optional year.
 *
 * @author Michael Dowling <mtdowling@gmail.com>
 * @link http://en.wikipedia.org/wiki/Cron
 */

#import <Foundation/Foundation.h>
#import "FieldFactory.h"

@interface CronExpression : NSObject{
    /**
     * @var array CRON expression parts
     */
    NSArray* cronParts;
    
    /**
     * @var FieldFactory CRON field factory
     */
    FieldFactory* _fieldFactory;
    
    /**
     * @var array Order in which to test of cron parts
     */
    NSArray* order;
}

extern int const MINUTE;
extern int const HOUR;
extern int const DAY;
extern int const MONTH;
extern int const WEEKDAY;
extern int const YEAR;

/**
 * Factory method to create a new CronExpression.
 *
 * @param string expression The CRON expression to create.  There are
 *      several special predefined values which can be used to substitute the
 *      CRON expression:
 *
 *      @yearly, @annually) - Run once a year, midnight, Jan. 1 - 0 0 1 1 *
 *      @monthly - Run once a month, midnight, first of month - 0 0 1 * *
 *      @weekly - Run once a week, midnight on Sun - 0 0 * * 0
 *      @daily - Run once a day, midnight - 0 0 * * *
 *      @hourly - Run once an hour, first minute - 0 * * * *
 * @param FieldFactory fieldFactory (optional) Field factory to use with
 *      the expression.  Leave NULL to use the default factory.
 *
 * @return CronExpression
 */
+(CronExpression*) factory:(NSString*)$expression: (FieldFactory*) fieldFactory;

/**
 * Parse a CRON expression
 *
 * @param string schedule CRON expression schedule string (e.g. '8 * * * *')
 * @param FieldFactory fieldFactory Factory to create cron fields
 *
 * @throws InvalidArgumentException if not a valid CRON expression
 */
-(id)init:(NSString*)schedule withFieldFactory:(FieldFactory*) fieldFactory;

/**
 * Get the date in which the CRON will run next
 *
 * @param string currentTime (optional) Optionally set the current date
 *     time for testing purposes or disregarding the current second
 * @param int nth (optional) The number of matches to skip before returning
 *     a matching next run date.  0, the default, will return the current
 *     date and time if the next run date falls on the current date and
 *     time.  Setting this value to 1 will skip the first match and go to
 *     the second match.  Setting this value to 2 will skip the first 2
 *     matches and so on.
 *
 * @return DateTime
 */
-(NSDate*)getNextRunDate: (NSDate*)currentTime: (NSInteger)nth;

/**
 * Get all or part of the CRON expression
 *
 * @param string $part (optional) Specify the part to retrieve or NULL to
 *      get the full cron schedule string.
 *
 * @return string|null Returns the CRON expression, a part of the
 *      CRON expression, or NULL if the part was specified but not found
 */
-(NSString*)getExpression: (int)part;

/**
 * Deterime if the cron is due to run based on the current time.  Unless
 * a string is passed, this method assumes that the current number of
 * seconds are irrelevant, and that this method will be called once per
 * minute.
 *
 * @param string|DateTime $currentTime (optional) Set the current time
 *      If left NULL, the current time is used, less seconds
 *      If a DateTime object is passed, the DateTime is used less seconds
 *      If a string is used, the exact strotime of the string is used
 *
 * @return bool Returns TRUE if the cron is due to run or FALSE if not
 */
-(BOOL)isDue: (NSDate*)currentTime;

@end
