import Foundation

class YearField: Field, FieldCheckerInterface
{

	func isSatisfiedBy(_ date: Date, value: String) -> Bool
	{
		let calendar = Calendar.current
		let components = (calendar as NSCalendar).components([.year], from: date)
        
        guard let year = components.year else { return false }
        
		return self.isSatisfied(String(format: "%d", year), value: value)
	}

	func increment(_ date: Date, toMatchValue: String) -> Date
	{
		if let nextDate = date.nextDate(matchingUnit: .year, value: toMatchValue)
		{
			return nextDate
		}

		let calendar = Calendar.current
		let midnightComponents = (calendar as NSCalendar).components([.day, .month, .year], from: date)

		var components = DateComponents()
		components.year = 1;

		return (calendar as NSCalendar).date(byAdding: components, to: calendar.date(from: midnightComponents)!, options: [])!
	}

	func validate(_ value: String) -> Bool
	{
		let regex = try! NSRegularExpression(pattern: "[\\*,\\/\\-0-9]+", options: [])

		return regex.numberOfMatches(in: value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
