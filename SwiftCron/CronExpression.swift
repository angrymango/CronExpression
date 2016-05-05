import Foundation

class CronExpression
{

	let MINUTE = 0
	let HOUR = 1
	let DAY = 2
	let MONTH = 3
	let WEEKDAY = 4
	let YEAR = 5

	var cronParts: Array<String>

	var _fieldFactory: FieldFactory

	var order: Array<NSNumber>

	init?(schedule: String, fieldFactory: FieldFactory)
	{
		order = [NSNumber(integer: YEAR), NSNumber(integer: MONTH), NSNumber(integer: DAY), NSNumber(integer: WEEKDAY), NSNumber(integer: HOUR), NSNumber(integer: MINUTE)]
		_fieldFactory = fieldFactory

		cronParts = schedule.componentsSeparatedByString(" ")

		if cronParts.count < 5
		{
			NSLog("\(#function): \(schedule) is not a valid cron expression")
			return nil
		}

		for i: Int in 0 ..< cronParts.count
		{
			if _fieldFactory.getField(i)?.validate(cronParts[i]) == false
			{
				NSLog("\(#function): Invalid cron field value \(cronParts[i]) at position \(i)")
				return nil
			}
		}
	}

	static func expressionWithString(expression: String, andFactory fieldFactory: FieldFactory) -> CronExpression?
	{
		var cronExpressionString = expression

		let mappings = ["yearly": "0 0 1 1 *", "annually": "0 0 1 1 *", "monthly": "0 0 1 * *", "weekly": "0 0 * * 0", "daily": "0 0 * * *", "hourly": "0 * * * *"]

		if let mappedExpression = mappings[cronExpressionString]
		{
			cronExpressionString = mappedExpression
		}

		return CronExpression(schedule: cronExpressionString, fieldFactory: fieldFactory)
	}

	func getNextRunDate(date: NSDate, skip: Int) -> NSDate?
	{
		var timesToSkip = skip
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Weekday], fromDate: date)
		components.second = 0
		guard let nextRun = calendar.dateFromComponents(components) else
        {
            NSLog("\(#function): could not get a date from components \(components)")
            return nil
        }

		// Set a hard limit to bail on an impossible date
        for _: Int in 0 ..< 1000
		{
			for position: NSNumber in order
			{
				let part: String = getExpression(position.integerValue)!
				var satisfied = false
				let field: FieldInterface = _fieldFactory.getField(position.integerValue)!

				if part.containsString(",") == false
				{
					satisfied = field.isSatisfiedBy(nextRun, value: part)
				}
				else
				{
					for listPart: String in part.componentsSeparatedByString(",")
					{
						satisfied = field.isSatisfiedBy(nextRun, value: listPart) ? true : satisfied
						break
					}
				}

				// If the field is not satisfied, then start over
				if (satisfied == false)
				{
					field.increment(nextRun)
					break
				}

				// Skip this match if needed
				if (timesToSkip > 0)
				{
					_fieldFactory.getField(0)!.increment(nextRun)
					timesToSkip -= 1
					continue
				}
				return nextRun;
			}
		}
		NSLog("Impossible CRON expression")
		return nil
	}

	func getExpression(part: Int) -> String?
	{
		if part < 0
		{
			return cronParts.joinWithSeparator(" ")
		}
		else if part < cronParts.count
		{
			return cronParts[part]
		}

		return nil
	}

	func isDue(currentTime: NSDate) -> Bool
	{
		NSLog("\(#function): Not implemented from legacy project")
		return true
	}
}