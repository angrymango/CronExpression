import Foundation

private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

private func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class Field
{
	var fields: NSMutableArray?

	func isSatisfied(_ dateValue: String, value: String) -> Bool
	{
		if isIncrementsOfRanges(value)
		{
			return isInIncrementsOfRanges(dateValue, withValue: value)
		}
		else if isRange(value)
		{
			return isInRange(dateValue, withValue: value)
		}

		return value == CronRepresentation.DefaultValue || dateValue == value
	}

	func isRange(_ value: String) -> Bool
	{
		return value.range(of: "-") != nil
	}

	func isIncrementsOfRanges(_ value: String) -> Bool
	{
		return value.range(of: CronRepresentation.StepIdentifier) != nil
	}

	func isInRange(_ dateValue: String, withValue value: String) -> Bool
	{
		let parts = value.components(separatedBy: "-")

		return Int(dateValue) >= Int(parts[0]) && Int(dateValue) <= Int(parts[1])
	}

	func isInIncrementsOfRanges(_ dateValue: String, withValue value: String) -> Bool
	{
		let parts = value.components(separatedBy: CronRepresentation.StepIdentifier)
		if parts[0] != CronRepresentation.DefaultValue && Int(parts[0]) != 0
		{
			guard parts[0].range(of: "-") != nil else
			{
				NSLog("Cannot increment a range! \(value)")
				return false
			}

			let range = parts[0].components(separatedBy: "-")
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
