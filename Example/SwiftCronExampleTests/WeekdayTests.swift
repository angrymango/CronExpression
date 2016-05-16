//
//  WeekdayTests.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/06.
//  Copyright © 2016 Rush42. All rights reserved.
//

import XCTest
import SwiftCron

class WeekdayTests: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testEveryWeekOnMonday() {
		let calendar = NSCalendar.currentCalendar()
		let dateToTestFrom = TestData.may11
		let nextMonday = TestData.may16

		let everyMondayCron = CronExpression(minute: "0", hour: "0", weekday: "1")
		let nextRunDate = everyMondayCron?.getNextRunDate(dateToTestFrom)

		XCTAssertTrue(calendar.isDate(nextMonday, inSameDayAsDate: nextRunDate!))
	}

	func testEveryWeekday() {
		let calendar = NSCalendar.currentCalendar()
		let weekendDateToTestFrom = TestData.may14
		let nextMonday = TestData.may16

		let everyWeekdayCron = CronExpression(cronString: "0 0 * * 1,2,3,4,5 *")
		let nextRunDateFromWeekend = everyWeekdayCron?.getNextRunDate(weekendDateToTestFrom)

		XCTAssertTrue(calendar.isDate(nextMonday, inSameDayAsDate: nextRunDateFromWeekend!))

		var wednesday = TestData.may11
		// Add a minute to ensure we're not at midnight to prevent a match for wednesday
		wednesday = calendar.dateByAddingUnit(.Minute, value: 1, toDate: wednesday, options: [])!
		let thursday = TestData.may12
		let nextRunDateFromWednesday = everyWeekdayCron?.getNextRunDate(wednesday)
		XCTAssertTrue(calendar.isDate(thursday, inSameDayAsDate: nextRunDateFromWednesday!))
	}

}
