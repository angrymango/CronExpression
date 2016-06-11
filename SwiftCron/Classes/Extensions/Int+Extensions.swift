//
//  NSNumberFormatter+Extensions.swift
//  Pods
//
//  Created by Keegan Rush on 2016/05/12.
//
//

import Foundation

extension Int: CronFieldTranslatable
{
	public var cronFieldRepresentation: String
	{
		return String(self)
	}
}

extension Int
{
	private static let ordinalNumberFormatter: NSNumberFormatter =
		{
			let formatter = NSNumberFormatter()
			formatter.numberStyle = .OrdinalStyle
			return formatter
	}()

	private static let monthFormatter: NSDateFormatter =
		{
			let formatter = NSDateFormatter()
			formatter.dateFormat = "MMMM"
			return formatter
	}()

	var ordinal: String
	{
		return Int.ordinalNumberFormatter.stringFromNumber(self)!
	}

	func convertToMonth() -> String
	{
		assert(self < 13 && self > 0, "Not a valid month")

		let calendar = NSCalendar.currentCalendar()
		let components = NSDateComponents()
		components.month = self
		let date = calendar.dateFromComponents(components)!
		return Int.monthFormatter.stringFromDate(date)
	}
}