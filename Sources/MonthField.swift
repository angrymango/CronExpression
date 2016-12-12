import Foundation

class MonthField: Field, FieldCheckerInterface
{

	func isSatisfiedBy(_ date: Date, value: String) -> Bool
	{
		let calendar = Calendar.current
		let month = (calendar as NSCalendar).component(.month, from: date)
		return isSatisfied(String(month), value: value)
	}

	func increment(_ date: Date, toMatchValue: String) -> Date
	{
		if let nextDate = date.nextDate(matchingUnit: .month, value: toMatchValue)
		{
			return nextDate
		}

		let calendar = Calendar.current
		let midnightComponents = (calendar as NSCalendar).components([.day, .month, .year], from: date)

		var components = DateComponents()
		components.month = 1;

		return (calendar as NSCalendar).date(byAdding: components, to: calendar.date(from: midnightComponents)!, options: [])!
	}

	func validate(_ value: String) -> Bool
	{
        let regex = try! NSRegularExpression(pattern: "[\\*,\\/\\-0-9A-Z]+", options: [])
		return regex.numberOfMatches(in: value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
