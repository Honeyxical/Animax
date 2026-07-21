import UIKit
import Kingfisher
import SnapKit

final class AnimeDetailViewController: BaseViewController {
    var output: AnimeDetailViewOutput?

    private var currentTab = 0
    private var synopsisExpanded = false
    private var currentViewModel: AnimeDetailViewModel?
    private var tabContentHeightConstraint: Constraint?

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()

    private let contentView = UIView()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = Colors.Grayscale.gray200
        return iv
    }()

    private let gradientLayer: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.65).cgColor]
        gl.locations = [0.3, 1.0]
        return gl
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Heading.heading4
        label.textColor = Colors.Grayscale.gray900
        label.numberOfLines = 2
        return label
    }()

    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.tintColor = Colors.Grayscale.gray700
        btn.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "paperplane"), for: .normal)
        btn.tintColor = Colors.Grayscale.gray700
        btn.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        return btn
    }()

    private let scoreStarLabel: UILabel = {
        let l = UILabel()
        l.text = "⭐"
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()

    private let scoreValueLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Bold.medium
        l.textColor = Colors.Primary.primary
        return l
    }()

    private let scoreArrowLabel: UILabel = {
        let l = UILabel()
        l.text = ">"
        l.font = Typography.Body.Regular.small
        l.textColor = Colors.Grayscale.gray400
        return l
    }()

    private let yearLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.small
        l.textColor = Colors.Grayscale.gray500
        return l
    }()

    private let ageBadge = _BadgeLabel()
    private let regionBadge = _BadgeLabel()
    private let subtitleBadge = _BadgeLabel()

    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 24
        let cfg = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        btn.setImage(UIImage(systemName: "play.fill", withConfiguration: cfg), for: .normal)
        btn.tintColor = .white
        btn.setTitle("  Play", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.medium
        btn.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var downloadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = Colors.Transparent.green
        btn.layer.cornerRadius = 24
        let cfg = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        btn.setImage(UIImage(systemName: "arrow.down.to.line.alt", withConfiguration: cfg), for: .normal)
        btn.tintColor = Colors.Primary.primary
        btn.setTitle("  Download", for: .normal)
        btn.setTitleColor(Colors.Primary.primary, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.medium
        return btn
    }()

    private let genreLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.small
        l.textColor = Colors.Grayscale.gray500
        l.numberOfLines = 2
        return l
    }()

    private let synopsisLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        l.numberOfLines = 3
        return l
    }()

    private lazy var viewMoreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View More", for: .normal)
        btn.setTitleColor(Colors.Primary.primary, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.small
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(viewMoreTapped), for: .touchUpInside)
        return btn
    }()

    private let episodesSectionLabel: UILabel = {
        let l = UILabel()
        l.text = "Episodes"
        l.font = Typography.Body.Bold.large
        l.textColor = Colors.Grayscale.gray900
        return l
    }()

    private lazy var seasonButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Season 1  ▾", for: .normal)
        btn.setTitleColor(Colors.Primary.primary, for: .normal)
        btn.titleLabel?.font = Typography.Body.Regular.small
        return btn
    }()

    private let episodesScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceHorizontal = true
        return sv
    }()

    private let episodesStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        return sv
    }()

    private lazy var moreLikeThisTab: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("More Like This", for: .normal)
        btn.setTitleColor(Colors.Grayscale.gray900, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.medium
        btn.tag = 0
        btn.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var commentsTab: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Comments (29.5K)", for: .normal)
        btn.setTitleColor(Colors.Grayscale.gray500, for: .normal)
        btn.titleLabel?.font = Typography.Body.Regular.medium
        btn.tag = 1
        btn.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        return btn
    }()

    private let tabIndicatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Primary.primary
        return v
    }()

    private let tabSeparatorView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray200
        return v
    }()

    private let tabContentView = UIView()

    private let activityIndicator: UIActivityIndicatorView = {
        let i = UIActivityIndicatorView(style: .large)
        i.hidesWhenStopped = true
        i.color = Colors.Primary.primary
        return i
    }()

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray500
        l.textAlignment = .center
        l.numberOfLines = 0
        l.isHidden = true
        return l
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = posterImageView.bounds
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        scrollView.contentInset.bottom = view.safeAreaInsets.bottom + 16
    }
}

// MARK: - AnimeDetailViewInput

extension AnimeDetailViewController: AnimeDetailViewInput {
    func setOutput(_ output: AnimeDetailViewOutput) { self.output = output }

