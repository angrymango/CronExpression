//
//  DescriptionTests.swift
//  SwiftCronExample
//
//  Created by Keegan Rush on 2016/05/10.
//  Copyright © 2016 Rush42. All rights reserved.
//

import XCTest
import SwiftCron

class DescriptionTests: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testDescriptionOfNever() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	func testDescriptionOfEvery30Minutes() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	func testDescriptionOfEveryDayAtMidday()
	{
		let cronExpression = CronExpression(minute: "0", hour: "12")!
		let description = cronExpression.description
		let expectedDescription = "Midday"
		XCTAssertEqual(description, expectedDescription)
	}

	func testDescriptionOfEveryMonthOn14th()
	{
		let cronExpression = CronExpression(minute: "0", hour: "0", day: "14")!
		let description = cronExpression.description
		let expectedDescription = "14th of the month"
		XCTAssertEqual(description, expectedDescription)
	}

	func testDescriptionOfEveryYearFeb14th()
	{
		let cronExpression = CronExpression(minute: "0", hour: "0", day: "14", month: "2")!
		let description = cronExpression.description
		let expectedDescription = "14th of February"
		XCTAssertEqual(description, expectedDescription)
	}

	func testDescriptionOfEveryFriday13th()
	{
		let cronExpression = CronExpression(minute: "0", hour: "0", day: "13", weekday: "6")!
		let description = cronExpression.description
		let expectedDescription = "Friday 13th"
		XCTAssertEqual(description, expectedDescription)
	}

	func testDescriptionOfEveryday()
	{
		let cronExpression = CronExpression(minute: "0", hour: "0")!
		let description = cronExpression.description
		let expectedDescription = "Every day"
		XCTAssertEqual(description, expectedDescription)
	}

	func testDescriptionOfWeekdays()
	{
		let cronExpression = CronExpression(minute: "0", hour: "0", weekday: "1,2,3,4,5")!
		let description = cronExpression.description
		let expectedDescription = "Every weekday"
		XCTAssertEqual(description, expectedDescription)
	}

	func testDescriptionOfWeekend()
	{
		let cronExpression = CronExpression(minute: "0", hour: "12")!
		let description = cronExpression.description
		let expectedDescription = "Saturday, Sunday"
		XCTAssertEqual(description, expectedDescription)
	}

}
