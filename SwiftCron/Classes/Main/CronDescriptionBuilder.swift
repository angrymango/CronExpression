//
//  CronDescriptionBuilder.swift
//  Pods
//
//  Created by Keegan Rush on 2016/05/10.
//
//

import Foundation

enum CronDescriptionLength { case Short, Medium, Long }

class CronDescriptionBuilder
{
	static func buildDescription(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		if let biggestField = cronRepresentation.biggestField
		{
			switch biggestField {
			case .Minute:
				return descriptionWithMinuteBiggest(cronRepresentation)
			case .Hour:
				return descriptionWithHourBiggest(cronRepresentation, length: length)
			case .Day:
				return descriptionWithDayBiggest(cronRepresentation)
			case .Month:
				return descriptionWithMonthBiggest(cronRepresentation)
			case .Weekday:
				return descriptionWithWeekdayBiggest(cronRepresentation)
			case .Year:
				return descriptionWithYearBiggest(cronRepresentation)
			}
		}
		return "Every Minute"
	}

	private static func descriptionWithMinuteBiggest(cronRepresentation: CronRepresentation) -> String
	{
		return ""
	}

	private static func descriptionWithHourBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		let hour = Int(cronRepresentation.hour)!
		let minute = Int(cronRepresentation.minute)!

		let calendar = NSCalendar.currentCalendar()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let components = NSDateComponents()
		components.hour = hour
		components.minute = minute
		let date = calendar.dateFromComponents(components)!
		let time = dateFormatter.stringFromDate(date)

		switch length {
		case .Long:
			return "Every day at \(time)"
		case .Medium:
			return "Every day"
		case .Short:
			return time
		}
	}

	private static func descriptionWithDayBiggest(cronRepresentation: CronRepresentation) -> String
	{
		return ""
	}

	private static func descriptionWithMonthBiggest(cronRepresentation: CronRepresentation) -> String
	{
		return ""
	}

	private static func descriptionWithWeekdayBiggest(cronRepresentation: CronRepresentation) -> String
	{
		return ""
	}

	private static func descriptionWithYearBiggest(cronRepresentation: CronRepresentation) -> String
	{
		return ""
	}
}