    func showDetail(_ viewModel: AnimeDetailViewModel) {
        currentViewModel = viewModel
        scrollView.isHidden = false
        activityIndicator.stopAnimating()
        errorLabel.isHidden = true

        titleLabel.text = viewModel.title
        scoreValueLabel.text = viewModel.score
        yearLabel.text = viewModel.year
        ageBadge.setText(extractAgeBadge(from: viewModel.rating))
        regionBadge.setText("Japan")
        subtitleBadge.setText("Subtitle")
        genreLabel.text = "Genre: \(viewModel.genres.joined(separator: ", "))"
        synopsisLabel.text = viewModel.synopsis

        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }

        buildEpisodeCards(imageURL: viewModel.imageURL, count: viewModel.episodesCount)
        buildTabContent(tab: currentTab, imageURL: viewModel.imageURL)
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            scrollView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        scrollView.isHidden = true
        activityIndicator.stopAnimating()
    }

    func showFavoriteStatus(isFavorite: Bool) {
        let imgName = isFavorite ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: imgName), for: .normal)
        bookmarkButton.tintColor = isFavorite ? Colors.Primary.primary : Colors.Grayscale.gray700
    }
}

// MARK: - Actions

private extension AnimeDetailViewController {
    @objc func bookmarkTapped() { output?.didTapFavorite() }

    @objc func shareTapped() {
        let vc = ShareViewController()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        present(vc, animated: true)
    }

    @objc func playTapped() {}

    @objc func viewMoreTapped() {
        synopsisExpanded.toggle()
        synopsisLabel.numberOfLines = synopsisExpanded ? 0 : 3
        viewMoreButton.setTitle(synopsisExpanded ? "View Less" : "View More", for: .normal)
        UIView.animate(withDuration: 0.2) { self.scrollView.layoutIfNeeded() }
    }

    @objc func tabTapped(_ sender: UIButton) { switchTab(to: sender.tag) }

    func switchTab(to index: Int) {
        currentTab = index
        let isFirst = index == 0
        moreLikeThisTab.setTitleColor(isFirst ? Colors.Grayscale.gray900 : Colors.Grayscale.gray500, for: .normal)
        moreLikeThisTab.titleLabel?.font = isFirst ? Typography.Body.Semibold.medium : Typography.Body.Regular.medium
        commentsTab.setTitleColor(!isFirst ? Colors.Grayscale.gray900 : Colors.Grayscale.gray500, for: .normal)
        commentsTab.titleLabel?.font = !isFirst ? Typography.Body.Semibold.medium : Typography.Body.Regular.medium

        let screenWidth = UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.2) {
            self.tabIndicatorView.frame.origin.x = isFirst ? 0 : screenWidth / 2
        }

        buildTabContent(tab: index, imageURL: currentViewModel?.imageURL)
    }

    func scoreRowTapped() { showRatingSheet() }

    func showRatingSheet() {
        let vc = GiveRatingViewController()
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        present(vc, animated: true)
    }
}

// MARK: - Private Setup

private extension AnimeDetailViewController {
    func setup() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        scrollView.addSubview(contentView)
        scrollView.isHidden = true

        contentView.addSubview(posterImageView)
        posterImageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(shareButton)

        let scoreRow = buildScoreRow()
        contentView.addSubview(scoreRow)

