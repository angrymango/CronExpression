import Foundation

class MinutesField: Field, FieldCheckerInterface
{

	func isSatisfiedBy(_ date: Date, value: String) -> Bool
	{
		let calendar = Calendar.current
		let components = (calendar as NSCalendar).components([.minute], from: date)

        guard let minute = components.minute else { return false }
        
		return self.isSatisfied(String(format: "%d", minute), value: value)
	}

	func increment(_ date: Date, toMatchValue: String) -> Date
	{
		if let nextDate = date.nextDate(matchingUnit: .minute, value: toMatchValue)
		{
			return nextDate
		}

		let calendar = Calendar.current
		var components = DateComponents()
		components.minute = 1;

		return (calendar as NSCalendar).date(byAdding: components, to: date, options: [])!
	}

	func validate(_ value: String) -> Bool
	{
		let regex = try! NSRegularExpression(pattern: "[\\*,\\/\\-0-9]+", options: [])

		return regex.numberOfMatches(in: value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
