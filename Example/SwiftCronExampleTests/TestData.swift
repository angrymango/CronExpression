//
//  TestData.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/06.
//  Copyright © 2016 Rush42. All rights reserved.
//

import Foundation

class TestData
{
    static let feb28_2016 = DateBuilder().with(year: 2016).with(month: 2).with(day: 28).build()
    static let feb1_2016 = DateBuilder().with(year: 2016).with(month: 2).with(day: 1).build()
    static let may15_2016 = DateBuilder().with(year: 2016).with(month: 5).with(day: 15).build()
    static let july11_2016 = DateBuilder().with(year: 2016).with(month: 7).with(day: 11).build()
    static let july27_2016 = DateBuilder().with(year: 2016).with(month: 7).with(day: 27).build()
	static let may11 = (Calendar.current as NSCalendar).date(era: 1, year: 2016, month: 05, day: 11, hour: 0, minute: 0, second: 0, nanosecond: 0)!
	static let may12 = (Calendar.current as NSCalendar).date(era: 1, year: 2016, month: 05, day: 12, hour: 0, minute: 0, second: 0, nanosecond: 0)!
	static let may14 = (Calendar.current as NSCalendar).date(era: 1, year: 2016, month: 05, day: 14, hour: 0, minute: 0, second: 0, nanosecond: 0)!
	static let may16 = (Calendar.current as NSCalendar).date(era: 1, year: 2016, month: 05, day: 16, hour: 0, minute: 0, second: 0, nanosecond: 0)!
	static let june1 = (Calendar.current as NSCalendar).date(era: 1, year: 2016, month: 06, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)!
	static let june8 = (Calendar.current as NSCalendar).date(era: 1, year: 2016, month: 06, day: 8, hour: 0, minute: 0, second: 0, nanosecond: 0)!
	static let jan1_2017 = (Calendar.current as NSCalendar).date(era: 1, year: 2017, month: 01, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)!
}
