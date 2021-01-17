//
//  CalendarViewTests.swift
//  CalendarViewTests
//
//  Created by Nate Armstrong on 10/12/15.
//  Copyright © 2015 Nate Armstrong. All rights reserved.
//

import XCTest
@testable import CalendarView

class CalendarViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNovember2015Bug() {
        let october = moment(stringDate: "10-12-2015")!
        XCTAssertEqual("October 12, 2015", october.format(dateFormat: "MMMM d, yyyy"))
        let november = october.add(1, .months)
        let date = november.startOf(.months)
        XCTAssertEqual(1, date.day)
        let date2 = date.endOf(.days).add(1, .days)
        XCTAssertEqual(2, date2.day)
    }

    // See: https://github.com/n8armstrong/CalendarView/issues/7
    func testSecondSundayInMarchBug() {
        let marchFirst = moment(stringDate: "3-1-2016")!
        let firstVisibleDay = marchFirst.startOf(.months).endOf(.days).subtract(marchFirst.weekday - 1, .days).startOf(.days)
        XCTAssertEqual("February 28, 2016", firstVisibleDay.format(dateFormat: "MMMM d, yyyy"))
        let dayInQuestion = firstVisibleDay.add(14, .days)
        XCTAssertEqual(13, dayInQuestion.day)
    }

}
