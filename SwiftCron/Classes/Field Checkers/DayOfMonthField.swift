import Foundation

class DayOfMonthField: Field, FieldCheckerInterface
{
	func isSatisfiedBy(_ date: Date, value: String) -> Bool {
		let calendar = Calendar.current
		let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)

		if (value == "L") {
			return components.day == date.getLastDayOfMonth()
		}
        
        let day = components.day!
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
		components.day = 1
		return (calendar as NSCalendar).date(byAdding: components, to: calendar.date(from: midnightComponents)!, options: [])!
	}

	func validate(_ value: String) -> Bool
	{
		let regex = try! NSRegularExpression(pattern: "[\\*,\\/\\-\\?LW0-9A-Za-z]+", options: .caseInsensitive)

		return regex.numberOfMatches(in: value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
