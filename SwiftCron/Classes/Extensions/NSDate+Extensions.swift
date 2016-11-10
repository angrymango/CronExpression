//
//  NSDate+Extensions.swift
//  Pods
//
//  Created by Keegan Rush on 2016/05/25.
//
//

import Foundation
extension Date
{
	static func convertWeekdayWithMondayFirstToSundayFirst(_ weekday: Int) -> Int
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

	func nextDate(matchingUnit unit: NSCalendar.Unit, value: String) -> Date?
	{
		let calendar = Calendar.current

		var valueToMatch: Int!

		if value.contains(CronRepresentation.ListIdentifier)
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

		var components = DateComponents()

		switch unit {
		case NSCalendar.Unit.era:
			components.era = valueToMatch
		case NSCalendar.Unit.year:
			if (calendar as NSCalendar).component(.year, from: self) >= valueToMatch
			{
				return nil
			}
			components.year = valueToMatch
		case NSCalendar.Unit.month:
			components.month = valueToMatch
		case NSCalendar.Unit.day:
			components.day = valueToMatch
		case NSCalendar.Unit.hour:
			components.hour = valueToMatch
		case NSCalendar.Unit.minute:
			components.minute = valueToMatch
		case NSCalendar.Unit.second:
			components.second = valueToMatch
		case NSCalendar.Unit.weekday:
			components.weekday = valueToMatch
		case NSCalendar.Unit.weekdayOrdinal:
			components.weekdayOrdinal = valueToMatch
		case NSCalendar.Unit.quarter:
			components.quarter = valueToMatch
		case NSCalendar.Unit.weekOfMonth:
			components.weekOfMonth = valueToMatch
		case NSCalendar.Unit.weekOfYear:
			components.weekOfYear = valueToMatch
		case NSCalendar.Unit.yearForWeekOfYear:
			components.yearForWeekOfYear = valueToMatch
		case NSCalendar.Unit.nanosecond:
			components.nanosecond = valueToMatch
		default:
			print("\(#function): Not a valid calendar unit for this function.")
			return nil
		}

		return (calendar as NSCalendar).nextDate(after: self, matching: components, options: .matchStrictly)
	}
}
