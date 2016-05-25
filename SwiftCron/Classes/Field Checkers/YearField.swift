import Foundation

class YearField: Field, FieldCheckerInterface
{

	func isSatisfiedBy(date: NSDate, value: String) -> Bool
	{
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components([.Year], fromDate: date)
		return self.isSatisfied(String(format: "%d", components.year), value: value)
	}

	func increment(date: NSDate, toMatchValue: String) -> NSDate
	{
		if let nextDate = date.nextDate(matchingUnit: .Year, value: toMatchValue)
		{
			return nextDate
		}

		let calendar = NSCalendar.currentCalendar()
		let midnightComponents = calendar.components([.Day, .Month, .Year], fromDate: date)

		let components = NSDateComponents()
		components.year = 1;

		return calendar.dateByAddingComponents(components, toDate: calendar.dateFromComponents(midnightComponents)!, options: [])!
	}

	func validate(value: String) -> Bool
	{

		guard let regex = try? NSRegularExpression(pattern: "[\\*,\\/\\-0-9]+", options: []) else
		{
			NSLog("\(#function): Could not create regex")
			return false
		}

		return regex.numberOfMatchesInString(value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
