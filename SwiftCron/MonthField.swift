import Foundation

class MonthField: Field, FieldInterface
{

	func isSatisfiedBy(date: NSDate, value: String) -> Bool
	{
//		var monthMap = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
//		var indexOfMonth = Int(value)!
//		indexOfMonth -= 1
        let calendar = NSCalendar.currentCalendar()
        let month = calendar.component(.Month, fromDate: date)
		return isSatisfied(String(month), value: value)
	}

	func increment(date: NSDate) -> NSDate
	{
		let calendar = NSCalendar.currentCalendar()
		let midnightComponents = calendar.components([.Day, .Month, .Year], fromDate: date)

		let components = NSDateComponents()
		components.month = 1;

		return calendar.dateByAddingComponents(components, toDate: calendar.dateFromComponents(midnightComponents)!, options: [])!
	}

	func validate(value: String) -> Bool
	{
		guard let regex = try? NSRegularExpression(pattern: "[\\*,\\/\\-0-9A-Z]+", options: []) else
		{
			NSLog("\(#function): Could not get regular expression")
			return false
		}
		return regex.numberOfMatchesInString(value, options: [], range: NSMakeRange(0, value.characters.count)) > 0
	}
}