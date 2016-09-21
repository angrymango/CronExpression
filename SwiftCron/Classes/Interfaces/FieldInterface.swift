//
//  FieldCheckerInterface.swift
//  SwiftCron
//
//  Created by Keegan Rush on 2016/05/05.
//  Copyright © 2016 Rush42. All rights reserved.
//

import Foundation

protocol FieldCheckerInterface {
	/**
	 * Check if the respective value of a DateTime field satisfies a CRON exp
	 *
	 * @param DateTime date DateTime object to check
	 * @param string value CRON expression to test against
	 *
	 * @return bool Returns TRUE if satisfied, FALSE otherwise
	 */
	func isSatisfiedBy(_ date: Date, value: String) -> Bool

	/**
	 * When a CRON expression is not satisfied, this method is used to increment
	 * a DateTime object by the unit of the cron field
	 *
	 * @param DateTime date DateTime object to increment
	 *
	 * @return FieldCheckerInterface
	 */
	func increment(_ date: Date, toMatchValue: String) -> Date

	/**
	 * Validates a CRON expression for a given field
	 *
	 * @param string value CRON expression value to validate
	 *
	 * @return bool Returns TRUE if valid, FALSE otherwise
	 */
	func validate(_ value: String) -> Bool
}
