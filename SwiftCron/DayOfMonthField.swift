import Foundation

class DayOfMonthField: Field, FieldInterface
{

	static func getLastDayOfMonth(date: NSDate) -> Int
	{
		let calendar = NSCalendar.currentCalendar()
		let monthUnit = calendar.components([.Month], fromDate: date)
		let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: calendar.dateFromComponents(monthUnit)!)
		return range.length;
	}

	/**
	 * Get the nearest day of the week for a given day in a month
	 */
	func getNearestWeekday(currentYear currentYear: Int, currentMonth: Int, targetDay: Int) -> NSDate?
	{
		let calendar = NSCalendar.currentCalendar()
		let components = NSDateComponents()
		components.day = targetDay
		components.month = currentMonth
		components.year = currentYear

		let target = calendar.dateFromComponents(components)!

		let weekdayComponents = calendar.components([.Weekday], fromDate: target)
		if (weekdayComponents.weekday < 6)
		{
			return target
		}

		let lastDayOfMonth = DayOfMonthField.getLastDayOfMonth(target)
		let adjustments = [-1, 1, -2, 2]

		for adjustment in adjustments
		{
			let adjusted = targetDay + adjustment

			if adjusted > 0 && adjusted <= lastDayOfMonth
			{
				components.day = adjusted
				let adjustedTarget = calendar.dateFromComponents(components)!
				let adjustedWeekdayComponents = calendar.components([.Weekday, .Month], fromDate: adjustedTarget)
				if (adjustedWeekdayComponents.weekday < 6 && adjustedWeekdayComponents.month == currentMonth)
				{
					return adjustedTarget
				}
			}
		}

		return nil
	}

	func isSatisfiedBy(date: NSDate, value: String) -> Bool
	{
		if value == "?"
		{
			return true
		}

		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components([.Day, .Month, .Year], fromDate: date)

		if (value == "L")
		{
			return components.day == DayOfMonthField.getLastDayOfMonth(date)
		}

		if (value.containsString("W"))
		{
			let range: Range<String.Index> = value.rangeOfString("W")!

			let targetDay = value.substringWithRange(Range<String.Index>(value.startIndex ..< range.startIndex))
			let dayAsInt = Int(targetDay)!
			if let nearestWeekday = getNearestWeekday(currentYear: components.year, currentMonth: components.month, targetDay: dayAsInt)
			{
				let nearestWeekdayComponents = calendar.components([.Day, .Month, .Year], fromDate: nearestWeekday)
				return components.day == nearestWeekdayComponents.day
			}
			else
			{
				return false
			}
		}
		return self.isSatisfied(String(format: "%02d", components.day), value: value)
	}

	func increment(date: NSDate) -> NSDate
	{
		let calendar = NSCalendar.currentCalendar()
		let midnightComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Weekday], fromDate: date)
		midnightComponents.hour = 0
		midnightComponents.minute = 0
		midnightComponents.second = 0

		let components = NSDateComponents()
		components.day = 1;

		return calendar.dateByAddingComponents(components, toDate: calendar.dateFromComponents(midnightComponents)!, options: [])!
	}

	func validate(value: String) -> Bool
	{
		guard let regex = try? NSRegularExpression(pattern: "[\\*,\\/\\-\\?LW0-9A-Za-z]+", options: .CaseInsensitive) else
		{
			NSLog("\(#function): Couldn't create regex.")
			return false
		}

		return regex.numberOfMatchesInString(value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}