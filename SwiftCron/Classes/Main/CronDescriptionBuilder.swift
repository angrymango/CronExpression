//
//  CronDescriptionBuilder.swift
//  Pods
//
//  Created by Keegan Rush on 2016/05/10.
//
//

import Foundation

enum CronDescriptionLength { case Short, Long }

class CronDescriptionBuilder
{
	static func buildDescription(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		if let biggestField = cronRepresentation.biggestField
		{
			switch biggestField {
			case .Minute:
				return descriptionWithMinuteBiggest(cronRepresentation, length: length)
			case .Hour:
				return descriptionWithHourBiggest(cronRepresentation, length: length)
			case .Day:
				return descriptionWithDayBiggest(cronRepresentation, length: length)
			case .Month:
				return descriptionWithMonthBiggest(cronRepresentation, length: length)
			case .Weekday:
				return descriptionWithNoneBiggest(cronRepresentation, length: length)
			case .Year:
				return descriptionWithYearBiggest(cronRepresentation, length: length)
			}
		}
		return "Every minute"
	}

	private static func descriptionWithNoneBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		if CronRepresentation.isDefault(cronRepresentation.weekday)
		{
			return "Every minute"
		}
		else
		{
			let weekday = Int(cronRepresentation.weekday)!.convertToDayOfWeek()
			return "Every minute on a \(weekday)"
		}
	}

	private static func descriptionWithMinuteBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		let minutes = NSDateFormatter.minuteStringWithMinute(cronRepresentation.minute)
		if CronRepresentation.isDefault(cronRepresentation.weekday)
		{
			return "Every hour at \(minutes) minutes"
		}
		else
		{
			let weekday = Int(cronRepresentation.weekday)!.convertToDayOfWeek()
			return "Every hour at \(minutes) on a \(weekday)"
		}
	}

	private static func descriptionWithHourBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{

		let time = NSDateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)

		switch length {
		case .Long:
			return "Every day at \(time)"
		case .Short:
			return "Every day"
		}
	}

	private static func descriptionWithDayBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		let time = NSDateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)
		let day = Int(cronRepresentation.day)!.ordinal

		if CronRepresentation.isDefault(cronRepresentation.weekday)
		{
			switch length {
			case .Long:
				return "Every \(day) of the month at \(time)"
			case .Short:
				return "Every \(day) of the month"
			}
		}
		else
		{
			let weekday = Int(cronRepresentation.weekday)!.convertToDayOfWeek()
			switch length {
			case .Long:
				return "Every \(weekday) the \(day) at \(time)"
			case .Short:
				return "Every \(weekday) the \(day)"
			}
		}
	}

	private static func descriptionWithMonthBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		let time = NSDateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)
		let day = Int(cronRepresentation.day)!.ordinal
		let month = Int(cronRepresentation.month)!.convertToMonth()

		if CronRepresentation.isDefault(cronRepresentation.weekday)
		{
			switch length {
			case .Long:
				return "Every \(day) of \(month) at \(time)"
			case .Short:
				return "Every \(day) of \(month)"
			}
		}
		else
		{
			let weekday = Int(cronRepresentation.weekday)!.convertToDayOfWeek()
			switch length {
			case .Short:
				return "Every \(weekday) the \(day) of \(month)"
			case .Long:
				return "Every \(weekday) the \(day) of \(month) at \(time)"
			}
		}
	}

	private static func descriptionWithYearBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		return ""
	}
}