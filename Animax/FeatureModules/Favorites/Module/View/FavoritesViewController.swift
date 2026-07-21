import UIKit
import SnapKit
import Kingfisher

final class FavoritesViewController: BaseViewController {
    var output: FavoritesViewOutput?
    private var items: [AnimeCardViewModel] = []

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 24, right: 24)
        let itemWidth = (UIScreen.main.bounds.width - 64) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.7)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Colors.Dark.dark1
        cv.dataSource = self
        cv.delegate = self
        cv.register(FavoriteAnimeCell.self, forCellWithReuseIdentifier: FavoriteAnimeCell.reuseIdentifier)
        return cv
    }()

    private let emptyView: UIView = {
        let v = UIView()
        v.isHidden = true
        return v
    }()

    private let emptyImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart.slash"))
        iv.tintColor = Colors.Grayscale.gray400
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No favourites yet"
        label.font = Typography.Heading.heading5
        label.textColor = Colors.Grayscale.gray400
        label.textAlignment = .center
        return label
    }()

    private let emptySubLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap the heart icon on any anime\nto save it here"
        label.font = Typography.Body.Regular.medium
        label.textColor = Colors.Grayscale.gray500
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
}

// MARK: - FavoritesViewInput

extension FavoritesViewController: FavoritesViewInput {
    func setOutput(_ output: FavoritesViewOutput) {
        self.output = output
    }

    func showFavorites(_ items: [AnimeCardViewModel]) {
        self.items = items
        collectionView.isHidden = false
        emptyView.isHidden = true
        collectionView.reloadData()
    }

    func showEmptyState() {
        items = []
        collectionView.isHidden = true
        emptyView.isHidden = false
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteAnimeCell.reuseIdentifier,
            for: indexPath
        ) as! FavoriteAnimeCell
        cell.configure(with: items[indexPath.item])
        cell.onRemove = { [weak self] in
            let item = self?.items[indexPath.item]
            self?.output?.didRemoveFavorite(id: item?.id ?? 0, title: item?.title ?? "")
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.didSelectAnime(id: items[indexPath.item].id)
    }
}

// MARK: - Private Setup

private extension FavoritesViewController {
    func setup() {
        view.backgroundColor = Colors.Dark.dark1
        title = "My Favourites"

        view.addSubview(collectionView)
        view.addSubview(emptyView)
        emptyView.addSubview(emptyImageView)
        emptyView.addSubview(emptyLabel)
        emptyView.addSubview(emptySubLabel)

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        emptyImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        emptySubLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
