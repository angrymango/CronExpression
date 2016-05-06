import Foundation

class FieldFactory
{
	var fields: NSMutableArray = NSMutableArray(array: [-1, -1, -1, -1, -1, -1])

	func getField(position: Int) -> FieldInterface?
	{
		guard position < fields.count else
		{
			NSLog("\(#function): \(position) is not a valid position")
			return nil
		}

		if fields.objectAtIndex(position) as? Int == -1
		{
			switch (position)
			{
			case 0:
				fields.insertObject(MinutesField(), atIndex: position)
			case 1:
				fields.insertObject(HoursField(), atIndex: position)
			case 2:
				fields.insertObject(DayOfMonthField(), atIndex: position)
			case 3:
				fields.insertObject(MonthField(), atIndex: position)
			case 4:
				fields.insertObject(DayOfWeekField(), atIndex: position)
			case 5:
				fields.insertObject(YearField(), atIndex: position)
			default:
				NSLog("Invalid position.")
				break
			}
		}

		return fields.objectAtIndex(position) as? FieldInterface
	}
}