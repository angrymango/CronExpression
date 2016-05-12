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
}