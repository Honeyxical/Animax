import UIKit
import SnapKit

final class ReleaseCalendarViewController: BaseViewController {

    private var selectedDate: Date = Date()
    private var weekDates: [Date] = []

    // MARK: - UI

    private let dayPickerScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        return sv
    }()

    private let dayPickerStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    private let emptyStateView = UIView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buildWeekDates()
        buildDayPicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Private

private extension ReleaseCalendarViewController {

    func buildWeekDates() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        // Show 14 days: 3 before today + today + 10 after
        weekDates = (-3...10).compactMap { cal.date(byAdding: .day, value: $0, to: today) }
        selectedDate = today
    }

    func buildDayPicker() {
        dayPickerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        for date in weekDates {
            let isSelected = cal.isDate(date, inSameDayAs: selectedDate)
            let cell = makeDayCell(date: date, isSelected: isSelected, isToday: cal.isDate(date, inSameDayAs: today))
            dayPickerStack.addArrangedSubview(cell)
        }

        // Scroll to today
        let todayIndex = weekDates.firstIndex(where: { cal.isDate($0, inSameDayAs: today) }) ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let offset = CGFloat(todayIndex) * 68 - 24
            let maxOffset = self?.dayPickerScrollView.contentSize.width ?? 0
            let clampedOffset = max(0, min(offset, maxOffset))
            self?.dayPickerScrollView.setContentOffset(CGPoint(x: clampedOffset, y: 0), animated: false)
        }
    }

    func makeDayCell(date: Date, isSelected: Bool, isToday: Bool) -> UIView {
        let cal = Calendar.current
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        let dayName = String(dayFormatter.string(from: date).prefix(3))
        let dayNum = cal.component(.day, from: date)

        let container = UIView()
        container.snp.makeConstraints { make in make.width.equalTo(60) }

        let pill = UIView()
        pill.layer.cornerRadius = 28
        pill.backgroundColor = isSelected ? Colors.Primary.primary : .clear
        if !isSelected {
            pill.layer.borderWidth = 1.5
            pill.layer.borderColor = Colors.Grayscale.gray200.cgColor
        }

        let dayLabel = UILabel()
        dayLabel.text = dayName
        dayLabel.font = Typography.Body.Regular.small
        dayLabel.textColor = isSelected ? Colors.Others.white : Colors.Grayscale.gray500
        dayLabel.textAlignment = .center

        let numLabel = UILabel()
        numLabel.text = "\(dayNum)"
        numLabel.font = isSelected ? Typography.Body.Bold.large : Typography.Body.Regular.large
        numLabel.textColor = isSelected ? Colors.Others.white : Colors.Grayscale.gray700
        numLabel.textAlignment = .center

        container.addSubview(pill)
        pill.addSubview(dayLabel)
        pill.addSubview(numLabel)

        pill.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(56)
            make.height.equalTo(72)
        }
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        numLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }

        // Tap handler
        let tap = UITapGestureRecognizer(target: self, action: #selector(dayTapped(_:)))
        pill.addGestureRecognizer(tap)
        pill.isUserInteractionEnabled = true
        pill.tag = weekDates.firstIndex(of: date) ?? 0

        return container
    }

    @objc func dayTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag, tag < weekDates.count else { return }
        selectedDate = weekDates[tag]
        buildDayPicker()
        // For now always show empty state
        // If real data were loaded, toggle here
    }

    func buildEmptyState() {
        // Illustration: sad face circle + decorative elements
        let circleView = UIView()
        circleView.backgroundColor = Colors.Primary.primary
        circleView.layer.cornerRadius = 80

        let sadFaceView = UIImageView()
        sadFaceView.image = UIImage(systemName: "face.dashed")?.withRenderingMode(.alwaysTemplate)
        sadFaceView.tintColor = Colors.Dark.dark1
        sadFaceView.contentMode = .scaleAspectFit

        circleView.addSubview(sadFaceView)
        sadFaceView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }

        let titleLabel = UILabel()
        titleLabel.text = "No Release Schedule"
        titleLabel.font = Typography.Heading.heading5
        titleLabel.textColor = Colors.Primary.primary
        titleLabel.textAlignment = .center

        let bodyLabel = UILabel()
        bodyLabel.text = "Sorry, there is no anime release schedule\non this date"
        bodyLabel.font = Typography.Body.Regular.medium
        bodyLabel.textColor = Colors.Grayscale.gray500
        bodyLabel.textAlignment = .center
        bodyLabel.numberOfLines = 0

        emptyStateView.addSubview(circleView)
        emptyStateView.addSubview(titleLabel)
        emptyStateView.addSubview(bodyLabel)

        circleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.height.equalTo(160)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }

    func setup() {
        view.backgroundColor = .white

        // Navigation bar: Animax logo left + title + "..." right
        let logoButton = UIButton(type: .system)
        let logoAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.Primary.primary,
            .font: UIFont.systemFont(ofSize: 22, weight: .heavy)
        ]
        logoButton.setAttributedTitle(NSAttributedString(string: "A", attributes: logoAttrs), for: .normal)
        logoButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(customView: logoButton),
            UIBarButtonItem(title: "Release Calendar", style: .plain, target: nil, action: nil)
        ]
        navigationItem.leftItemsSupplementBackButton = false

        // Override title to right of logo
        let titleLabel = UILabel()
        titleLabel.text = "Release Calendar"
        titleLabel.font = Typography.Heading.heading5
        titleLabel.textColor = Colors.Grayscale.gray900
        let logoBar = UIView()
        let logoIcon = UILabel()
        logoIcon.text = "A"
        logoIcon.font = .systemFont(ofSize: 22, weight: .heavy)
        logoIcon.textColor = Colors.Primary.primary
        logoBar.addSubview(logoIcon)
        logoBar.addSubview(titleLabel)
        logoIcon.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoIcon.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        logoBar.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoBar)

        let moreButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: nil,
            action: nil
        )
        moreButton.tintColor = Colors.Grayscale.gray700
        navigationItem.rightBarButtonItem = moreButton

        buildEmptyState()

        view.addSubview(dayPickerScrollView)
        dayPickerScrollView.addSubview(dayPickerStack)
        view.addSubview(emptyStateView)

        dayPickerScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(88)
        }
        dayPickerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            make.height.equalTo(dayPickerScrollView)
        }
        emptyStateView.snp.makeConstraints { make in
            make.top.equalTo(dayPickerScrollView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
