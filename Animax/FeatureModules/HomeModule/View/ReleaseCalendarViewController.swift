import UIKit
import SnapKit
import Kingfisher

// MARK: - Models

private struct CalendarAnimeItem {
    let id: Int
    let title: String
    let imageURL: String?
    let episodesCount: Int
    let time: String
}

private enum CalendarRow {
    case timeHeader(String)
    case anime(Int)
    case currentTimeDivider
}

// MARK: - ReleaseCalendarViewController

final class ReleaseCalendarViewController: BaseViewController {

    private var selectedDate = Date()
    private var weekDates: [Date] = []
    private var inListSet: Set<Int> = []
    private var filteredItems: [CalendarAnimeItem] = []
    private var tableRows: [CalendarRow] = []

    private let mockItems: [CalendarAnimeItem] = [
        CalendarAnimeItem(id: 21, title: "One Piece",
                          imageURL: "https://cdn.myanimelist.net/images/anime/6/73245l.jpg",
                          episodesCount: 1080, time: "00:30"),
        CalendarAnimeItem(id: 40748, title: "Jujutsu Kaisen Season 2",
                          imageURL: "https://cdn.myanimelist.net/images/anime/1792/138022l.jpg",
                          episodesCount: 12, time: "12:00"),
        CalendarAnimeItem(id: 40456, title: "The Rising of The Shield Hero Season 2",
                          imageURL: "https://cdn.myanimelist.net/images/anime/1245/111328l.jpg",
                          episodesCount: 20, time: "20:30"),
        CalendarAnimeItem(id: 39587, title: "Date a Live Season IV",
                          imageURL: "https://cdn.myanimelist.net/images/anime/1441/122222l.jpg",
                          episodesCount: 13, time: "22:00"),
    ]

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

    private let dividerLine: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray200
        return v
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        tv.dataSource = self
        tv.register(CalendarTimeHeaderCell.self, forCellReuseIdentifier: CalendarTimeHeaderCell.reuseId)
        tv.register(CalendarAnimeCell.self, forCellReuseIdentifier: CalendarAnimeCell.reuseId)
        tv.register(CalendarDividerCell.self, forCellReuseIdentifier: CalendarDividerCell.reuseId)
        return tv
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buildWeekDates()
        buildDayPicker()
        reloadForSelectedDate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UITableViewDataSource

extension ReleaseCalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableRows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableRows[indexPath.row] {
        case .timeHeader(let time):
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTimeHeaderCell.reuseId, for: indexPath) as! CalendarTimeHeaderCell
            cell.configure(time: time)
            return cell

        case .anime(let idx):
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarAnimeCell.reuseId, for: indexPath) as! CalendarAnimeCell
            let item = filteredItems[idx]
            cell.configure(with: item, isInList: inListSet.contains(item.id))
            cell.onToggleList = { [weak self] in
                guard let self = self else { return }
                if self.inListSet.contains(item.id) { self.inListSet.remove(item.id) }
                else { self.inListSet.insert(item.id) }
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            return cell

        case .currentTimeDivider:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarDividerCell.reuseId, for: indexPath) as! CalendarDividerCell
            cell.configure()
            return cell
        }
    }
}

// MARK: - Private

