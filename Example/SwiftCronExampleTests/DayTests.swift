//
//  DayTests.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/06.
//  Copyright © 2016 Rush42. All rights reserved.
//

import XCTest
import SwiftCron

class DayTests: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testEvery8thDayOfMonth() {
		let calendar = NSCalendar.currentCalendar()

		let dateToTestFrom = TestData.may11

		let every8thDayCron = CronExpression(minute: "0", hour: "0", day: "8")
		let nextRunDate = every8thDayCron?.getNextRunDate(dateToTestFrom)

		XCTAssertTrue(calendar.isDate(TestData.june8, inSameDayAsDate: nextRunDate!))
	}
}
