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
		let midnightComponents = calendar.dateComponents([.day, .month, .year], from: date)

		var components = DateComponents()
		components.month = 1;

		return (calendar as NSCalendar).date(byAdding: components, to: calendar.date(from: midnightComponents)!, options: [])!
	}

	func validate(_ value: String) -> Bool
	{
        return StringValidator.isUpperCaseOrNumber(value)
	}
}
