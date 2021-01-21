import UIKit
import CalendarView

class ViewController: UIViewController {

    private let calendarView: CalendarView = {
        CalendarView.weekLabelTextColor = UIColor.blue
        CalendarView.daySelectedTextColor = UIColor.white
        CalendarView.daySelectedBackgroundColor = UIColor.blue

        CalendarView.dayTextColor = UIColor.blue
        CalendarView.todayTextColor = UIColor.blue

        CalendarView.dayBackgroundColor = UIColor.white
        CalendarView.todayBackgroundColor = UIColor.white

        let calendarView = CalendarView(dayType: MyDayView.self)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    private let previousMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Previous Month", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    private let nextMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next Month", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    private let previousDayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Previous Day", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    private let nextDayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next Day", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        calendarView.delegate = self
        calendarView.selectDate(date: moment())
        setupView()

        previousMonthButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        previousDayButton.addTarget(self, action: #selector(previousDay), for: .touchUpInside)
        nextDayButton.addTarget(self, action: #selector(nextDay), for: .touchUpInside)
    }

    private func setupView() {
        view.addSubview(previousMonthButton)
        view.addSubview(nextMonthButton)
        view.addSubview(previousDayButton)
        view.addSubview(nextDayButton)
        view.addSubview(calendarView)

        NSLayoutConstraint.activate([
            previousDayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previousDayButton.bottomAnchor.constraint(equalTo: previousMonthButton.topAnchor, constant: -10),

            nextDayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextDayButton.bottomAnchor.constraint(equalTo: nextMonthButton.topAnchor, constant: -10),

            previousMonthButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previousMonthButton.bottomAnchor.constraint(equalTo: calendarView.topAnchor),

            nextMonthButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextMonthButton.bottomAnchor.constraint(equalTo: calendarView.topAnchor),

            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }

    @objc private func nextMonth() {
        calendarView.goToNextMonth()
    }

    @objc private func previousMonth() {
        calendarView.goToPreviousMonth()
    }

    @objc private func nextDay() {
        calendarView.selectNextDay()
    }

    @objc private func previousDay() {
        calendarView.selectPreviousDay()
    }
}

extension ViewController: CalendarViewDelegate {

    func calendarDidSelectDate(date: Moment) {
        print("Selected: \(date.description)")
    }

    func calendarDidPageToDate(date: Moment) {
        print("Paged: \(date.description)")
    }

    func calendarWillDisplay(day: DayView) {
        day.isHidden = day.isOtherMonth

        if day.date.month == day.date.day {
            day.dateLabel.layer.borderColor = UIColor.blue.cgColor
            day.dateLabel.layer.borderWidth = 1
        } else {
            day.dateLabel.layer.borderColor = UIColor.clear.cgColor
            day.dateLabel.layer.borderWidth = 0
        }
    }
}

class MyDayView: DayView {

    required init(padding: CGFloat) {
        super.init(padding: 5)

        self.dateLabel.layer.cornerRadius = 10
        self.dateLabel.layer.masksToBounds = true

        self.dateLabel.layer.shadowColor = UIColor.clear.cgColor
        self.dateLabel.layer.shadowOpacity = 0
        self.dateLabel.layer.shadowRadius = 0
        self.dateLabel.layer.borderWidth = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateView() {
        super.updateView()
    }
}
