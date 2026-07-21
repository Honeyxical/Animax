import UIKit
import SnapKit

struct SearchFilter {
    var sort: String = "Popularity"
    var category: String = "Episode"
    var region: String = "All"
    var genre: String = "All"
    var year: String = "All"

    var activeChips: [String] {
        var chips: [String] = []
        if sort != "Popularity" { chips.append(sort) } else { chips.append("Popularity") }
        if category != "All" { chips.append(category) }
        if region != "All" { chips.append(region) }
        if genre != "All" { chips.append(genre) }
        if year != "All" { chips.append(year) }
        return chips
    }

    var isDefault: Bool {
        sort == "Popularity" && category == "Episode" && region == "All" && genre == "All" && year == "All"
    }
}

final class SortFilterViewController: BaseViewController {

    var onApply: ((SearchFilter) -> Void)?

    private var filter: SearchFilter

    // MARK: - Init

    init(filter: SearchFilter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()

    private lazy var resetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Reset", for: .normal)
        btn.setTitleColor(Colors.Primary.primary, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.large
        btn.backgroundColor = Colors.Transparent.green
        btn.layer.cornerRadius = 29
        btn.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        return btn
    }()

    private lazy var applyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Apply", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 29
        btn.addTarget(self, action: #selector(handleApply), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Actions

private extension SortFilterViewController {
    @objc func handleReset() {
        filter = SearchFilter()
        rebuildContent()
    }

    @objc func handleApply() {
        onApply?(filter)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup

private extension SortFilterViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Sort & Filter"

        let bottomBar = UIView()
        bottomBar.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(bottomBar)
        bottomBar.addSubview(resetButton)
        bottomBar.addSubview(applyButton)

        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomBar.snp.top)
        }
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.height.equalTo(80)
        }
        resetButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(58)
            make.width.equalToSuperview().multipliedBy(0.38)
        }
        applyButton.snp.makeConstraints { make in
            make.leading.equalTo(resetButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(58)
        }

        buildContent()
    }

    func buildContent() {
        // Sort — 2 per row (wide pills)
        contentStack.addArrangedSubview(sectionView(
            title: "Sort",
            options: ["Popularity", "Latest Release"],
            selected: filter.sort,
            itemsPerRow: 2,
            onSelect: { [weak self] val in self?.filter.sort = val; self?.rebuildContent() }
        ))

        // Categories — 2 per row
        contentStack.addArrangedSubview(sectionView(
            title: "Categories",
            options: ["Episode", "Movie"],
            selected: filter.category,
            itemsPerRow: 2,
            onSelect: { [weak self] val in self?.filter.category = val; self?.rebuildContent() }
        ))

        // Region — 4 per row
        contentStack.addArrangedSubview(sectionView(
            title: "Region",
            options: ["All", "Japan", "Chinese", "Others"],
            selected: filter.region,
            itemsPerRow: 4,
            onSelect: { [weak self] val in self?.filter.region = val; self?.rebuildContent() }
        ))

        // Genre — 3 per row
        let genres = ["All", "Action", "Slice of Life", "Magic", "Sci-Fi", "Mystery", "Comedy", "Romance", "Drama"]
        contentStack.addArrangedSubview(sectionView(
            title: "Genre",
            options: genres,
            selected: filter.genre,
            itemsPerRow: 3,
            showSeeAll: true,
            onSelect: { [weak self] val in self?.filter.genre = val; self?.rebuildContent() }
        ))

        // Release Year — 3 per row
        contentStack.addArrangedSubview(sectionView(
            title: "Release Year",
            options: ["All", "2022", "2021", "2020", "2019"],
            selected: filter.year,
            itemsPerRow: 3,
            showSeeAll: true,
            onSelect: { [weak self] val in self?.filter.year = val; self?.rebuildContent() }
        ))

        // Bottom spacer
        let spacer = UIView()
        spacer.snp.makeConstraints { make in make.height.equalTo(16) }
        contentStack.addArrangedSubview(spacer)
    }

    func rebuildContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buildContent()
    }

    func sectionView(
        title: String,
        options: [String],
        selected: String,
        itemsPerRow: Int = 3,
        showSeeAll: Bool = false,
        onSelect: @escaping (String) -> Void
    ) -> UIView {
        let container = UIView()

        // Header row
        let headerRow = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Typography.Heading.heading6
        titleLabel.textColor = Colors.Grayscale.gray900

        headerRow.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }

        if showSeeAll {
            let seeAllLabel = UILabel()
            seeAllLabel.text = "See all"
            seeAllLabel.font = Typography.Body.Semibold.medium
            seeAllLabel.textColor = Colors.Primary.primary
            headerRow.addSubview(seeAllLabel)
            seeAllLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(24)
                make.centerY.equalToSuperview()
            }
        }

        // Chip rows — frame-based wrap layout
        let chipsContainer = UIView()
        let rowSpacing: CGFloat = 12
        let colSpacing: CGFloat = 10
        let screenWidth = UIScreen.main.bounds.width
        let chipWidth = (screenWidth - 48 - CGFloat(itemsPerRow - 1) * colSpacing) / CGFloat(itemsPerRow)
        let chipHeight: CGFloat = 46

        var rowIndex = 0
        var colIndex = 0
        var maxY: CGFloat = 0

        for option in options {
            let x = 24 + CGFloat(colIndex) * (chipWidth + colSpacing)
            let y = CGFloat(rowIndex) * (chipHeight + rowSpacing)
            let chipBtn = makeChipButton(title: option, isSelected: option == selected) {
                onSelect(option)
            }
            chipsContainer.addSubview(chipBtn)
            chipBtn.frame = CGRect(x: x, y: y, width: chipWidth, height: chipHeight)
            maxY = y + chipHeight

            colIndex += 1
            if colIndex >= itemsPerRow {
                colIndex = 0
                rowIndex += 1
            }
        }

        chipsContainer.snp.makeConstraints { make in
            make.height.equalTo(maxY + 0)
        }

        // Divider
        let divider = UIView()
        divider.backgroundColor = Colors.Grayscale.gray100
        divider.snp.makeConstraints { make in make.height.equalTo(1) }

        container.addSubview(headerRow)
        container.addSubview(chipsContainer)
        container.addSubview(divider)

        headerRow.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        chipsContainer.snp.makeConstraints { make in
            make.top.equalTo(headerRow.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        divider.snp.makeConstraints { make in
            make.top.equalTo(chipsContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }

        return container
    }

    func makeChipButton(title: String, isSelected: Bool, onTap: @escaping () -> Void) -> UIButton {
        let btn = FilterChipButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.small
        btn.layer.cornerRadius = 23
        if isSelected {
            btn.setTitleColor(Colors.Others.white, for: .normal)
            btn.backgroundColor = Colors.Primary.primary
            btn.layer.borderWidth = 0
        } else {
            btn.setTitleColor(Colors.Primary.primary, for: .normal)
            btn.backgroundColor = .white
            btn.layer.borderWidth = 1.5
            btn.layer.borderColor = Colors.Primary.primary.cgColor
        }
        btn.onTap = onTap
        return btn
    }
}

// MARK: - FilterChipButton

private final class FilterChipButton: UIButton {
    var onTap: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    @objc private func tapped() { onTap?() }
}
