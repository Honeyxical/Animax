import UIKit
import SnapKit
import Kingfisher

final class SearchViewController: BaseViewController {

    private let networkService: AnimeNetworkServiceProtocol = AnimeNetworkService()
    private var searchResults: [AnimeItem] = []
    private var isShowingTopSearches = true
    private var activeFilter = SearchFilter()

    // MARK: - UI

    private let searchContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray100
        v.layer.cornerRadius = 28
        return v
    }()

    private let searchIconImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = Colors.Grayscale.gray500
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search anime..."
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.returnKeyType = .search
        tf.delegate = self
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()

    private lazy var filterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = Colors.Transparent.green
        btn.layer.cornerRadius = 14
        btn.tintColor = Colors.Primary.primary
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        btn.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
        return btn
    }()

    // Filter chips row (shown when filters active)
    private let filterChipsScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.isHidden = true
        return sv
    }()
    private let filterChipsStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    // Section header (Top Searches / Search Results)
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Searches"
        label.font = Typography.Body.Bold.large
        label.textColor = Colors.Grayscale.gray900
        return label
    }()

    // Table for top searches (list style)
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.rowHeight = 96
        tv.dataSource = self
        tv.delegate = self
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        return tv
    }()

    // Collection view for search results grid
    private lazy var resultsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeGridLayout())
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.isHidden = true
        cv.dataSource = self
        cv.delegate = self
        cv.register(SearchGridCell.self, forCellWithReuseIdentifier: SearchGridCell.reuseIdentifier)
        return cv
    }()

    // Empty state
    private let emptyStateView: UIView = {
        let v = UIView()
        v.isHidden = true
        return v
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        ai.color = Colors.Primary.primary
        return ai
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadTopSearches()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
}

// MARK: - UITableViewDataSource / Delegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as! SearchResultCell
        cell.configure(with: searchResults[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

// MARK: - UICollectionViewDataSource / Delegate

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResults.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchGridCell.reuseIdentifier, for: indexPath) as! SearchGridCell
        cell.configure(with: searchResults[indexPath.item])
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSearch(query: textField.text ?? "")
        return true
    }
}

// MARK: - Private

private extension SearchViewController {

    @objc func handleFilter() {
        let vc = SortFilterViewController(filter: activeFilter)
        vc.onApply = { [weak self] newFilter in
            self?.activeFilter = newFilter
            self?.updateFilterChips()
            if let query = self?.searchTextField.text, !query.trimmingCharacters(in: .whitespaces).isEmpty {
                self?.performSearch(query: query)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func updateFilterChips() {
        filterChipsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let chips = activeFilter.activeChips
        chips.forEach { chip in
            let label = UILabel()
            label.text = chip
            label.font = Typography.Body.Semibold.small
            label.textColor = Colors.Others.white
            label.backgroundColor = Colors.Primary.primary
            label.layer.cornerRadius = 18
            label.clipsToBounds = true
            label.textAlignment = .center
            label.setContentHuggingPriority(.required, for: .horizontal)

            let container = UIView()
            container.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
            }
            filterChipsStack.addArrangedSubview(container)
        }
        filterChipsScrollView.isHidden = chips.isEmpty
    }

    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func textDidChange() {
        let query = searchTextField.text ?? ""
        if query.isEmpty {
            loadTopSearches()
        }
    }

    func loadTopSearches() {
        isShowingTopSearches = true
        sectionLabel.text = "Top Searches"
        showLoading(true)
        networkService.fetchTopAnime { [weak self] result in
            self?.showLoading(false)
            if case let .success(items) = result {
                self?.searchResults = items
                self?.showState(.topSearches)
            }
        }
    }

    func performSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            loadTopSearches()
            return
        }
        isShowingTopSearches = false
        sectionLabel.isHidden = true
        showLoading(true)
        networkService.searchAnime(query: query) { [weak self] result in
            self?.showLoading(false)
            switch result {
            case let .success(items):
                self?.searchResults = items
                self?.showState(items.isEmpty ? .empty : .grid)
            case .failure:
                self?.showState(.empty)
            }
        }
    }

