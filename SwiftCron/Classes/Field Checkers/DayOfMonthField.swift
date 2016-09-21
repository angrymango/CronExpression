import Foundation

class DayOfMonthField: Field, FieldCheckerInterface
{
	static func getLastDayOfMonth(_ date: Date) -> Int
	{
		let calendar = Calendar.current
		let components = (calendar as NSCalendar).components([.month], from: date)
        
		switch components.month! {
		case 1, 3, 5, 7, 8, 10, 12:
			return 31
		case 2:
			let range = (calendar as NSCalendar).range(of: .day, in: .month, for: calendar.date(from: components)!)
			return range.length
		default:
			return 30
		}
	}

	/**
	 * Get the nearest day of the week for a given day in a month
	 */
	func getNearestWeekday(currentYear: Int, currentMonth: Int, targetDay: Int) -> Date?
	{
		let calendar = Calendar.current
		var components = DateComponents()
		components.day = targetDay
		components.month = currentMonth
		components.year = currentYear

		let target = calendar.date(from: components)!

		let weekdayComponents = (calendar as NSCalendar).components([.weekday], from: target)
		if (weekdayComponents.weekday! < 6)
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
				let adjustedTarget = calendar.date(from: components)!
				let adjustedWeekdayComponents = (calendar as NSCalendar).components([.weekday, .month], from: adjustedTarget)
				if (adjustedWeekdayComponents.weekday! < 6 && adjustedWeekdayComponents.month! == currentMonth)
				{
					return adjustedTarget
				}
			}
		}

		return nil
	}

	func isSatisfiedBy(_ date: Date, value: String) -> Bool
	{
		if value == "?"
		{
			return true
		}

		let calendar = Calendar.current
		let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)

		if (value == "L")
		{
			return components.day == DayOfMonthField.getLastDayOfMonth(date)
		}

		if (value.contains("W"))
		{
			let range: Range<String.Index> = value.range(of: "W")!

			let targetDay = value.substring(with: Range<String.Index>(value.startIndex ..< range.lowerBound))
			let dayAsInt = Int(targetDay)!
			if let nearestWeekday = getNearestWeekday(currentYear: components.year!, currentMonth: components.month!, targetDay: dayAsInt)
			{
				let nearestWeekdayComponents = (calendar as NSCalendar).components([.day, .month, .year], from: nearestWeekday)
				return components.day == nearestWeekdayComponents.day
			}
			else
			{
				return false
			}
		}
        
        guard let day = components.day else {
            return false
        }
        
		return self.isSatisfied(String(day), value: value)
	}

	func increment(_ date: Date, toMatchValue: String) -> Date
	{
		if let nextDate = date.nextDate(matchingUnit: .day, value: toMatchValue)
		{
			return nextDate
		}

		let calendar = Calendar.current
		var midnightComponents = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .weekday], from: date)
		midnightComponents.hour = 0
		midnightComponents.minute = 0
		midnightComponents.second = 0

		var components = DateComponents()
		components.day = 1;
		return (calendar as NSCalendar).date(byAdding: components, to: calendar.date(from: midnightComponents)!, options: [])!
	}

	func validate(_ value: String) -> Bool
	{
		guard let regex = try? NSRegularExpression(pattern: "[\\*,\\/\\-\\?LW0-9A-Za-z]+", options: .caseInsensitive) else
		{
			NSLog("\(#function): Couldn't create regex.")
			return false
		}

		return regex.numberOfMatches(in: value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