        let buttonStack = UIStackView(arrangedSubviews: [playButton, downloadButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        contentView.addSubview(buttonStack)

        contentView.addSubview(genreLabel)
        contentView.addSubview(synopsisLabel)
        contentView.addSubview(viewMoreButton)
        contentView.addSubview(episodesSectionLabel)
        contentView.addSubview(seasonButton)
        contentView.addSubview(episodesScrollView)
        episodesScrollView.addSubview(episodesStack)

        let tabBarContainer = UIView()
        contentView.addSubview(tabBarContainer)
        tabBarContainer.addSubview(moreLikeThisTab)
        tabBarContainer.addSubview(commentsTab)
        tabBarContainer.addSubview(tabIndicatorView)

        contentView.addSubview(tabSeparatorView)
        contentView.addSubview(tabContentView)

        setupConstraints(scoreRow: scoreRow, buttonStack: buttonStack, tabBarContainer: tabBarContainer)
    }

    func setupConstraints(scoreRow: UIView, buttonStack: UIView, tabBarContainer: UIView) {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }

        posterImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(320)
        }
        bookmarkButton.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
            $0.trailing.equalTo(shareButton.snp.leading).offset(-14)
            $0.width.height.equalTo(24)
        }
        shareButton.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-8)
        }
        scoreRow.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(scoreRow.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        synopsisLabel.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        viewMoreButton.snp.makeConstraints {
            $0.top.equalTo(synopsisLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        }
        episodesSectionLabel.snp.makeConstraints {
            $0.top.equalTo(viewMoreButton.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        seasonButton.snp.makeConstraints {
            $0.centerY.equalTo(episodesSectionLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        episodesScrollView.snp.makeConstraints {
            $0.top.equalTo(episodesSectionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(116)
        }
        episodesStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
            $0.height.equalTo(episodesScrollView)
        }
        tabBarContainer.snp.makeConstraints {
            $0.top.equalTo(episodesScrollView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        moreLikeThisTab.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        commentsTab.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        tabIndicatorView.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.bottom.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        tabSeparatorView.snp.makeConstraints {
            $0.top.equalTo(tabBarContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        tabContentView.snp.makeConstraints {
            $0.top.equalTo(tabSeparatorView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            tabContentHeightConstraint = $0.height.equalTo(320).constraint
            $0.bottom.equalToSuperview().offset(-24)
        }
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }

    func buildScoreRow() -> UIView {
        let container = UIView()
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center

        let sep = UILabel()
        sep.text = "|"
        sep.font = Typography.Body.Regular.small
        sep.textColor = Colors.Grayscale.gray300

        [scoreStarLabel, scoreValueLabel, scoreArrowLabel, yearLabel, sep,
         ageBadge, regionBadge, subtitleBadge].forEach { stack.addArrangedSubview($0) }

        let tap = UITapGestureRecognizer(target: self, action: #selector(scoreAreaTapped))
        container.addGestureRecognizer(tap)
        container.addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
        return container
    }

    @objc func scoreAreaTapped() { showRatingSheet() }

    func buildEpisodeCards(imageURL: String?, count: Int) {
        episodesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let display = max(count > 0 ? min(count, 6) : 0, 3)
        for i in 1...display {
            episodesStack.addArrangedSubview(makeEpisodeCard(number: i, imageURL: imageURL))
        }
    }

    func makeEpisodeCard(number: Int, imageURL: String?) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        container.backgroundColor = Colors.Grayscale.gray200

        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        if let s = imageURL, let url = URL(string: s) { iv.kf.setImage(with: url) }

        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.35)

        let playIcon = UIImageView(image: UIImage(systemName: "play.circle.fill"))
        playIcon.tintColor = .white
        playIcon.contentMode = .scaleAspectFit

        let epLabel = UILabel()
        epLabel.text = "Episode \(number)"
        epLabel.font = Typography.Body.Semibold.xSmall
        epLabel.textColor = .white

        container.addSubview(iv)
        container.addSubview(overlay)
        container.addSubview(playIcon)
        container.addSubview(epLabel)

        iv.snp.makeConstraints { $0.edges.equalToSuperview() }
        overlay.snp.makeConstraints { $0.edges.equalToSuperview() }
        playIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        epLabel.snp.makeConstraints { $0.bottom.leading.equalToSuperview().inset(8) }
        container.snp.makeConstraints {
            $0.width.equalTo(140)
            $0.height.equalTo(90)
        }
        return container
    }

    func buildTabContent(tab: Int, imageURL: String?) {
        tabContentView.subviews.forEach { $0.removeFromSuperview() }
        if tab == 0 { buildMoreLikeThisContent(imageURL: imageURL) }
        else { buildCommentsContent() }
    }

    func buildMoreLikeThisContent(imageURL: String?) {
        let titles = ["Attack on Titan", "Fullmetal Alchemist", "Death Note", "Naruto Shippuden"]
        let scores = ["9.0", "9.1", "8.6", "8.3"]
        let colWidth = (UIScreen.main.bounds.width - 60) / 2
        let cardH = colWidth * 1.4

        let grid = UIView()
        tabContentView.addSubview(grid)
        grid.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)) }

        for (i, title) in titles.enumerated() {
            let card = makeMoreCard(title: title, score: scores[i], imageURL: imageURL)
            grid.addSubview(card)
            card.snp.makeConstraints {
                $0.width.equalTo(colWidth)
                $0.height.equalTo(cardH)
                $0.top.equalToSuperview().offset(CGFloat(i / 2) * (cardH + 12))
                $0.leading.equalToSuperview().offset(CGFloat(i % 2) * (colWidth + 12))
            }
        }

        let rows = (titles.count + 1) / 2
        tabContentHeightConstraint?.update(offset: CGFloat(rows) * (cardH + 12) + 8)
        scrollView.setNeedsLayout()
    }

    func makeMoreCard(title: String, score: String, imageURL: String?) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        container.backgroundColor = Colors.Grayscale.gray200

        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        if let s = imageURL, let url = URL(string: s) { iv.kf.setImage(with: url) }

        let badgeView = UIView()
        badgeView.backgroundColor = Colors.Primary.primary
        badgeView.layer.cornerRadius = 8

        let badgeLabel = UILabel()
        badgeLabel.text = score
        badgeLabel.font = Typography.Body.Bold.xSmall
        badgeLabel.textColor = .white
        badgeLabel.textAlignment = .center

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Typography.Body.Semibold.small
        titleLabel.textColor = Colors.Grayscale.gray900
        titleLabel.numberOfLines = 2

        container.addSubview(iv)
        container.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        container.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(36)
        }
        iv.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
        badgeView.snp.makeConstraints { $0.top.leading.equalTo(iv).inset(8) }
        badgeLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)) }
        return container
    }

    func buildCommentsContent() {
        let mockComments: [(String, String)] = [
            ("Willard Purnell", "This anime is absolutely incredible! The animation quality and story depth are beyond compare."),
            ("Sarah Mitchell", "Season 2 exceeded all my expectations. The character development is truly outstanding."),
            ("James Chen", "The fight scenes are breathtaking. An absolute masterpiece!"),
        ]

        let headerView = UIView()
        let countLabel = UILabel()
        countLabel.text = "29.5K Comments"
        countLabel.font = Typography.Body.Bold.large
        countLabel.textColor = Colors.Grayscale.gray900

        let seeAllBtn = UIButton(type: .system)
        seeAllBtn.setTitle("See all", for: .normal)
        seeAllBtn.setTitleColor(Colors.Primary.primary, for: .normal)
        seeAllBtn.titleLabel?.font = Typography.Body.Semibold.small

        headerView.addSubview(countLabel)
        headerView.addSubview(seeAllBtn)
        countLabel.snp.makeConstraints { $0.leading.centerY.equalToSuperview() }
        seeAllBtn.snp.makeConstraints { $0.trailing.centerY.equalToSuperview() }

        let commentStack = UIStackView()
        commentStack.axis = .vertical
        commentStack.spacing = 16
        mockComments.forEach { commentStack.addArrangedSubview(makeCommentCell(name: $0.0, text: $0.1)) }

        tabContentView.addSubview(headerView)
        tabContentView.addSubview(commentStack)
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
            $0.height.equalTo(40)
        }
        commentStack.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualToSuperview()
        }

        tabContentHeightConstraint?.update(offset: 40 + 16 + CGFloat(mockComments.count) * 84)
        scrollView.setNeedsLayout()
    }

    func makeCommentCell(name: String, text: String) -> UIView {
        let container = UIView()

        let avatarView = UIView()
        avatarView.backgroundColor = Colors.Grayscale.gray300
        avatarView.layer.cornerRadius = 20

        let avatarLabel = UILabel()
        avatarLabel.text = String(name.prefix(1))
        avatarLabel.font = Typography.Body.Bold.medium
        avatarLabel.textColor = Colors.Grayscale.gray700
        avatarLabel.textAlignment = .center

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = Typography.Body.Bold.small
        nameLabel.textColor = Colors.Grayscale.gray900

        let commentLabel = UILabel()
        commentLabel.text = text
        commentLabel.font = Typography.Body.Regular.small
        commentLabel.textColor = Colors.Grayscale.gray600
        commentLabel.numberOfLines = 2

        let heartIcon = UIImageView(image: UIImage(systemName: "heart"))
        heartIcon.tintColor = Colors.Grayscale.gray400
        heartIcon.contentMode = .scaleAspectFit

        avatarView.addSubview(avatarLabel)
        container.addSubview(avatarView)
        container.addSubview(nameLabel)
        container.addSubview(commentLabel)
        container.addSubview(heartIcon)

        avatarLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        avatarView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(avatarView.snp.trailing).offset(12)
            $0.trailing.equalTo(heartIcon.snp.leading).offset(-8)
        }
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(nameLabel)
            $0.trailing.bottom.equalToSuperview()
        }
        heartIcon.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        return container
    }

    func setupTransparentNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
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

    func extractAgeBadge(from rating: String) -> String {
        if rating.contains("17+") || rating.contains("R -") { return "17+" }
        if rating.contains("PG-13") || rating.contains("13+") { return "13+" }
        if rating.contains("Rx") || rating.contains("18+") { return "18+" }
        if rating.contains("PG") { return "PG" }
        return "G"
    }
}

// MARK: - _BadgeLabel

private final class _BadgeLabel: UIView {
    private let label: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.xSmall
        l.textColor = Colors.Grayscale.gray600
        l.textAlignment = .center
        return l
    }()

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = Colors.Grayscale.gray300.cgColor
        addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)) }
    }

    required init?(coder: NSCoder) { fatalError() }
    func setText(_ text: String) { label.text = text }
}
