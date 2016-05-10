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

		let everyMondayCron = CronExpression(minute: "0", hour: "0", weekday: "2")
		let nextRunDate = everyMondayCron?.getNextRunDate(dateToTestFrom)

		XCTAssertTrue(calendar.isDate(nextMonday, inSameDayAsDate: nextRunDate!))
	}

}
