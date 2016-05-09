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
	enum CronField: Int
	{
		case Minute, Hour, Day, Month, Weekday, Year
		private static let fieldCheckers: Array<FieldCheckerInterface> = [MinutesField(), HoursField(), DayOfMonthField(), MonthField(), DayOfWeekField(), YearField()]

		func getFieldChecker() -> FieldCheckerInterface
		{
			return CronField.fieldCheckers[rawValue]
		}
	}

	var cronRepresentation: CronRepresentation

	public convenience init?(cronString: String)
	{
		guard let cronRepresentation = CronRepresentation(cronString: cronString) else
		{
			return nil
		}
		self.init(cronRepresentaion: cronRepresentation)
	}

	public convenience init?(minute: String = "*", hour: String = "*", day: String = "*", month: String = "*", weekday: String = "*", year: String = "*")
	{
		let cronRepresentation = CronRepresentation(minute: minute, hour: hour, day: day, month: month, weekday: weekday, year: year)
		self.init(cronRepresentaion: cronRepresentation)
	}

	private init?(cronRepresentaion theCronRepresentation: CronRepresentation)
	{
		cronRepresentation = theCronRepresentation

		let parts = cronRepresentation.cronParts
		for i: Int in 0 ..< parts.count
		{
			let field = CronField(rawValue: i)!
			if field.getFieldChecker().validate(parts[i]) == false
			{
				NSLog("\(#function): Invalid cron field value \(parts[i]) at position \(i)")
				return nil
			}
		}
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

		// MARK: Issue 3: Instantiate enum instances with the right value
		let allFieldsInExpression: Array<CronField> = [.Minute, .Hour, .Day, .Month, .Weekday, .Year]

		// Set a hard limit to bail on an impossible date
		iteration: for _: Int in 0 ..< 1000
		{
			var satisfied = false

			currentFieldLoop: for cronField: CronField in allFieldsInExpression
			{
				// MARK: Issue 3: just call cronField.isSatisfiedBy, or getNextApplicableDate as specified in Issue 2
				let part = cronRepresentation[cronField.rawValue]
				let fieldChecker = cronField.getFieldChecker()

				if part.containsString(",") == false
				{
					satisfied = fieldChecker.isSatisfiedBy(nextRun, value: part)
				}
				else
				{
					for listPart: String in part.componentsSeparatedByString(",")
					{
						satisfied = fieldChecker.isSatisfiedBy(nextRun, value: listPart) ? true : satisfied
						continue iteration
					}
				}

				// If the field is not satisfied, then start over
				if (satisfied == false)
				{
					nextRun = fieldChecker.increment(nextRun)
					continue iteration
				}

				// Skip this match if needed
				if (timesToSkip > 0)
				{
					CronField(rawValue: 0)!.getFieldChecker().increment(nextRun)
					timesToSkip -= 1
				}
				continue currentFieldLoop
			}
			return satisfied ? nextRun : nil
		}
		NSLog("Impossible CRON expression")
		return nil
	}

	func isDue(currentTime: NSDate) -> Bool
	{
		NSLog("\(#function): Not implemented from legacy project")
		return true
	}
}