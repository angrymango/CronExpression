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
    
    func testEverySecondAndEveryFourthHourOfDay() {
        let dateToTestFrom = TestData.may15_2016
        
        let everySecondAndFourthHourOfDayCron = CronExpression(minute: "0", hour: "2,4")!
        
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.day, .year, .month, .hour], from: dateToTestFrom)
        components.hour! += 2
        let expectedNextRunDate = calendar.date(from: components)!
        var nextRunDate = everySecondAndFourthHourOfDayCron.getNextRunDate(dateToTestFrom)!
        XCTAssertTrue((calendar as NSCalendar).isDate(nextRunDate, equalTo: expectedNextRunDate, toUnitGranularity: .hour))
        
        components.hour! += 2
        let expectedFollowingRunDate = calendar.date(from: components)!
        nextRunDate = everySecondAndFourthHourOfDayCron.getNextRunDate(addMinuteTo(date: nextRunDate))!
        XCTAssertTrue((calendar as NSCalendar).isDate(nextRunDate, equalTo: expectedFollowingRunDate, toUnitGranularity: .hour))
        
        components.hour! = 2
        components.day! += 1
        let expectedFinalRunDate = calendar.date(from: components)!
        nextRunDate = everySecondAndFourthHourOfDayCron.getNextRunDate(addMinuteTo(date: nextRunDate))!
        XCTAssertTrue((calendar as NSCalendar).isDate(nextRunDate, equalTo: expectedFinalRunDate, toUnitGranularity: .hour))
    }
    
    func addMinuteTo(date: Date) -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.day, .year, .month, .hour, .minute], from: date)
        components.minute! += 1
        return calendar.date(from: components)!
    }

}
