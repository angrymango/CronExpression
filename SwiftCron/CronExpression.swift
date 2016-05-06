import Foundation
/*
 * * * * *
 | | | | |
 | | | | ---- Weekday
 | | | ------ Month
 | | -------- Day
 | ---------- Hour
 ------------ Minute

 * * * * * *
 | | | | | |
 | | | | | ---- Year
 | | | | ------ Weekday
 | | | -------- Month
 | | ---------- Day
 | ------------ Hour
 -------------- Minute
 */
public class CronExpression
{
	enum CronPart: Int
	{
		case Minute, Hour, Day, Month, Weekday, Year
		private static let fields: Array<FieldInterface> = [MinutesField(), HoursField(), DayOfMonthField(), MonthField(), DayOfWeekField(), YearField()]

		func getField() -> FieldInterface
		{
			return CronPart.fields[rawValue]
		}
	}

	var cronParts: Array<String>

	init?(schedule: String)
	{
		cronParts = schedule.componentsSeparatedByString(" ")

		if cronParts.count < 5
		{
			NSLog("\(#function): \(schedule) is not a valid cron expression")
			return nil
		}

		for i: Int in 0 ..< cronParts.count
		{
			let part = CronPart(rawValue: i)!
			if part.getField().validate(cronParts[i]) == false
			{
				NSLog("\(#function): Invalid cron field value \(cronParts[i]) at position \(i)")
				return nil
			}
		}
	}

	public static func expressionWithString(expression: String) -> CronExpression?
	{
		var cronExpressionString = expression

		let mappings = ["yearly": "0 0 1 1 *", "annually": "0 0 1 1 *", "monthly": "0 0 1 * *", "weekly": "0 0 * * 0", "daily": "0 0 * * *", "hourly": "0 * * * *"]

		if let mappedExpression = mappings[cronExpressionString]
		{
			cronExpressionString = mappedExpression
		}

		return CronExpression(schedule: cronExpressionString)
	}

	// MARK: - Get Next Run Date

	public func getNextRunDateFromNow() -> NSDate?
	{
		return getNextRunDate(NSDate())
	}

	public func getNextRunDate(date: NSDate) -> NSDate?
	{
		return getNextRunDate(date, skip: 0)
	}

	func getNextRunDate(date: NSDate, skip: Int) -> NSDate?
	{
		var timesToSkip = skip
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Weekday], fromDate: date)
		components.second = 0
		guard var nextRun = calendar.dateFromComponents(components) else
		{
			NSLog("\(#function): could not get a date from components \(components)")
			return nil
		}

		let allPartsInExpression: Array<CronPart> = [.Minute, .Hour, .Day, .Month, .Weekday, .Year]

		// Set a hard limit to bail on an impossible date
		iteration: for _: Int in 0 ..< 1000
		{
			var satisfied = false

			currentFieldLoop: for cronPart: CronPart in allPartsInExpression
			{
				let part = getExpression(cronPart.rawValue)!
				let field = cronPart.getField()

				if part.containsString(",") == false
				{
					satisfied = field.isSatisfiedBy(nextRun, value: part)
				}
				else
				{
					for listPart: String in part.componentsSeparatedByString(",")
					{
						satisfied = field.isSatisfiedBy(nextRun, value: listPart) ? true : satisfied
						continue iteration
					}
				}

				// If the field is not satisfied, then start over
				if (satisfied == false)
				{
					nextRun = field.increment(nextRun)
					continue iteration
				}

				// Skip this match if needed
				if (timesToSkip > 0)
				{
					CronPart(rawValue: 0)!.getField().increment(nextRun)
					timesToSkip -= 1
				}
				continue currentFieldLoop
			}
			return satisfied ? nextRun : nil
		}
		NSLog("Impossible CRON expression")
		return nil
	}

	public func getExpression(part: Int) -> String?
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

	public func isDue(currentTime: NSDate) -> Bool
	{
		NSLog("\(#function): Not implemented from legacy project")
		return true
	}
}