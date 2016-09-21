//
//  HourTests.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/06.
//  Copyright © 2016 Rush42. All rights reserved.
//

import XCTest
import SwiftCron

class HourTests: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testEvery11thHour() {
		let calendar = Calendar.current

		let dateToTestFrom = TestData.may11

		var components = (calendar as NSCalendar).components([.day, .year, .month, .hour], from: dateToTestFrom)
		components.hour = 11
		let expectedDate = calendar.date(from: components)

		let every11thHourCron = CronExpression(minute: "0", hour: "11")
		let nextRunDate = every11thHourCron?.getNextRunDate(dateToTestFrom)

		XCTAssertTrue((calendar as NSCalendar).isDate(nextRunDate!, equalTo: expectedDate!, toUnitGranularity: .hour))
	}

}
