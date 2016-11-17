import Foundation

class HoursField: Field, FieldCheckerInterface
{

	func isSatisfiedBy(_ date: Date, value: String) -> Bool
	{
		let calendar = Calendar.current
		let components = (calendar as NSCalendar).components([.hour], from: date)
        guard let hour = components.hour else { return false }
        
		return isSatisfied(String(format: "%d", hour), value: value)
	}

	func increment(_ date: Date, toMatchValue: String) -> Date
	{
		if let nextDate = date.nextDate(matchingUnit: .hour, value: toMatchValue)
		{
			return nextDate
		}

		let calendar = Calendar.current
		var components = DateComponents()
		components.hour = 1
		return (calendar as NSCalendar).date(byAdding: components, to: date, options: [])!
	}

	func validate(_ value: String) -> Bool
	{
        if let regex = try? NSRegularExpression(pattern: "[\\*,\\/\\-0-9]+", options: .caseInsensitive) {
            return regex.numberOfMatches(in: value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
        } else { return false }
	}
}
