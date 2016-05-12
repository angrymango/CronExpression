//
//  CronRepresentation.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/06.
//  Copyright © 2016 Rush42. All rights reserved.
//

import Foundation

enum CronField: Int
{
	case Minute, Hour, Day, Month, Weekday, Year
	private static let fieldCheckers: Array<FieldCheckerInterface> = [MinutesField(), HoursField(), DayOfMonthField(), MonthField(), DayOfWeekField(), YearField()]

	func getFieldChecker() -> FieldCheckerInterface
	{
		return CronField.fieldCheckers[rawValue]
	}
}

public struct CronRepresentation
{
	static let NumberOfComponentsInValidString = 6
	static let defaultValue = "*"
	static let stepIdentifier = "/"
	static let listIdentifier = ","

	var year: String
	var weekday: String
	var month: String
	var day: String
	var hour: String
	var minute: String

	var biggestField: CronField?
	{
		let defaultValue = CronRepresentation.defaultValue

		if year != defaultValue { return CronField.Year }
		if month != defaultValue { return CronField.Month }
		if day != defaultValue { return CronField.Day }
		if hour != defaultValue { return CronField.Hour }
		if minute != defaultValue { return CronField.Minute }
		return nil
	}

	// MARK: Issue 3: Get rid of. Should rather be using the enum
	subscript(index: Int) -> String
	{
		return cronParts[index]
	}

	init(minute: String = defaultValue, hour: String = defaultValue, day: String = defaultValue, month: String = defaultValue, weekday: String = defaultValue, year: String = defaultValue)
	{
		self.minute = minute
		self.hour = hour
		self.day = day
		self.month = month
		self.weekday = weekday
		self.year = year

		cronParts = [minute, hour, day, month, weekday, year]
		cronString = "\(minute) \(hour) \(day) \(month) \(weekday) \(year)"
	}

	init?(cronString: String)
	{
		let parts = cronString.componentsSeparatedByString(" ")
		guard parts.count == CronRepresentation.NumberOfComponentsInValidString else
		{
			return nil
		}

		self.init(minute: parts[0], hour: parts[1], day: parts[2], month: parts[3], weekday: parts[4], year: parts[5])
	}

	// MARK: Issue 3: pass in enum. Get value out of enum and check if it matches the default value?
	static func isDefault(field: String) -> Bool
	{
		return field == CronRepresentation.defaultValue
	}

	public var cronString: String

	public var cronParts: Array<String>
}