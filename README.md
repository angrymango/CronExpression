SwiftCron
==============
[![Build Status](https://travis-ci.org/TheCodedSelf/SwiftCron.svg?branch=master)](https://travis-ci.org/TheCodedSelf/SwiftCron) [![codecov](https://codecov.io/gh/TheCodedSelf/SwiftCron/branch/master/graph/badge.svg)](https://codecov.io/gh/TheCodedSelf/SwiftCron) [![CocoaPod Version](https://img.shields.io/cocoapods/v/SwiftCron.svg)](http://cocoapods.org/pods/SwiftCron)

A cron expression parser that can take a cron string and give you the next run date and time specified in the string.

<br/>

## Installation
### CocoaPods

Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'SwiftCron'
```

### Carthage

Cartfile:

```
github "thecodedself/swiftcron" >= 0.4.5
```

### Swift Package Manager

Package.swift:

```
.Package(url: "https://github.com/TheCodedSelf/SwiftCron.git", majorVersion: 0)
```

Usage
--------
##### Create a Cron Expression
Creating a cron expression is easy. Just invoke the initializer with the fields you want.
```swift
// Midnight every 8th day of the month
let myCronExpression = CronExpression(minute: "0", hour: "0", day: "8")
```
```swift
// Executes May 9th, 2024 at 11:30am
let anotherExpression = CronExpression(minute: "30", hour: "11", day: "9", month: "5", year: "2024") 
```
```swift
// Every tuesday at 6:00pm
let everyTuesday = CronExpression(minute: "0", hour: "18", weekday: "3")
```

<br/>

##### Manually create an expression

If you'd like to manually write the expression yourself, The cron format is as follows:

> \* \* \* \* \* \*
<br/>(Minute) (Hour) (Day) (Month) (Weekday) (Year)

Initialize an instance of CronExpression with a string specifying the format.

```swift
// Every 11th May at midnight
let every11May = CronExpression(cronString: "0 0 11 5 * *")
```

<br/>

##### Get the next run date

Once you have your CronExpression, you can get the next time the cron will run. Call the getNextRunDate(_:) method and pass in the date to begin the search on.

```swift
// Every Friday 13th at midday
let myCronExpression = CronExpression(minute: "0", hour: "12", day: "13", weekday: "5")

let dateToStartSearchOn = NSDate()
let nextRunDate = myCronExpression.getNextRunDate(dateToStartSearchOn)
```

## Contributing

- Pull requests for bug fixes and new features are most welcome.
- Pull requests will only be merged once the Travis CI build passes.

## Requirements

- iOS 9.0 or greater
- Xcode 8.0 or greater
- Swift 3 or greater
