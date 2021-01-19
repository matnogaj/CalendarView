import UIKit
import CalendarView

class ViewController: UIViewController {

    private let calendarView: CalendarView = {
        let calendarView = CalendarView(dayType: MyDayView.self)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    private let previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Previous", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        calendarView.delegate = self
        setupView()

        previousButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
    }

    private func setupView() {
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(calendarView)

        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previousButton.bottomAnchor.constraint(equalTo: calendarView.topAnchor),

            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: calendarView.topAnchor),

            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }

    @objc private func nextMonth() {
        calendarView.nextPage()
    }

    @objc private func previousMonth() {
        calendarView.previousPage()
    }
}

extension ViewController: CalendarViewDelegate {

    func calendarDidSelectDate(date: Moment) {
    }

    func calendarDidPageToDate(date: Moment) {
        print("\(date.description)")
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateView() {
        super.updateView()
    }
}
