import Foundation

class DayOfWeekField: Field, FieldCheckerInterface
{
	static let currentCalendarWithMondayAsFirstDay: Calendar = {
		var calendar = Calendar.current
		calendar.firstWeekday = 2
		return calendar
	}()

	func isSatisfiedBy(_ date: Date, value: String) -> Bool
	{
		let valueToSatisfy = value
        let units: NSCalendar.Unit = [.year, .month, .day, .weekday]

		let calendar = DayOfWeekField.currentCalendarWithMondayAsFirstDay
		var weekdayWithMondayAsFirstDay = (calendar as NSCalendar).ordinality(of: .weekday, in: .weekOfYear, for: date)

		let isLastWeekdayOfMonth = valueToSatisfy.contains("L")
		if isLastWeekdayOfMonth
		{
			var lastDayOfMonth = DayOfMonthField.getLastDayOfMonth(date)
			let weekday = valueToSatisfy.substring(to: (valueToSatisfy.range(of: "L")?.lowerBound)!)
			var tcomponents = (calendar as NSCalendar).components(units, from: date)
			tcomponents.day = lastDayOfMonth
			var tdate = calendar.date(from: tcomponents)!
			var tcomponentsWeekdayWithMondayFirst = (calendar as NSCalendar).ordinality(of: .weekday, in: .weekOfYear, for: tdate)

			while tcomponentsWeekdayWithMondayFirst != Int(weekday) {
				lastDayOfMonth -= 1
				tcomponents.day = lastDayOfMonth
				tdate = calendar.date(from: tcomponents)!
				tcomponentsWeekdayWithMondayFirst = (calendar as NSCalendar).ordinality(of: .weekday, in: .weekOfYear, for: tdate)
			}
			let componentsToMatch = (calendar as NSCalendar).components(units, from: date)
			return componentsToMatch.day == lastDayOfMonth
		}

		// Handle # hash tokens
		if valueToSatisfy.contains("#")
		{
			let lastDayOfMonth = DayOfMonthField.getLastDayOfMonth(date)
			var parts = valueToSatisfy.components(separatedBy: "#")
			let weekday = Int(parts[0])!
			let nth = Int(parts[1])!

			guard nth < 5 else
			{
				NSLog("Invalid Argument. There are never more than 5 of a given weekday in a month")
				return false
			}
			var tcomponents = (calendar as NSCalendar).components(units, from: date)
			// The current weekday must match the targeted weekday to proceed
			if weekdayWithMondayAsFirstDay != weekday
			{
				return false
			}

			tcomponents.day = 1
			var tdate = calendar.date(from: tcomponents)!
			var dayCount = 0
			var currentDay = 1
			while currentDay < lastDayOfMonth + 1
			{
				let ordinalWeekday = (calendar as NSCalendar).ordinality(of: .weekday, in: .weekOfYear, for: tdate)
				if ordinalWeekday == weekday
				{
					dayCount += 1
					if dayCount >= nth
					{
						break
					}
				}
				tcomponents = (calendar as NSCalendar).components(units, from: tdate)
				currentDay += 1
				tcomponents.day = currentDay
				tdate = calendar.date(from: tcomponents)!
			}
			tcomponents = (calendar as NSCalendar).components(units, from: date)
			return tcomponents.day == currentDay
		}

		if Int(valueToSatisfy) == 0
		{
			weekdayWithMondayAsFirstDay = 0
		}

		return self.isSatisfied(String(format: "%d", weekdayWithMondayAsFirstDay), value: valueToSatisfy)
	}

	private func isSunday(_ components: DateComponents) -> Bool
	{
		return components.weekday == 1
	}

	func increment(_ date: Date, toMatchValue: String) -> Date
	{
		let calendar = Calendar.current

		// TODO issue 13: handle list items
		if let toMatchInt = Int(toMatchValue)
		{
			let converted = Date.convertWeekdayWithMondayFirstToSundayFirst(toMatchInt)
			if let nextDate = date.nextDate(matchingUnit: .weekday, value: String(converted))
			{
				return nextDate
			}
		}

		let midnightComponents = (calendar as NSCalendar).components([.day, .month, .year], from: date)
		var components = DateComponents()
		components.day = 1
		return (calendar as NSCalendar).date(byAdding: components, to: calendar.date(from: midnightComponents)!, options: [])!
	}

	func validate(_ value: String) -> Bool
	{
		guard let regex = try? NSRegularExpression(pattern: "[\\*,\\/\\-0-9A-Z]+", options: .caseInsensitive) else
		{
			NSLog("\(#function): Could not create regex")
			return false
		}

		return regex.numberOfMatches(in: value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
