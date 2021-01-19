//
//  CalendarContentView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/29/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//  Updated to Swift 4 by A&D Progress aka verebes (c) 2018
//

import UIKit

class ContentView: UIScrollView {
    
    let numMonthsLoaded = 3
    let currentPage = 1
    var months: [MonthView] = []
    var selectedDate: Moment?
    var paged = true

    private let dayType: DayView.Type
    
    init(dayType: DayView.Type = DayView.self) {
        self.dayType = dayType
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        for month in months {
            month.setdown()
            month.removeFromSuperview()
        }
        
        months = []
        let date = selectedDate ?? moment()
        selectedDate = date
        var currentDate = date.subtract(1, .months)
        for _ in 1...numMonthsLoaded {
            let month = MonthView(dayType: dayType)
            month.date = currentDate
            addSubview(month)
            months.append(month)
            currentDate = currentDate.add(1, .months)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 0
        for month in months {
            month.frame = CGRect(x: x, y: 0, width: bounds.size.width, height: bounds.size.height)
            x = month.frame.maxX
        }
        contentSize = CGSize(width: bounds.size.width * numMonthsLoaded, height: bounds.size.height)
    }
    
    func selectPage(page: Int) {
        var page1FrameMatched = false
        var page2FrameMatched = false
        var page3FrameMatched = false
        var frameCurrentMatched = false
        
        let pageWidth = frame.size.width
        let pageHeight = frame.size.height
        
        let frameCurrent = CGRect(x: page * pageWidth, y: 0, width: pageWidth, height: pageHeight)
        let frameLeft = CGRect(x: (page-1) * pageWidth, y: 0, width: pageWidth, height: pageHeight)
        let frameRight = CGRect(x: (page+1) * pageWidth, y: 0, width: pageWidth, height: pageHeight)
        
        let page1 = months.first!
        let page2 = months[1]
        let page3 = months.last!
        
        if frameCurrent.origin.x == page1.frame.origin.x {
            page1FrameMatched = true
            frameCurrentMatched = true
        }
        else if frameCurrent.origin.x == page2.frame.origin.x {
            page2FrameMatched = true
            frameCurrentMatched = true
        }
        else if frameCurrent.origin.x == page3.frame.origin.x {
            page3FrameMatched = true
            frameCurrentMatched = true
        }
        
        if frameCurrentMatched {
            if page2FrameMatched {
                print("something weird happened")
            }
            else if page1FrameMatched {
                page3.date = page1.date.subtract(1, .months)
                page1.frame = frameCurrent
                page2.frame = frameRight
                page3.frame = frameLeft
                months = [page3, page1, page2]
            }
            else if page3FrameMatched {
                page1.date = page3.date.add(1, .months)
                page1.frame = frameRight
                page2.frame = frameLeft
                page3.frame = frameCurrent
                months = [page2, page3, page1]
            }
            contentOffset.x = frame.width
            selectedDate = nil
            paged = true
        }
    }
    
    func selectDate(date: Moment) {
        selectedDate = date
        setup()
        selectVisibleDate(date: date.day)
        setNeedsLayout()
    }
    
    @discardableResult func selectVisibleDate(date: Int) -> DayView? {
        let month = currentMonth()
        for week in month.weeks {
            for day in week.days {
                if day.date.month == month.date.month && day.date.day == date {
                    day.selected = true
                    return day
                }
            }
        }
        return nil
    }
    
    func removeObservers() {
        for month in months {
            for week in month.weeks {
                for day in week.days {
                    NotificationCenter.default.removeObserver(day)
                }
            }
        }
    }
    
    func currentMonth() -> MonthView {
        return months[1]
    }
    
}
