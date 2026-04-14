import UIKit
import SnapKit
import Kingfisher

// MARK: - NewEpisodeReleasesViewController

final class NewEpisodeReleasesViewController: BaseViewController {

    private let items: [AnimeCardViewModel]

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.register(EpisodeCardCell.self, forCellWithReuseIdentifier: EpisodeCardCell.reuseIdentifier)
        return cv
    }()

    // MARK: - Init

    init(items: [AnimeCardViewModel]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - UICollectionViewDataSource

extension NewEpisodeReleasesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCardCell.reuseIdentifier, for: indexPath) as! EpisodeCardCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - Private Setup

private extension NewEpisodeReleasesViewController {
    func setup() {
        view.backgroundColor = .white
        title = "New Episode Releases"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )

        let searchBtn = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchTapped)
        )
        navigationItem.rightBarButtonItem = searchBtn

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
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

    func makeLayout() -> UICollectionViewLayout {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 48) / 2
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemWidth)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(itemWidth)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(12)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - EpisodeCardCell

private final class EpisodeCardCell: UICollectionViewCell {
    static let reuseIdentifier = "EpisodeCardCell"

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

    private let episodeOverlayView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        v.layer.cornerRadius = 6
        return v
    }()

    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Semibold.small
        label.textColor = Colors.Others.white
        label.textAlignment = .left
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        episodeOverlayView.isHidden = true
    }

    // MARK: - Configure

    func configure(with viewModel: AnimeCardViewModel) {
        scoreBadgeLabel.text = viewModel.score
        scoreBadge.isHidden = viewModel.score == "N/A" || viewModel.score.isEmpty

        if let episode = viewModel.episode, !episode.isEmpty {
            episodeLabel.text = episode
            episodeOverlayView.isHidden = false
        } else {
            episodeOverlayView.isHidden = true
        }

        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

private extension EpisodeCardCell {
    func setup() {
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(scoreBadge)
        scoreBadge.addSubview(scoreBadgeLabel)
        posterImageView.addSubview(episodeOverlayView)
        episodeOverlayView.addSubview(episodeLabel)

        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scoreBadge.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
        }
        scoreBadgeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
        }

        episodeOverlayView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        episodeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
        }
    }
}
