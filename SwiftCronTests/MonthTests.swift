//
//  MonthTests.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/06.
//  Copyright © 2016 Krush 42. All rights reserved.
//

import XCTest
@testable import SwiftCron

class MonthTests: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testEveryMonthOn1stRunsNextMonth() {
		let calendar = NSCalendar.currentCalendar()
		let dateToTestFrom = calendar.dateWithEra(1, year: 2016, month: 05, day: 11, hour: 0, minute: 0, second: 0, nanosecond: 0)!

		let cronString = "* * 1 * * *"
		let firstDayOfMonthCron = CronExpression(schedule: cronString)
		let nextRunDate = firstDayOfMonthCron?.getNextRunDate(dateToTestFrom)

		let firstDayOfMonthComponents = NSDateComponents()
		firstDayOfMonthComponents.day = 1
		let firstDayOfNextMonth = calendar.nextDateAfterDate(dateToTestFrom, matchingComponents: firstDayOfMonthComponents, options: [.MatchNextTime])

		XCTAssertTrue(calendar.isDate(firstDayOfNextMonth!, inSameDayAsDate: nextRunDate!))
	}

}
