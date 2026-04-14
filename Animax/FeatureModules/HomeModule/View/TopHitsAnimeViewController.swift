import UIKit
import SnapKit
import Kingfisher

// MARK: - TopHitsAnimeViewController

final class TopHitsAnimeViewController: BaseViewController {

    private let items: [AnimeCardViewModel]
    private var inListSet: Set<Int> = []

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.rowHeight = 160
        tv.dataSource = self
        tv.register(TopHitsAnimeCell.self, forCellReuseIdentifier: TopHitsAnimeCell.reuseIdentifier)
        return tv
    }()

    // MARK: - Init

    init(items: [AnimeCardViewModel]) {
        self.items = Array(items.prefix(15))
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - UITableViewDataSource

extension TopHitsAnimeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopHitsAnimeCell.reuseIdentifier, for: indexPath) as! TopHitsAnimeCell
        let item = items[indexPath.row]
        let isInList = inListSet.contains(item.id)
        cell.configure(with: item, rank: indexPath.row + 1, isInList: isInList)
        cell.onToggleList = { [weak self] in
            guard let self = self else { return }
            if self.inListSet.contains(item.id) {
                self.inListSet.remove(item.id)
            } else {
                self.inListSet.insert(item.id)
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}

// MARK: - Private Setup

private extension TopHitsAnimeViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Top Hits Anime"

        // Back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )

        // Search button
        let searchBtn = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchTapped)
        )
        navigationItem.rightBarButtonItem = searchBtn

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func searchTapped() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TopHitsAnimeCell

private final class TopHitsAnimeCell: UITableViewCell {
    static let reuseIdentifier = "TopHitsAnimeCell"

    var onToggleList: (() -> Void)?

    // MARK: - UI

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

    private let scoreBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.xSmall
        label.textColor = Colors.Others.white
        label.textAlignment = .center
        return label
    }()

    private let rankView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.layer.cornerRadius = 6
        return v
    }()

    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Colors.Others.white
        label.textAlignment = .center
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.medium
        label.textColor = Colors.Grayscale.gray900
        label.numberOfLines = 2
        return label
    }()

    private let yearCountryLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.small
        label.textColor = Colors.Grayscale.gray500
        label.numberOfLines = 1
        return label
    }()

    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.small
        label.textColor = Colors.Grayscale.gray500
        label.numberOfLines = 2
        return label
    }()

    private lazy var myListButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = Typography.Body.Semibold.small
        btn.addTarget(self, action: #selector(myListTapped), for: .touchUpInside)
        return btn
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
        onToggleList = nil
    }

    // MARK: - Configure

    func configure(with viewModel: AnimeCardViewModel, rank: Int, isInList: Bool) {
        titleLabel.text = viewModel.title
        scoreBadgeLabel.text = viewModel.score

        var yearCountry = ""
        if !viewModel.year.isEmpty {
            yearCountry = viewModel.year
        }
        yearCountryLabel.text = yearCountry.isEmpty ? "Japan" : "\(yearCountry) | Japan"
        genresLabel.text = "Genre: \(viewModel.genres)"
        rankLabel.text = "\(rank)"

        if isInList {
            myListButton.setTitle("✓ My List", for: .normal)
            myListButton.setTitleColor(Colors.Primary.primary, for: .normal)
            myListButton.backgroundColor = .white
            myListButton.layer.borderWidth = 1.5
            myListButton.layer.borderColor = Colors.Primary.primary.cgColor
        } else {
            myListButton.setTitle("+ My List", for: .normal)
            myListButton.setTitleColor(Colors.Others.white, for: .normal)
            myListButton.backgroundColor = Colors.Primary.primary
            myListButton.layer.borderWidth = 0
            myListButton.layer.borderColor = UIColor.clear.cgColor
        }

        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
    }

    @objc private func myListTapped() {
        onToggleList?()
    }
}

// MARK: - TopHitsAnimeCell Layout

private extension TopHitsAnimeCell {
    func setup() {
        selectionStyle = .none
        backgroundColor = .white

        contentView.addSubview(posterImageView)
        posterImageView.addSubview(scoreBadge)
        scoreBadge.addSubview(scoreBadgeLabel)
        posterImageView.addSubview(rankView)
        rankView.addSubview(rankLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearCountryLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(myListButton)

        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(110)
            make.height.equalTo(140)
        }

        scoreBadge.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
        }
        scoreBadgeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
        }

        rankView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        rankLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }

        yearCountryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }

        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(yearCountryLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }

        myListButton.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.height.equalTo(30)
            make.bottom.lessThanOrEqualTo(posterImageView.snp.bottom)
        }
    }
}
