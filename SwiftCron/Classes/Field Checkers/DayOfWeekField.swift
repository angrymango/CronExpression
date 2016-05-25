import Foundation

class DayOfWeekField: Field, FieldCheckerInterface
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
		calendar.firstWeekday = 2
		var weekdayWithMondayAsFirstDay = calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfYear, forDate: date)

		var lastDayOfMonth = DayOfMonthField.getLastDayOfMonth(date)

		// Find out if this is the last specific weekday of the month
		if valueToSatisfy.containsString("L")
		{
			let weekday = valueToSatisfy.substringToIndex((valueToSatisfy.rangeOfString("L")?.startIndex)!)
			let tcomponents = calendar.components(units, fromDate: date)
			tcomponents.day = lastDayOfMonth
			var tdate = calendar.dateFromComponents(tcomponents)!
			var tcomponentsWeekdayWithMondayFirst = calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfYear, forDate: tdate)

			while tcomponentsWeekdayWithMondayFirst != Int(weekday) {
				lastDayOfMonth -= 1
				tcomponents.day = lastDayOfMonth
				tdate = calendar.dateFromComponents(tcomponents)!
				tcomponentsWeekdayWithMondayFirst = calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfYear, forDate: tdate)
			}
			let componentsToMatch = calendar.components(units, fromDate: date)
			return componentsToMatch.day == lastDayOfMonth
		}

		// Handle # hash tokens
		if valueToSatisfy.containsString("#")
		{
			var parts = valueToSatisfy.componentsSeparatedByString("#")
			let weekday = Int(parts[0])!
			let nth = Int(parts[1])!

			guard nth < 5 else
			{
				NSLog("Invalid Argument. There are never more than 5 of a given weekday in a month")
				return false
			}
			var tcomponents = calendar.components(units, fromDate: date)
			// The current weekday must match the targeted weekday to proceed
			if weekdayWithMondayAsFirstDay != weekday
			{
				return false
			}

			tcomponents.day = 1
			var tdate = calendar.dateFromComponents(tcomponents)!
			var dayCount = 0
			var currentDay = 1
			while currentDay < lastDayOfMonth + 1
			{
				let ordinalWeekday = calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfYear, forDate: tdate)
				if ordinalWeekday == weekday
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

		if Int(valueToSatisfy) == 0
		{
			weekdayWithMondayAsFirstDay = 0
		}

		return self.isSatisfied(String(format: "%d", weekdayWithMondayAsFirstDay), value: valueToSatisfy)
	}

	private func isSunday(components: NSDateComponents) -> Bool
	{
		return components.weekday == 1
	}

	func increment(date: NSDate, toMatchValue: String) -> NSDate
	{
		let calendar = NSCalendar.currentCalendar()

		// TODO issue 13: handle list items
		if let toMatchInt = Int(toMatchValue)
		{
			let converted = NSDate.convertWeekdayWithMondayFirstToSundayFirst(toMatchInt)
			if let nextDate = date.nextDate(matchingUnit: .Weekday, value: String(converted))
			{
				return nextDate
			}
		}

		let midnightComponents = calendar.components([.Day, .Month, .Year], fromDate: date)
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
