import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
    var output: HomeViewOutput?

    private var sections: [HomeSectionViewModel] = []

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.contentInsetAdjustmentBehavior = .never
        cv.dataSource = self
        cv.delegate = self
        cv.register(HeroBannerCell.self, forCellWithReuseIdentifier: HeroBannerCell.reuseIdentifier)
        cv.register(AnimeCardCell.self, forCellWithReuseIdentifier: AnimeCardCell.reuseIdentifier)
        cv.register(
            HomeSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier
        )
        return cv
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTransparentNavBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreNavBar()
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
        case .hero:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HeroBannerCell.reuseIdentifier,
                for: indexPath
            ) as! HeroBannerCell
            cell.configure(with: item)
            return cell

        case .topHits:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AnimeCardCell.reuseIdentifier,
                for: indexPath
            ) as! AnimeCardCell
            cell.configure(with: item, rank: indexPath.item + 1)
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

        let section = sections[indexPath.section]
        let showSeeAll = section.style != .hero

        var seeAllCallback: (() -> Void)? = nil
        if section.style == .topHits {
            seeAllCallback = { [weak self] in
                self?.output?.didTapSeeAllTopHits(items: section.items)
            }
        } else if section.style == .cards {
            seeAllCallback = { [weak self] in
                self?.output?.didTapSeeAllNewEpisodes(items: section.items)
            }
        }

        header.configure(with: section.title, showSeeAll: showSeeAll, onSeeAll: seeAllCallback)
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

// MARK: - Private Setup

private extension HomeViewController {
    func setup() {
        view.backgroundColor = .white

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }

        setupNavigationBar()
    }

    func setupNavigationBar() {
        // Logo button on left
        let logoButton = UIButton(type: .system)
        logoButton.setTitle("A", for: .normal)
        logoButton.setTitleColor(Colors.Primary.primary, for: .normal)
        logoButton.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .black)
        let logoBarItem = UIBarButtonItem(customView: logoButton)
        navigationItem.leftBarButtonItem = logoBarItem

        // Right bar: search + bell
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = Colors.Others.white
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)

        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
        bellButton.tintColor = Colors.Others.white
        bellButton.addTarget(self, action: #selector(bellTapped), for: .touchUpInside)

        let searchItem = UIBarButtonItem(customView: searchButton)
        let bellItem = UIBarButtonItem(customView: bellButton)
        navigationItem.rightBarButtonItems = [bellItem, searchItem]
    }

    func setupTransparentNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: Colors.Others.white,
            .font: Typography.Heading.heading6 as Any
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Colors.Others.white
    }

    func restoreNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.Others.white
        appearance.titleTextAttributes = [
            .foregroundColor: Colors.Grayscale.gray900,
            .font: Typography.Heading.heading6 as Any
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Colors.Grayscale.gray900
    }

    @objc func searchTapped() {
        output?.didTapSearch()
    }

    @objc func bellTapped() {
        output?.didTapNotifications()
    }

    func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self, sectionIndex < self.sections.count else {
                return self?.cardsSection()
            }
            switch self.sections[sectionIndex].style {
            case .hero:
                return self.heroSection()
            case .topHits:
                return self.topHitsSection()
            case .cards:
                return self.cardsSection()
            }
        }
    }

    func heroSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(280)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(280)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }

    func topHitsSection() -> NSCollectionLayoutSection {
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
