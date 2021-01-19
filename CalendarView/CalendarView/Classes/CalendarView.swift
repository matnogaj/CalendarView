//
//  CalendarView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/29/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//  Updated to Swift 4 by A&D Progress aka verebes (c) 2018
//

import UIKit

public protocol CalendarViewDelegate {
    func calendarDidSelectDate(date: Moment)
    func calendarDidPageToDate(date: Moment)
    func calendarWillDisplay(day: DayView)
}

public class CalendarView: UIView {
    
    private struct Appearance {
        static var dayBackgroundColor = UIColor.clear
        static var daySelectedBackgroundColor = UIColor.orange
        static var todayBackgroundColor = UIColor.lightGray
        static var todayTextColor = UIColor.black
        static var dayTextColor = UIColor.black
        static var daySelectedTextColor = UIColor.white
        static var otherMonthTextColor = UIColor.lightGray
        static var otherMonthBackgroundColor = UIColor.clear
        static var weekLabelTextColor = UIColor.black
        static var dayFont = UIFont.systemFont(ofSize: 15)
    }
    
    public class var dayBackgroundColor: UIColor {
        get { return Appearance.dayBackgroundColor }
        set { Appearance.dayBackgroundColor = newValue }
    }
    public class var daySelectedBackgroundColor: UIColor {
        get { return Appearance.daySelectedBackgroundColor }
        set { Appearance.daySelectedBackgroundColor = newValue }
    }
    public class var todayBackgroundColor: UIColor {
        get { return Appearance.todayBackgroundColor }
        set { Appearance.todayBackgroundColor = newValue }
    }
    public class var todayTextColor: UIColor {
        get { return Appearance.todayTextColor }
        set { Appearance.todayTextColor = newValue }
    }
    public class var dayTextColor: UIColor {
        get { return Appearance.dayTextColor }
        set { Appearance.dayTextColor = newValue }
    }
    public class var daySelectedTextColor: UIColor {
        get { return Appearance.daySelectedTextColor }
        set { Appearance.daySelectedTextColor = newValue }
    }
    public class var otherMonthTextColor: UIColor {
        get { return Appearance.otherMonthTextColor }
        set { Appearance.otherMonthTextColor = newValue }
    }
    public class var otherMonthBackgroundColor: UIColor {
        get { return Appearance.otherMonthBackgroundColor }
        set { Appearance.otherMonthBackgroundColor = newValue }
    }
    public class var weekLabelTextColor: UIColor {
        get { return Appearance.weekLabelTextColor }
        set { Appearance.weekLabelTextColor = newValue }
    }
    public class var dayFont: UIFont {
        get { return Appearance.dayFont }
        set { Appearance.dayFont = newValue }
    }
    
    lazy var contentView: ContentView = {
        let cv = ContentView(dayType: self.dayType)
        cv.delegate = self
        self.addSubview(cv)
        return cv
    }()
    public var delegate: CalendarViewDelegate? {
        didSet {
            delegate?.calendarDidPageToDate(date: contentView.currentMonth().date)
            reloadContent()
        }
    }

    private let dayType: DayView.Type

    public init(dayType: DayView.Type = DayView.self) {
        self.dayType = dayType
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self)
            contentView.removeObservers()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(dateSelected(notification:)), name: NSNotification.Name(rawValue: CalendarSelectedDayNotification), object: nil)
        }
    }
    
    func setup() {
        if let date = contentView.selectedDate {
            contentView.selectVisibleDate(date: date.day)
            delegate?.calendarDidSelectDate(date: moment(moment: date))
            contentView.selectedDate = nil
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        contentView.contentOffset.x = contentView.frame.width
    }
    
    @objc func dateSelected(notification: NSNotification) {
        if let date = notification.object as? Date {
            delegate?.calendarDidSelectDate(date: moment(date: date))
        }
    }
    
    public func selectDate(date: Moment) {
        contentView.selectDate(date: date)
    }

    private func reloadContent() {
        contentView.months
            .flatMap { $0.weeks }
            .flatMap { $0.days }
            .forEach { [weak self] dayView in
                self?.delegate?.calendarWillDisplay(day: dayView)
        }
    }

    public func nextPage() {
        guard contentView.paged else { return }
        goTo(page: 2)
    }

    public func previousPage() {
        guard contentView.paged else { return }
        goTo(page: 0)
    }

    private func goTo(page: Int) {
        var frame = contentView.frame
        frame.origin.x = frame.size.width * page
        frame.origin.y = 0
        contentView.scrollRectToVisible(frame, animated: true)
    }
}

extension CalendarView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.paged = false
        let ratio = contentView.contentOffset.x / contentView.frame.width
        if ratio.isNaN { return }
        if ratio >= 2.0 || ratio <= 0.0 {
            contentView.selectPage(page: Int(ratio))
        } else if ratio == 1.0 && !contentView.isDecelerating && !contentView.isDragging {
            contentView.paged = true
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentView.setContentOffset(CGPoint(x: contentView.frame.width, y: contentView.contentOffset.y), animated: true)
        delegate?.calendarDidPageToDate(date: contentView.currentMonth().date)
        reloadContent()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(contentView)
    }
}
