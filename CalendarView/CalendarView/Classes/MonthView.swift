//
//  MonthView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/29/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//  Updated to Swift 4 by A&D Progress aka verebes (c) 2018
//

import UIKit

class MonthView: UIView {

    let maxNumWeeks = 6

    var date: Moment = moment() {
        didSet {
            startsOn = date.startOf(.months).weekday // Sun is 1
            let numDays = Double(date.endOf(.months).day + startsOn - 1)
            self.numDays = Int(ceil(numDays / 7.0) * 7)
            self.numDays = 42 // TODO: add option to always show 6 weeks
            setWeeks()
        }
    }

    var weeks: [WeekView] = []
    var weekLabels: [WeekLabel] = [
        WeekLabel(day: "SUN"),
        WeekLabel(day: "MON"),
        WeekLabel(day: "TUE"),
        WeekLabel(day: "WED"),
        WeekLabel(day: "THU"),
        WeekLabel(day: "FRI"),
        WeekLabel(day: "SAT"),
    ]

    // these values are expensive to compute so cache them
    var numDays: Int = 30
    var startsOn: Int = 0

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
        weeks = []
        for _ in 1...maxNumWeeks {
            let week = WeekView(dayType: dayType)
            addSubview(week)
            weeks.append(week)
        }
        for label in weekLabels {
            addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 0
        let labelHeight: CGFloat = 18
        let inset: CGFloat = 10
        for label in weekLabels {
            label.frame = CGRect(x: x, y: inset, width: floor(bounds.size.width / 7), height: labelHeight)
            x = label.frame.maxX
        }
        var y: CGFloat = labelHeight + inset
        for i in 1...weeks.count {
            let week = weeks[i - 1]
            let height = (bounds.size.height - (labelHeight + inset) - inset) / maxNumWeeks
            week.frame = CGRect(x: 0, y: y, width: bounds.size.width, height: floor(height))
            y = week.frame.maxY
        }
    }

    func setWeeks() {
        if weeks.count > 0 {
            let numWeeks = Int(numDays / 7)
            let firstVisibleDate  = date.startOf(.months).endOf(.days).subtract(startsOn - 1, .days).startOf(.days)
            for i in 1...weeks.count {
                let firstDateOfWeek = firstVisibleDate.add(7*(i-1), .days)
                let week = weeks[i - 1]
                week.month = date
                week.date = firstDateOfWeek
                week.isHidden = i > numWeeks
            }
        }
    }

}

class WeekLabel: UILabel {

    init(day: String) {
        super.init(frame: CGRect.zero)
        text = day
        textAlignment = .center
        textColor = CalendarView.weekLabelTextColor
        font = CalendarView.weekFont
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

}
