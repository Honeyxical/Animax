import UIKit
import Kingfisher
import SnapKit

final class AnimeDetailViewController: BaseViewController {
    var output: AnimeDetailViewOutput?

    // MARK: - UI

    private lazy var favoriteButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(handleFavoriteTap)
        )
    }()

    private let scrollView = UIScrollView()
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
        gl.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gl.locations = [0.4, 1.0]
        return gl
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Heading.heading4
        label.textColor = Colors.Others.white
        label.numberOfLines = 3
        return label
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.large
        label.textColor = Colors.Primary.secondary
        return label
    }()

    private let infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 16
        sv.distribution = .fillEqually
        return sv
    }()

    private let genresFlowView: UIView = UIView()

    private let synopsisTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Synopsis"
        label.font = Typography.Heading.heading5
        label.textColor = Colors.Grayscale.gray900
        return label
    }()

    private let synopsisLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.medium
        label.textColor = Colors.Grayscale.gray700
        label.numberOfLines = 0
        return label
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
        navigationItem.rightBarButtonItem = favoriteButton
        output?.viewDidLoad()
    }

    @objc private func handleFavoriteTap() {
        output?.didTapFavorite()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = posterImageView.bounds
    }
}

// MARK: - AnimeDetailViewInput

extension AnimeDetailViewController: AnimeDetailViewInput {
    func setOutput(_ output: AnimeDetailViewOutput) {
        self.output = output
    }

    func showDetail(_ viewModel: AnimeDetailViewModel) {
        titleLabel.text = viewModel.title
        scoreLabel.text = "⭐ \(viewModel.score)"
        synopsisLabel.text = viewModel.synopsis

        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }

        setupInfoBlocks(viewModel: viewModel)
        setupGenres(viewModel.genres)
        scrollView.isHidden = false
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
    }

    func showFavoriteStatus(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: imageName)
        favoriteButton.tintColor = isFavorite ? Colors.Warnings.error : Colors.Others.white
    }
}

// MARK: - Private Setup

private extension AnimeDetailViewController {
    func setup() {
        view.backgroundColor = Colors.Others.white
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        scrollView.addSubview(contentView)
        scrollView.isHidden = true

        contentView.addSubview(posterImageView)
        posterImageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(infoStackView)
        contentView.addSubview(genresFlowView)
        contentView.addSubview(synopsisTitleLabel)
        contentView.addSubview(synopsisLabel)

        setupConstraints()
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(360)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(posterImageView.snp.bottom).offset(-48)
        }
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
        }
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }
        genresFlowView.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        synopsisTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(genresFlowView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-32)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }

    func setupInfoBlocks(viewModel: AnimeDetailViewModel) {
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let items: [(String, String)] = [
            ("Type", viewModel.type),
            ("Episodes", viewModel.episodes),
            ("Status", viewModel.status)
        ]
        items.forEach { title, value in
            let block = InfoBlockView(title: title, value: value)
            infoStackView.addArrangedSubview(block)
        }
    }

    func setupGenres(_ genres: [String]) {
        genresFlowView.subviews.forEach { $0.removeFromSuperview() }
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        let spacing: CGFloat = 8

        for genre in genres {
            let tag = GenreTagView(text: genre)
            tag.sizeToFit()
            let size = tag.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

            if xOffset + size.width > UIScreen.main.bounds.width - 48 {
                xOffset = 0
                yOffset += size.height + spacing
            }

            tag.frame = CGRect(x: xOffset, y: yOffset, width: size.width, height: size.height)
            genresFlowView.addSubview(tag)
            xOffset += size.width + spacing
        }

        let totalHeight = (genresFlowView.subviews.last?.frame.maxY ?? 0)
        genresFlowView.snp.updateConstraints { make in
            make.height.equalTo(max(totalHeight, 30))
        }
    }
}

// MARK: - InfoBlockView

private final class InfoBlockView: UIView {
    init(title: String, value: String) {
        super.init(frame: .zero)
        backgroundColor = Colors.Grayscale.gray100
        layer.cornerRadius = 12

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Typography.Body.Regular.xSmall
        titleLabel.textColor = Colors.Grayscale.gray500
        titleLabel.textAlignment = .center

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Typography.Body.Semibold.small
        valueLabel.textColor = Colors.Grayscale.gray900
        valueLabel.textAlignment = .center
        valueLabel.numberOfLines = 2
        valueLabel.adjustsFontSizeToFitWidth = true

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }

    required init?(coder: NSCoder) { fatalError() }
}
