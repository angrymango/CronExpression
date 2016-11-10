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

	func isSatisfiedBy(_ date: Date, value: String) -> Bool
	{
		let calendar = Calendar.current
		let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)

		if (value == "L")
		{
			return components.day == DayOfMonthField.getLastDayOfMonth(date)
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
