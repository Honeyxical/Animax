import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    var output: HomeViewOutput?

    private var sections: [HomeSectionViewModel] = []

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        cv.backgroundColor = Colors.Grayscale.gray50
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(AnimeCardCell.self, forCellWithReuseIdentifier: AnimeCardCell.reuseIdentifier)
        cv.register(AnimeTopHitsCell.self, forCellWithReuseIdentifier: AnimeTopHitsCell.reuseIdentifier)
        cv.register(
            HomeSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier
        )
        return cv
    }()

    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search anime..."
        sb.searchBarStyle = .minimal
        sb.tintColor = Colors.Primary.primary
        return sb
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = Colors.Primary.primary
        return indicator
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.medium
        label.textColor = Colors.Grayscale.gray500
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output?.viewDidLoad()
    }
}

// MARK: - HomeViewInput

extension HomeViewController: HomeViewInput {
    func setOutput(_ output: HomeViewOutput) {
        self.output = output
    }

    func showSections(_ sections: [HomeSectionViewModel]) {
        self.sections = sections
        errorLabel.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            collectionView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
        }
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        collectionView.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.item]

        switch section.style {
        case .topHits:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimeTopHitsCell.reuseIdentifier,
                for: indexPath
            ) as! AnimeTopHitsCell
            cell.configure(with: item, rank: indexPath.item + 1)
            cell.onAddToList = { [weak self] in
                self?.output?.didSelectAnime(id: item.id)
            }
            return cell

        case .cards:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimeCardCell.reuseIdentifier,
                for: indexPath
            ) as! AnimeCardCell
            cell.configure(with: item)
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as! HomeSectionHeaderView
        header.configure(with: sections[indexPath.section].title)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.item]
        output?.didSelectAnime(id: item.id)
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        output?.didSearchAnime(query: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            output?.didSearchAnime(query: "")
        }
    }
}

// MARK: - Private Setup

private extension HomeViewController {
    func setup() {
        view.backgroundColor = Colors.Grayscale.gray50
        navigationItem.titleView = searchBar
        searchBar.delegate = self

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }

    func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self, sectionIndex < self.sections.count else {
                return self?.cardsSection()
            }
            switch self.sections[sectionIndex].style {
            case .topHits:
                return self.topHitsSection()
            case .cards:
                return self.cardsSection()
            }
        }
    }

    func topHitsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(140)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.88),
            heightDimension: .absolute(140 * 3 + 8 * 2)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 24, trailing: 24)
        section.boundarySupplementaryItems = [sectionHeader()]
        return section
    }

    func cardsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(240)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 24, trailing: 24)
        section.boundarySupplementaryItems = [sectionHeader()]
        return section
    }

    func sectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
