import UIKit
import SnapKit

final class InterestsViewController: BaseViewController {

    var onContinue: (() -> Void)?

    private var selectedGenres: Set<String> = []

    private let genres = [
        "Action", "Drama", "Comedy",
        "Ecchi", "Adventure", "Mecha",
        "Romance", "Science", "Music",
        "School", "Seinen", "Shoujo",
        "Fantasy", "Mystery", "Sports",
        "Vampire", "Isekai", "Shounen",
        "Television", "Superheroes",
        "Magic", "Game", "Slice of Life"
    ]

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    private let contentView = UIView()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Choose your interests and get the best anime recommendations. Don't worry, you can always change it later."
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        l.numberOfLines = 0
        return l
    }()

    private let tagsContainer = UIView()

    private lazy var skipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(Colors.Grayscale.gray500, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.large
        btn.backgroundColor = Colors.Grayscale.gray100
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return btn
    }()

    private lazy var continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return btn
    }()

    private var tagButtons: [String: UIButton] = [:]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buildTagButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Actions

private extension InterestsViewController {
    @objc func handleSkip() {
        onContinue?()
    }

    @objc func handleContinue() {
        onContinue?()
    }

    @objc func handleTagTap(_ sender: UIButton) {
        guard let genre = sender.titleLabel?.text else { return }
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
            styleTag(sender, selected: false)
        } else {
            selectedGenres.insert(genre)
            styleTag(sender, selected: true)
        }
    }
}

// MARK: - Setup

private extension InterestsViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Choose Your Interest"
        navigationController?.navigationBar.tintColor = Colors.Grayscale.gray900

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(tagsContainer)

        let bottomBar = makeBottomBar()
        view.addSubview(bottomBar)

        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomBar.snp.top)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        tagsContainer.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-16)
        }
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(50)
        }
    }

    func makeBottomBar() -> UIView {
        let container = UIView()
        container.addSubview(skipButton)
        container.addSubview(continueButton)

        skipButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.42)
        }
        continueButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.52)
        }
        return container
    }

    func buildTagButtons() {
        let screenWidth = UIScreen.main.bounds.width - 48
        let hSpacing: CGFloat = 10
        let vSpacing: CGFloat = 12

        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        for genre in genres {
            let btn = UIButton(type: .system)
            btn.setTitle(genre, for: .normal)
            btn.titleLabel?.font = Typography.Body.Semibold.medium
            btn.layer.cornerRadius = 20
            btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            btn.addTarget(self, action: #selector(handleTagTap(_:)), for: .touchUpInside)
            styleTag(btn, selected: false)

            btn.sizeToFit()
            let size = btn.sizeThatFits(CGSize(width: 200, height: 40))
            let width = size.width + 40
            let height: CGFloat = 44

            if xOffset + width > screenWidth {
                xOffset = 0
                yOffset += height + vSpacing
            }

            btn.frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
            tagsContainer.addSubview(btn)
            tagButtons[genre] = btn

            xOffset += width + hSpacing
        }

        let totalHeight = (tagsContainer.subviews.last?.frame.maxY ?? 0)
        tagsContainer.snp.makeConstraints { make in
            make.height.equalTo(max(totalHeight, 44))
        }
    }

    func styleTag(_ btn: UIButton, selected: Bool) {
        if selected {
            btn.backgroundColor = Colors.Primary.primary
            btn.setTitleColor(Colors.Others.white, for: .normal)
            btn.layer.borderWidth = 0
        } else {
            btn.backgroundColor = .white
            btn.setTitleColor(Colors.Primary.primary, for: .normal)
            btn.layer.borderWidth = 1.5
            btn.layer.borderColor = Colors.Primary.primary.cgColor
        }
    }
}
