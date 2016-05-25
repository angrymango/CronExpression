import Foundation

class MinutesField: Field, FieldCheckerInterface
{

	func isSatisfiedBy(date: NSDate, value: String) -> Bool
	{
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components([.Minute], fromDate: date)

		return self.isSatisfied(String(format: "%d", components.minute), value: value)
	}

	func increment(date: NSDate, toMatchValue: String) -> NSDate
	{
		if let nextDate = date.nextDate(matchingUnit: .Minute, value: toMatchValue)
		{
			return nextDate
		}

		let calendar = NSCalendar.currentCalendar()
		let components = NSDateComponents()
		components.minute = 1;

		return calendar.dateByAddingComponents(components, toDate: date, options: [])!
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