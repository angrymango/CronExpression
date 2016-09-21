//
//  MinuteTests.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/06.
//  Copyright © 2016 Rush42. All rights reserved.
//

import XCTest
import SwiftCron

class MinuteTests: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testEvery30thMinute() {
		let calendar = Calendar.current

		let dateToTestFrom = TestData.may11

		var components = (calendar as NSCalendar).components([.day, .year, .month, .hour], from: dateToTestFrom)
		components.minute = 30
		let expectedDate = calendar.date(from: components)

		let every30thMinuteCron = CronExpression(minute: "30")
		let nextRunDate = every30thMinuteCron?.getNextRunDate(dateToTestFrom)

		XCTAssertTrue((calendar as NSCalendar).isDate(nextRunDate!, equalTo: expectedDate!, toUnitGranularity: .minute))
	}

}
