import UIKit
import SnapKit
import Kingfisher

// MARK: - SearchViewController

final class SearchViewController: BaseViewController {

    private let networkService: AnimeNetworkServiceProtocol = AnimeNetworkService()
    private var searchResults: [AnimeItem] = []
    private var isShowingTopSearches = true

    // MARK: - UI

    private let topSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Searches"
        label.font = Typography.Body.Bold.large
        label.textColor = Colors.Grayscale.gray900
        return label
    }()

    private let searchContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 2
        v.layer.borderColor = Colors.Primary.primary.cgColor
        return v
    }()

    private let searchIconImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = Colors.Primary.primary
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
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 14
        btn.tintColor = .white
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        return btn
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.rowHeight = 96
        tv.dataSource = self
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        return tv
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

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as! SearchResultCell
        cell.configure(with: searchResults[indexPath.row])
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
    func setup() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true

        // Back button manually
        let backBtn = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem = backBtn
        title = ""

        // Layout
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchIconImageView)
        searchContainerView.addSubview(searchTextField)
        view.addSubview(filterButton)
        view.addSubview(topSearchesLabel)
        view.addSubview(tableView)
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

        topSearchesLabel.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(topSearchesLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
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
        topSearchesLabel.text = "Top Searches"
        activityIndicator.startAnimating()
        networkService.fetchTopAnime { [weak self] result in
            self?.activityIndicator.stopAnimating()
            if case let .success(items) = result {
                self?.searchResults = items
                self?.tableView.reloadData()
            }
        }
    }

    func performSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            loadTopSearches()
            return
        }
        isShowingTopSearches = false
        topSearchesLabel.text = "Search Results"
        activityIndicator.startAnimating()
        networkService.searchAnime(query: query) { [weak self] result in
            self?.activityIndicator.stopAnimating()
            switch result {
            case let .success(items):
                self?.searchResults = items
                self?.tableView.reloadData()
            case .failure:
                break
            }
        }
    }
}

// MARK: - SearchResultCell

private final class SearchResultCell: UITableViewCell {
    static let reuseIdentifier = "SearchResultCell"

    // MARK: - UI

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = Colors.Grayscale.gray200
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

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }

    // MARK: - Configure

    func configure(with item: AnimeItem) {
        titleLabel.text = item.titleEnglish ?? item.title
        let imageURL = item.images.jpg.largeImageUrl ?? item.images.jpg.imageUrl
        if let urlString = imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

private extension SearchResultCell {
    func setup() {
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
}
