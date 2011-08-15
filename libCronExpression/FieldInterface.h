/**
 * CRON field interface
 *
 */

#ifndef Vision_FieldInterface_h
#define Vision_FieldInterface_h

@protocol FieldInterface<NSObject>
    
/**
 * Check if the respective value of a DateTime field satisfies a CRON exp
 *
 * @param DateTime date DateTime object to check
 * @param string value CRON expression to test against
 *
 * @return bool Returns TRUE if satisfied, FALSE otherwise
 */
-(BOOL)isSatisfiedBy: (NSDate*)date byValue:(NSString*)value;

/**
 * When a CRON expression is not satisfied, this method is used to increment
 * a DateTime object by the unit of the cron field
 *
 * @param DateTime date DateTime object to increment
 *
 * @return FieldInterface
 */
-(NSDate*) increment:(NSDate*)date;

/**
 * Validates a CRON expression for a given field
 *
 * @param string $value CRON expression value to validate
 *
 * @return bool Returns TRUE if valid, FALSE otherwise
 */
-(BOOL) validate:(NSString*)value;

@end

#endif
