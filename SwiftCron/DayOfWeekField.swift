import Foundation

class DayOfWeekField: Field, FieldInterface
{

	func isSatisfiedBy(date: NSDate, value: String) -> Bool
	{
		var valueToSatisfy = value

		if valueToSatisfy == "?"
		{
			return true
		}

		let units: NSCalendarUnit = [.Year, .Month, .Day, .Weekday]

		valueToSatisfy = valueToSatisfy.stringByReplacingOccurrencesOfString("SUN", withString: "0")
		valueToSatisfy = valueToSatisfy.stringByReplacingOccurrencesOfString("MON", withString: "1")
		valueToSatisfy = valueToSatisfy.stringByReplacingOccurrencesOfString("TUE", withString: "2")
		valueToSatisfy = valueToSatisfy.stringByReplacingOccurrencesOfString("WED", withString: "3")
		valueToSatisfy = valueToSatisfy.stringByReplacingOccurrencesOfString("THU", withString: "4")
		valueToSatisfy = valueToSatisfy.stringByReplacingOccurrencesOfString("FRI", withString: "5")
		valueToSatisfy = valueToSatisfy.stringByReplacingOccurrencesOfString("SAT", withString: "6")

		let calendar = NSCalendar.currentCalendar()

		var lastDayOfMonth = DayOfMonthField.getLastDayOfMonth(date)

		// Find out if this is the last specific weekday of the month
		if valueToSatisfy.containsString("L")
		{
			let weekday = valueToSatisfy.substringToIndex((valueToSatisfy.rangeOfString("L")?.startIndex)!)
			let tcomponents = calendar.components(units, fromDate: date)
			tcomponents.day = lastDayOfMonth
			var tdate = calendar.dateFromComponents(tcomponents)!

			var wcomponents: NSDateComponents = calendar.components(units, fromDate: tdate)
			while wcomponents.weekday != Int(weekday) {
				lastDayOfMonth -= 1
				tcomponents.day = lastDayOfMonth
				tdate = calendar.dateFromComponents(tcomponents)!
				wcomponents = calendar.components(units, fromDate: tdate)
			}
			wcomponents = calendar.components(units, fromDate: date)
			return wcomponents.day == lastDayOfMonth
		}

		// Handle # hash tokens
		if valueToSatisfy.containsString("#")
		{
			var parts = valueToSatisfy.componentsSeparatedByString("#")
			let weekday = Int(parts[0])!
			let nth = Int(parts[1])!
			guard weekday > 1 && weekday < 5 else
			{
				NSLog("Invalid Argument: Weekday must be a value between 1 and 5. \(weekday) given")
				return false
			}

			guard nth < 5 else
			{
				NSLog("Invalid Argument. There are never more than 5 of a given weekday in a month")
				return false
			}
			var tcomponents = calendar.components(units, fromDate: date)
			// The current weekday must match the targeted weekday to proceed
			if tcomponents.weekday != weekday {
				return false
			}

			tcomponents.day = 1
			var tdate = calendar.dateFromComponents(tcomponents)!
			var dayCount = 0
			var currentDay = 1
			while currentDay < lastDayOfMonth + 1
			{
				if tcomponents.weekday == weekday
				{
					dayCount += 1
					if dayCount >= nth
					{
						break
					}
				}
				tcomponents = calendar.components(units, fromDate: tdate)
				currentDay += 1
				tcomponents.day = currentDay
				tdate = calendar.dateFromComponents(tcomponents)!
			}
			tcomponents = calendar.components(units, fromDate: date)
			return tcomponents.day == currentDay
		}

		let components = calendar.components(units, fromDate: date)
		return self.isSatisfied(String(format: "%d", components), value: value)
	}

	func increment(date: NSDate) -> NSDate
	{
		let calendar = NSCalendar.currentCalendar()
		let midnightComponents = calendar.components([.Hour, .Minute, .Second], fromDate: date)
		midnightComponents.hour = 0
		midnightComponents.minute = 0
		midnightComponents.second = 0
		let components = NSDateComponents()
		components.day = 1
		return calendar.dateByAddingComponents(components, toDate: calendar.dateFromComponents(midnightComponents)!, options: [])!
	}

	func validate(value: String) -> Bool
	{
		guard let regex = try? NSRegularExpression(pattern: "[\\*,\\/\\-0-9A-Z]+", options: .CaseInsensitive) else
		{
			NSLog("\(#function): Could not create regex")
			return false
		}

		return regex.numberOfMatchesInString(value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
