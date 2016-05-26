//
//  NSDate+Extensions.swift
//  Pods
//
//  Created by Keegan Rush on 2016/05/25.
//
//

import Foundation
extension NSDate
{
	static func convertWeekdayWithMondayFirstToSundayFirst(weekday: Int) -> Int
	{
		let sundayWhenFirstDayOfWeek = 1
		let sundayWhenMondayFirst = 7

		// Currently arranged from 1-7 starting at Sunday. Rearrange to 1-7 starting at Monday.
		if weekday == sundayWhenMondayFirst
		{
			return sundayWhenFirstDayOfWeek
		}
		return weekday + 1
	}

	func nextDate(matchingUnit unit: NSCalendarUnit, value: String) -> NSDate?
	{
		let calendar = NSCalendar.currentCalendar()

		var valueToMatch: Int!

		if value.containsString(CronRepresentation.listIdentifier)
		{
			// TODO: issue 13: Match list items
			return nil
		}
		else
		{
			valueToMatch = Int(value)
		}

		guard valueToMatch != nil else
		{
			return nil
		}

		let components = NSDateComponents()

		switch unit {
		case NSCalendarUnit.Era:
			components.era = valueToMatch
		case NSCalendarUnit.Year:
			if calendar.component(.Year, fromDate: self) >= valueToMatch
			{
				return nil
			}
			components.year = valueToMatch
		case NSCalendarUnit.Month:
			components.month = valueToMatch
		case NSCalendarUnit.Day:
			components.day = valueToMatch
		case NSCalendarUnit.Hour:
			components.hour = valueToMatch
		case NSCalendarUnit.Minute:
			components.minute = valueToMatch
		case NSCalendarUnit.Second:
			components.second = valueToMatch
		case NSCalendarUnit.Weekday:
			components.weekday = valueToMatch
		case NSCalendarUnit.WeekdayOrdinal:
			components.weekdayOrdinal = valueToMatch
		case NSCalendarUnit.Quarter:
			components.quarter = valueToMatch
		case NSCalendarUnit.WeekOfMonth:
			components.weekOfMonth = valueToMatch
		case NSCalendarUnit.WeekOfYear:
			components.weekOfYear = valueToMatch
		case NSCalendarUnit.YearForWeekOfYear:
			components.yearForWeekOfYear = valueToMatch
		case NSCalendarUnit.Nanosecond:
			components.nanosecond = valueToMatch
		default:
			print("\(#function): Not a valid calendar unit for this function.")
			return nil
		}

		return calendar.nextDateAfterDate(self, matchingComponents: components, options: .MatchStrictly)
	}
}