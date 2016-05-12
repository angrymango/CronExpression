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
		return descriptionWithNoneBiggest(cronRepresentation, length: length)
	}

	private static func descriptionWithNoneBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		if CronRepresentation.isDefault(cronRepresentation.weekday)
		{
			return "Every minute"
		}
		else
		{
			let weekday = NSDateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
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
			let weekday = NSDateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
			return "Every hour at \(minutes) on a \(weekday)"
		}
	}

	private static func descriptionWithHourBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{

		let time = NSDateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)

		if CronRepresentation.isDefault(cronRepresentation.weekday)
		{
			switch length {
			case .Long:
				return "Every day at \(time)"
			case .Short:
				return "Every day"
			}
		}
		else
		{
			let weekday = NSDateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
			switch length {
			case .Long:
				return "Every \(weekday) at \(time)"
			case .Short:
				return "Every \(weekday)"
			}
		}

	}

	private static func descriptionWithDayBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		// "Every hour at 30 minutes on the 11th"

		let day = Int(cronRepresentation.day)!.ordinal

		if CronRepresentation.isDefault(cronRepresentation.hour)
		{
			let minutes = NSDateFormatter.minuteStringWithMinute(cronRepresentation.minute)
			return "Every hour at \(minutes) minutes on the \(day)"
		}
		else
		{
			let time = NSDateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)
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
				let weekday = NSDateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
				switch length {
				case .Long:
					return "Every \(weekday) the \(day) at \(time)"
				case .Short:
					return "Every \(weekday) the \(day)"
				}
			}
		}
	}

	private static func descriptionWithMonthBiggest(cronRepresentation: CronRepresentation, length: CronDescriptionLength) -> String
	{
		let time = NSDateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)
		let day = Int(cronRepresentation.day)!.ordinal
		let month = Int(cronRepresentation.month)!.convertToMonth()

		let desc = "Every \(day) of \(month)"
		if CronRepresentation.isDefault(cronRepresentation.weekday)
		{
			switch length {
			case .Long:
				return "\(desc) at \(time)"
			case .Short:
				return desc
			}
		}
		else
		{
			let weekday = NSDateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
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
		let time = NSDateFormatter.timeStringWithHour(cronRepresentation.hour, minute: cronRepresentation.minute)
		let day = Int(cronRepresentation.day)!.ordinal
		let month = Int(cronRepresentation.month)!.convertToMonth()

		let desc = "\(day) of \(month) \(cronRepresentation.year)"
		if CronRepresentation.isDefault(cronRepresentation.weekday)
		{
			switch length {
			case .Short:
				return desc
			case .Long:
				return "\(desc) at \(time)"
			}
		}
		else
		{
			let weekday = NSDateFormatter.convertStringToDaysOfWeek(cronRepresentation.weekday)
			switch length {
			case .Short:
				return "\(weekday) \(desc)"
			case .Long:
				return "\(weekday) \(desc) at \(time)"
			}
		}
	}
}