    func showLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
            tableView.isHidden = true
            resultsCollectionView.isHidden = true
            emptyStateView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
        }
    }

    enum ContentState { case topSearches, grid, empty }

    func showState(_ state: ContentState) {
        tableView.isHidden = state != .topSearches
        resultsCollectionView.isHidden = state != .grid
        emptyStateView.isHidden = state != .empty
        sectionLabel.isHidden = state != .topSearches

        switch state {
        case .topSearches:
            sectionLabel.text = "Top Searches"
            tableView.reloadData()
        case .grid:
            resultsCollectionView.reloadData()
        case .empty:
            break
        }
    }

    func makeGridLayout() -> UICollectionViewLayout {
        let itemWidth = (UIScreen.main.bounds.width - 48) / 2
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemWidth * 1.45)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(itemWidth * 1.45)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }

    func setup() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem = backBtn
        title = ""

        buildEmptyState()

        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchIconImageView)
        searchContainerView.addSubview(searchTextField)
        view.addSubview(filterButton)
        view.addSubview(filterChipsScrollView)
        filterChipsScrollView.addSubview(filterChipsStack)
        view.addSubview(sectionLabel)
        view.addSubview(tableView)
        view.addSubview(resultsCollectionView)
        view.addSubview(emptyStateView)
        view.addSubview(activityIndicator)

        searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        filterButton.snp.makeConstraints { make in
            make.leading.equalTo(searchContainerView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(searchContainerView)
            make.width.height.equalTo(56)
        }
        searchIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchIconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        filterChipsScrollView.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        filterChipsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(filterChipsScrollView)
        }
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(filterChipsScrollView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        resultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterChipsScrollView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        emptyStateView.snp.makeConstraints { make in
            make.top.equalTo(filterChipsScrollView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func buildEmptyState() {
        // 404 illustration (placeholder with system icons)
        let illustrationContainer = UIView()

        let notFoundLabel = UILabel()
        notFoundLabel.text = "404"
        notFoundLabel.font = .systemFont(ofSize: 80, weight: .bold)
        notFoundLabel.textColor = Colors.Grayscale.gray200
        notFoundLabel.textAlignment = .center

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = Colors.Primary.primary
        iconView.contentMode = .scaleAspectFit

        let iconCircle = UIView()
        iconCircle.backgroundColor = Colors.Primary.primary
        iconCircle.layer.cornerRadius = 28

        let iconWhite = UIImageView()
        iconWhite.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        iconWhite.tintColor = .white
        iconWhite.contentMode = .scaleAspectFit
        iconCircle.addSubview(iconWhite)
        iconWhite.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(22)
        }

        let titleLabel = UILabel()
        titleLabel.text = "Not Found"
        titleLabel.font = Typography.Heading.heading4
        titleLabel.textColor = Colors.Primary.primary
        titleLabel.textAlignment = .center

        let bodyLabel = UILabel()
        bodyLabel.text = "Sorry, the keyword you entered could not be\nfound. Try to check again or search with other\nkeywords."
        bodyLabel.font = Typography.Body.Regular.medium
        bodyLabel.textColor = Colors.Grayscale.gray500
        bodyLabel.textAlignment = .center
        bodyLabel.numberOfLines = 0

        emptyStateView.addSubview(illustrationContainer)
        illustrationContainer.addSubview(notFoundLabel)
        illustrationContainer.addSubview(iconCircle)
        emptyStateView.addSubview(titleLabel)
        emptyStateView.addSubview(bodyLabel)

        illustrationContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalTo(240)
            make.height.equalTo(120)
        }
        notFoundLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        iconCircle.snp.makeConstraints { make in
            make.top.equalTo(notFoundLabel).offset(-10)
            make.centerX.equalToSuperview().offset(10)
            make.width.height.equalTo(56)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrationContainer.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
}

// MARK: - SearchResultCell (list style)

private final class SearchResultCell: UITableViewCell {
    static let reuseIdentifier = "SearchResultCell"

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = Colors.Grayscale.gray200
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let playIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "play.circle.fill"))
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.medium
        label.textColor = Colors.Grayscale.gray900
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(playIconView)
        contentView.addSubview(titleLabel)

        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
        playIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(28)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }

    func configure(with item: AnimeItem) {
        titleLabel.text = item.titleEnglish ?? item.title
        let imageURL = item.images.jpg.largeImageUrl ?? item.images.jpg.imageUrl
        if let urlString = imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - SearchGridCell (2-column grid)

private final class SearchGridCell: UICollectionViewCell {
    static let reuseIdentifier = "SearchGridCell"

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = Colors.Grayscale.gray200
        return iv
    }()

    private let scoreBadge: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Primary.primary
        v.layer.cornerRadius = 8
        return v
    }()

    private let scoreLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Bold.xSmall
        l.textColor = Colors.Others.white
        l.textAlignment = .center
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(scoreBadge)
        scoreBadge.addSubview(scoreLabel)

        posterImageView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        scoreBadge.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
        }
        scoreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }

    func configure(with item: AnimeItem) {
        let imageURL = item.images.jpg.largeImageUrl ?? item.images.jpg.imageUrl
        if let urlString = imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
        if let score = item.score {
            scoreLabel.text = String(format: "%.1f", score)
            scoreBadge.isHidden = false
        } else {
            scoreBadge.isHidden = true
        }
    }
}
