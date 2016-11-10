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
		if isRange(value)
		{
			return isInRange(dateValue, withValue: value)
		}

		return value == CronRepresentation.DefaultValue || dateValue == value
	}

	func isRange(_ value: String) -> Bool
	{
		return value.range(of: "-") != nil
	}

	func isInRange(_ dateValue: String, withValue value: String) -> Bool
	{
		let parts = value.components(separatedBy: "-")

		return Int(dateValue) >= Int(parts[0]) && Int(dateValue) <= Int(parts[1])
	}
}
