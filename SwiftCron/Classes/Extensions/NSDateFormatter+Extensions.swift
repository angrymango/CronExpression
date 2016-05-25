//
//  NSDateFormatter+Extensions.swift
//  Pods
//
//  Created by Keegan Rush on 2016/05/12.
//
//

import Foundation

extension NSDateFormatter
{
	private static let timeDateFormatter: NSDateFormatter =
		{
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "HH:mm"
			return dateFormatter
	}()

	private static let minuteDateFormatter: NSDateFormatter =
		{
			let dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "mm"
			return dateFormatter
	}()

	private static let weekdayFormatter: NSDateFormatter =
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "EEEE"
			return formatter
	}()

	static func timeStringWithHour(hour: String, minute: String) -> String
	{
		let theHour = Int(hour)!
		let theMinute = Int(minute)!
		assert(theMinute < 60 && theMinute > -1)
		assert(theHour > -1 && theHour < 25)

		let calendar = NSCalendar.currentCalendar()
		let components = NSDateComponents()
		components.hour = theHour
		components.minute = theMinute
		let date = calendar.dateFromComponents(components)!
		return timeDateFormatter.stringFromDate(date)
	}

	static func minuteStringWithMinute(minute: String) -> String
	{
		let theMinute = Int(minute)!
		assert(theMinute < 60 && theMinute > -1)

		let calendar = NSCalendar.currentCalendar()
		let components = NSDateComponents()
		components.minute = theMinute
		let date = calendar.dateFromComponents(components)!
		return minuteDateFormatter.stringFromDate(date)
	}

	static func convertStringToDaysOfWeek(weekdaysString: String) -> String
	{

		var daysOfWeekArray: Array<String> = []
		let days = weekdaysString.componentsSeparatedByString(CronRepresentation.listIdentifier)

		let calendar = NSCalendar.currentCalendar()
		let searchDate = NSDate(timeIntervalSince1970: 0)
		let components = NSDateComponents()

		for day in days
		{
			// Currently arranged from 1-7 starting at Sunday. Rearrange to 1-7 starting at Monday.
			let dayNumber = NSDate.convertWeekdayWithMondayFirstToSundayFirst(Int(day)!)

			assert(dayNumber >= 1 && dayNumber <= 7, "Day does not fit in week")
			components.weekday = dayNumber
			let date = calendar.nextDateAfterDate(searchDate, matchingComponents: components, options: .MatchStrictly)!
			let dayString = NSDateFormatter.weekdayFormatter.stringFromDate(date)
			if (days.contains(dayString) == false)
			{
				daysOfWeekArray.append(dayString)
			}
		}

		// Sunday will be first. Make it last
		let sunday = "Sunday"
		if daysOfWeekArray.contains(sunday)
		{
			daysOfWeekArray.removeAtIndex(daysOfWeekArray.indexOf(sunday)!)
			daysOfWeekArray.append(sunday)
		}

		return daysOfWeekArray.joinWithSeparator(", ")
	}
}