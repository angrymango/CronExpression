//
//  DateBuilder.swift
//  SwiftCronExample
//
//  Created by Keegan Rush on 2016/09/22.
//  Copyright © 2016 Rush42. All rights reserved.
//

import Foundation

class DateBuilder {
    
    var month: Int?
    var year: Int?
    
    func build() -> Date {
        let components = DateComponents(calendar: NSCalendar.current, year: year, month: month)
        return components.date!
    }
    
    func with(year: Int) -> DateBuilder {
        self.year = year
        return self
    }
    
    func with(month: Int) -> DateBuilder {
        self.month = month
        return self
    }
    
}
