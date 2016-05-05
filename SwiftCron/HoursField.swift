#import "HoursField.h"

@implementation HoursField

	- (id) init
{
	self = [super init];
	if (self) {
		// Initialization code here.
	}

	return self;
}

	- (BOOL) isSatisfiedBy: (NSDate *) date byValue: (NSString *) value
{
	/*return $this->isSatisfied($date->format('H'), $value);*/

	NSCalendar * calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
	NSDateComponents * components = [[calendar components: NSHourCalendarUnit fromDate: date] autorelease];

	return [self isSatisfied: [NSString stringWithFormat: @"%d", components.hour] withValue: value];
}

	- (NSDate *) increment: (NSDate *) date
{
	/*$date->add(new DateInterval('PT1H'));
	 $date->setTime($date->format('H'), 0, 0);

	 return $this;*/

	NSCalendar * calendar = [[[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar] autorelease];
	NSDateComponents * components = [[[NSDateComponents alloc] init] autorelease];
	components.hour = 1;

	return [calendar dateByAddingComponents: components toDate: date options: 0];
}

	- (BOOL) validate: (NSString *) value
{
	/*return (bool) preg_match('/[\*,\/\-0-9]+/', $value);*/

	NSError * error = NULL;
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern: @"[\\*,\\/\\-0-9]+" options: NSRegularExpressionCaseInsensitive error: &error];

	if (error != NULL)
	{
		NSLog(@"%@", error);
	}

	return [regex numberOfMatchesInString: value options: 0 range: NSMakeRange(0, [value length])] > 0;
}

@end
