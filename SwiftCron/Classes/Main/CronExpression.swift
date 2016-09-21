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

	var cronRepresentation: CronRepresentation

	public convenience init?(cronString: String)
	{
		guard let cronRepresentation = CronRepresentation(cronString: cronString) else
		{
			return nil
		}
		self.init(cronRepresentaion: cronRepresentation)
	}

	public convenience init?(minute: CronFieldTranslatable = "*", hour: CronFieldTranslatable = "*", day: CronFieldTranslatable = "*", month: CronFieldTranslatable = "*", weekday: CronFieldTranslatable = "*", year: CronFieldTranslatable = "*")
	{
		let cronRepresentation = CronRepresentation(minute: minute.cronFieldRepresentation, hour: hour.cronFieldRepresentation, day: day.cronFieldRepresentation, month: month.cronFieldRepresentation, weekday: weekday.cronFieldRepresentation, year: year.cronFieldRepresentation)
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

	public var stringRepresentation: String
	{
		return cronRepresentation.cronString
	}

	// MARK: - Description

	public var shortDescription: String
	{
		return CronDescriptionBuilder.buildDescription(cronRepresentation, length: .short)
	}

	public var longDescription: String
	{
		return CronDescriptionBuilder.buildDescription(cronRepresentation, length: .long)
	}

	// MARK: - Get Next Run Date

	public func getNextRunDateFromNow() -> Date?
	{
		return getNextRunDate(Date())
	}

	public func getNextRunDate(_ date: Date) -> Date?
	{
		return getNextRunDate(date, skip: 0)
	}

	func getNextRunDate(_ date: Date, skip: Int) -> Date?
	{
		guard matchIsTheoreticallyPossible(date) else
		{
			return nil
		}

		var timesToSkip = skip
		let calendar = Calendar.current
		var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .weekday], from: date)
		components.second = 0
		guard var nextRun = calendar.date(from: components) else
		{
			NSLog("\(#function): could not get a date from components \(components)")
			return nil
		}

		// MARK: Issue 3: Instantiate enum instances with the right value
		let allFieldsInExpression: Array<CronField> = [.minute, .hour, .day, .month, .weekday, .year]

		// Set a hard limit to bail on an impossible date
		iteration: for _: Int in 0 ..< 1000
		{
			var satisfied = false

			currentFieldLoop: for cronField: CronField in allFieldsInExpression
			{
				// MARK: Issue 3: just call cronField.isSatisfiedBy, or getNextApplicableDate as specified in Issue 2
				let part = cronRepresentation[cronField.rawValue]
				let fieldChecker = cronField.getFieldChecker()

				if part.contains(",") == false
				{
					satisfied = fieldChecker.isSatisfiedBy(nextRun, value: part)
				}
				else
				{
					for listPart: String in part.components(separatedBy: ",")
					{
						satisfied = fieldChecker.isSatisfiedBy(nextRun, value: listPart)
						if satisfied
						{
							break
						}
					}
				}

				// If the field is not satisfied, then start over
				if (satisfied == false)
				{
					nextRun = fieldChecker.increment(nextRun, toMatchValue: part)
					continue iteration
				}

				// Skip this match if needed
				if (timesToSkip > 0)
				{
					let _ = CronField(rawValue: 0)!.getFieldChecker().increment(nextRun, toMatchValue: part)
					timesToSkip -= 1
				}
				continue currentFieldLoop
			}
			return satisfied ? nextRun : nil
		}
		return nil
	}

	private func matchIsTheoreticallyPossible(_ date: Date) -> Bool
	{
		// TODO: Handle lists and steps
		guard let year = Int(cronRepresentation.year) else
		{
			return true
		}

		var components = DateComponents()
		components.year = year
		if let month = Int(cronRepresentation.month)
		{
			components.month = month
		}
		if let day = Int(cronRepresentation.day)
		{
			components.day = day
		}
		if let dateFromComponents = Calendar.current.date(from: components)
		{
			return date.compare(dateFromComponents) == .orderedAscending
		}
		return true
	}

	func isDue(_ currentTime: Date) -> Bool
	{
		NSLog("\(#function): Not implemented from legacy project")
		return true
	}
}
