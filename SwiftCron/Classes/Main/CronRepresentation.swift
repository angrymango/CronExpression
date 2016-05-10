//
//  CronRepresentation.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/06.
//  Copyright © 2016 Rush42. All rights reserved.
//

import Foundation

public struct CronRepresentation
{
	static let NumberOfComponentsInValidString = 6

	private var year: String
	private var weekday: String
	private var month: String
	private var day: String
	private var hour: String
	private var minute: String

	// MARK: Issue 3: Get rid of. Should rather be using the enum
	subscript(index: Int) -> String
	{
		return cronParts[index]
	}

	init(minute: String = "*", hour: String = "*", day: String = "*", month: String = "*", weekday: String = "*", year: String = "*")
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

	public var cronString: String

	public var cronParts: Array<String>
}