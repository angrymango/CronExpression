/**
 * CRON field factory implementating a flyweight factory
 *
 * @author Michael Dowling <mtdowling@gmail.com>
 * @link http://en.wikipedia.org/wiki/Cron
 */

#import <Foundation/Foundation.h>
#import "FieldInterface.h"

@interface FieldFactory : NSObject{
        
@private	
	NSMutableArray *fields;
}

/**
 * Get an instance of a field object for a cron expression position
 *
 * @param int $position CRON expression position value to retrieve
 *
 * @return FieldInterface
 * @throws InvalidArgumentException if a position is not valide
 */
-(id<FieldInterface>)getField:(NSUInteger)position;

@end