private extension ReleaseCalendarViewController {
    func buildWeekDates() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        weekDates = (-3...10).compactMap { cal.date(byAdding: .day, value: $0, to: today) }
        selectedDate = today
    }

    func buildDayPicker() {
        dayPickerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        for date in weekDates {
            let isSelected = cal.isDate(date, inSameDayAs: selectedDate)
            let isToday = cal.isDate(date, inSameDayAs: today)
            dayPickerStack.addArrangedSubview(makeDayCell(date: date, isSelected: isSelected, isToday: isToday))
        }

        let todayIndex = weekDates.firstIndex(where: { cal.isDate($0, inSameDayAs: today) }) ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            let offset = CGFloat(todayIndex) * 68 - 24
            let maxOffset = max(0, self.dayPickerScrollView.contentSize.width - self.dayPickerScrollView.bounds.width)
            self.dayPickerScrollView.setContentOffset(CGPoint(x: max(0, min(offset, maxOffset)), y: 0), animated: false)
        }
    }

    func makeDayCell(date: Date, isSelected: Bool, isToday: Bool) -> UIView {
        let cal = Calendar.current
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE"
        let dayName = String(fmt.string(from: date).prefix(3))
        let dayNum = cal.component(.day, from: date)

        let container = UIView()
        container.snp.makeConstraints { $0.width.equalTo(60) }

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

        pill.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(56)
            $0.height.equalTo(72)
        }
        dayLabel.snp.makeConstraints { $0.top.equalToSuperview().offset(10); $0.centerX.equalToSuperview() }
        numLabel.snp.makeConstraints { $0.bottom.equalToSuperview().inset(10); $0.centerX.equalToSuperview() }

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
        reloadForSelectedDate()
    }

    func reloadForSelectedDate() {
        let cal = Calendar.current
        let isToday = cal.isDateInToday(selectedDate)
        let dayOffset = cal.dateComponents([.day], from: cal.startOfDay(for: Date()), to: selectedDate).day ?? 0

        filteredItems = (dayOffset >= -1 && dayOffset <= 2) ? mockItems : []

        tableRows = []
        guard !filteredItems.isEmpty else { tableView.reloadData(); return }

        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm"
        let now = fmt.string(from: Date())
        var dividerInserted = false

        for (idx, item) in filteredItems.enumerated() {
            if isToday && !dividerInserted && item.time > now {
                tableRows.append(.currentTimeDivider)
                dividerInserted = true
            }
            tableRows.append(.timeHeader(item.time))
            tableRows.append(.anime(idx))
        }
        if isToday && !dividerInserted {
            tableRows.append(.currentTimeDivider)
        }

        tableView.reloadData()
    }

    func setup() {
        view.backgroundColor = .white

        let logoBar = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 36))
        let logoIcon = UILabel()
        logoIcon.text = "A"
        logoIcon.font = .systemFont(ofSize: 22, weight: .heavy)
        logoIcon.textColor = Colors.Primary.primary
        let navTitle = UILabel()
        navTitle.text = "Release Calendar"
        navTitle.font = Typography.Heading.heading5
        navTitle.textColor = Colors.Grayscale.gray900
        logoBar.addSubview(logoIcon)
        logoBar.addSubview(navTitle)
        logoIcon.snp.makeConstraints { $0.leading.centerY.equalToSuperview() }
        navTitle.snp.makeConstraints {
            $0.leading.equalTo(logoIcon.snp.trailing).offset(8)
            $0.centerY.trailing.equalToSuperview()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoBar)

        let moreBtn = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil)
        moreBtn.tintColor = Colors.Grayscale.gray700
        navigationItem.rightBarButtonItem = moreBtn

        view.addSubview(dayPickerScrollView)
        dayPickerScrollView.addSubview(dayPickerStack)
        view.addSubview(dividerLine)
        view.addSubview(tableView)

        dayPickerScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(88)
        }
        dayPickerStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            $0.height.equalTo(dayPickerScrollView)
        }
        dividerLine.snp.makeConstraints {
            $0.top.equalTo(dayPickerScrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(dividerLine.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - CalendarTimeHeaderCell

private final class CalendarTimeHeaderCell: UITableViewCell {
    static let reuseId = "CalendarTimeHeaderCell"

    private let dotView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Primary.primary
        v.layer.cornerRadius = 5
        return v
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Semibold.small
        l.textColor = Colors.Primary.primary
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        contentView.addSubview(dotView)
        contentView.addSubview(timeLabel)
        dotView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(10)
        }
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(dotView.snp.trailing).offset(10)
            $0.top.bottom.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }
    func configure(time: String) { timeLabel.text = time }
}

// MARK: - CalendarAnimeCell

private final class CalendarAnimeCell: UITableViewCell {
    static let reuseId = "CalendarAnimeCell"
    var onToggleList: (() -> Void)?

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = Colors.Grayscale.gray200
        return iv
    }()

    private let playOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        v.layer.cornerRadius = 12
        return v
    }()

    private let playIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "play.circle.fill"))
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Bold.medium
        l.textColor = Colors.Grayscale.gray900
        l.numberOfLines = 2
        return l
    }()

    private let episodesLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.small
        l.textColor = Colors.Grayscale.gray500
        return l
    }()

    private lazy var myListButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = Typography.Body.Semibold.small
        btn.addTarget(self, action: #selector(myListTapped), for: .touchUpInside)
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(playOverlay)
        playOverlay.addSubview(playIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(episodesLabel)
        contentView.addSubview(myListButton)

        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
            $0.width.equalTo(120)
            $0.height.equalTo(84)
        }
        playOverlay.snp.makeConstraints { $0.edges.equalToSuperview() }
        playIcon.snp.makeConstraints { $0.center.equalToSuperview(); $0.width.height.equalTo(28) }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView).offset(4)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(myListButton.snp.leading).offset(-8)
        }
        episodesLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(titleLabel)
        }
        myListButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(90)
            $0.height.equalTo(30)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        onToggleList = nil
    }

    func configure(with item: CalendarAnimeItem, isInList: Bool) {
        titleLabel.text = item.title
        episodesLabel.text = "Episodes \(item.episodesCount)"
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
        if isInList {
            myListButton.setTitle("✓ My List", for: .normal)
            myListButton.setTitleColor(Colors.Primary.primary, for: .normal)
            myListButton.backgroundColor = .white
            myListButton.layer.borderWidth = 1.5
            myListButton.layer.borderColor = Colors.Primary.primary.cgColor
        } else {
            myListButton.setTitle("+ My List", for: .normal)
            myListButton.setTitleColor(.white, for: .normal)
            myListButton.backgroundColor = Colors.Primary.primary
            myListButton.layer.borderWidth = 0
            myListButton.layer.borderColor = UIColor.clear.cgColor
        }
    }

    @objc private func myListTapped() { onToggleList?() }
}

// MARK: - CalendarDividerCell

private final class CalendarDividerCell: UITableViewCell {
    static let reuseId = "CalendarDividerCell"

    private let lineLeft = UIView()
    private let lineRight = UIView()
    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.xSmall
        l.textColor = Colors.Primary.primary
        l.textAlignment = .center
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        lineLeft.backgroundColor = Colors.Primary.primary
        lineRight.backgroundColor = Colors.Primary.primary

        contentView.addSubview(lineLeft)
        contentView.addSubview(timeLabel)
        contentView.addSubview(lineRight)

        timeLabel.snp.makeConstraints { $0.center.equalToSuperview(); $0.top.bottom.equalToSuperview().inset(6) }
        lineLeft.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(timeLabel.snp.leading).offset(-8)
            $0.height.equalTo(1)
        }
        lineRight.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(timeLabel.snp.trailing).offset(8)
            $0.height.equalTo(1)
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure() {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm"
        timeLabel.text = "Current Time - \(fmt.string(from: Date()))"
    }
}
