//
//  DayView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/29/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//  Updated to Swift 4 by A&D Progress aka verebes (c) 2018
//

import UIKit

let CalendarSelectedDayNotification = "CalendarSelectedDayNotification"

open class DayView: UIView {
    
    public internal(set) var date: Moment = moment() {
        didSet {
            dateLabel.text = date.format(dateFormat: "d")
            setNeedsLayout()
        }
    }
    lazy public internal(set) var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = CalendarView.dayFont
        self.addSubview(label)
        return label
    }()
    public internal(set) var isToday: Bool = false
    public internal(set) var isOtherMonth: Bool = false
    public internal(set) var selected: Bool = false {
        didSet {
            if selected {
                NotificationCenter.default
                    .post(name: NSNotification.Name(rawValue: CalendarSelectedDayNotification), object: date.toDate())
            }
            updateView()
        }
    }

    private let padding: CGFloat
    
    required public init(padding: CGFloat = 10) {
        self.padding = padding
        super.init(frame: .zero)
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectIt))
        addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onSelected(notification:)),
                                               name: NSNotification.Name(rawValue: CalendarSelectedDayNotification),
                                               object: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.frame = bounds.insetBy(dx: padding, dy: padding)
        updateView()
    }
    
    @objc func onSelected(notification: NSNotification) {
        if let nsDate = notification.object as? Date {
            let mo = moment(date: nsDate)
            if mo.month != date.month || mo.day != date.day {
                selected = false
            }
        }
    }
    
    open func updateView() {
        if self.selected {
            dateLabel.textColor = CalendarView.daySelectedTextColor
            dateLabel.backgroundColor = CalendarView.daySelectedBackgroundColor
        } else if isToday {
            dateLabel.textColor = CalendarView.todayTextColor
            dateLabel.backgroundColor = CalendarView.todayBackgroundColor
        } else if isOtherMonth {
            dateLabel.textColor = CalendarView.otherMonthTextColor
            dateLabel.backgroundColor = CalendarView.otherMonthBackgroundColor
        } else {
            self.dateLabel.textColor = CalendarView.dayTextColor
            self.dateLabel.backgroundColor = CalendarView.dayBackgroundColor
        }
    }
    
    @objc func selectIt() {
        selected = true
    }
    
}

public extension Moment {
    
    func toDate() -> Date? {
        let epoch = moment(date: Date(timeIntervalSince1970: 0))
        let timeInterval = self.intervalSince(epoch)
        let date = Date(timeIntervalSince1970: timeInterval.seconds)
        return date
    }
    
    func isToday() -> Bool {
        let cal = Calendar.current
        return cal.isDateInToday(self.toDate()!)
    }
    
    func isSameMonth(other: Moment) -> Bool {
        return self.month == other.month && self.year == other.year
    }
    
}
