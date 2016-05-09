import Foundation

class HoursField: Field, FieldCheckerInterface
{

	func isSatisfiedBy(date: NSDate, value: String) -> Bool
	{

		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components([.Hour], fromDate: date)

		return isSatisfied(String(format: "%d", components.hour), value: value)
	}

	func increment(date: NSDate) -> NSDate
	{
		let calendar = NSCalendar.currentCalendar()
		let components = NSDateComponents()
		components.hour = 1;
		return calendar.dateByAddingComponents(components, toDate: date, options: [])!
	}

	func validate(value: String) -> Bool
	{
		guard let regex = try? NSRegularExpression(pattern: "[\\*,\\/\\-0-9]+", options: .CaseInsensitive) else
		{
			NSLog("\(#function): Cannot create regular expression")
			return false
		}

		return regex.numberOfMatchesInString(value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}
