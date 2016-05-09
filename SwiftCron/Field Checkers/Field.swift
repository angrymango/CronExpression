import Foundation

class Field
{
	var fields: NSMutableArray?

	func isSatisfied(dateValue: String, value: String) -> Bool
	{
		if isIncrementsOfRanges(value)
		{
			return isInIncrementsOfRanges(dateValue, withValue: value)
		}
		else if isRange(value)
		{
			return isInRange(dateValue, withValue: value)
		}

		return value == "*" || dateValue == value;
	}

	func isRange(value: String) -> Bool
	{
		return value.rangeOfString("-") != nil
	}

	func isIncrementsOfRanges(value: String) -> Bool
	{
		return value.rangeOfString("/") != nil
	}

	func isInRange(dateValue: String, withValue value: String) -> Bool
	{
		let parts = value.componentsSeparatedByString("-")

		return Int(dateValue) >= Int(parts[0]) && Int(dateValue) <= Int(parts[1])
	}

	func isInIncrementsOfRanges(dateValue: String, withValue value: String) -> Bool
	{
		let parts = value.componentsSeparatedByString("/")
		if parts[0] != "*" && Int(parts[0]) != 0
		{
			guard parts[0].rangeOfString("-") != nil else
			{
				NSLog("Cannot increment a range! \(value)")
				return false
			}

			let range = parts[0].componentsSeparatedByString("-")
			if Int(dateValue) == Int(range[0])
			{
				return true
			}
			else if Int(dateValue) < Int(range[0])
			{
				return false
			}
		}

		return Int(dateValue)! % Int(parts[1])! == 0
	}
}