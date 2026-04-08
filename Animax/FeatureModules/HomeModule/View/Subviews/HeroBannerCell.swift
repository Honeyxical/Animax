import UIKit
import Kingfisher
import SnapKit

final class HeroBannerCell: UICollectionViewCell {
    static let reuseIdentifier = "HeroBannerCell"

    // MARK: - UI

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = Colors.Grayscale.gray200
        return iv
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        layer.locations = [0.0, 1.0]
        return layer
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Heading.heading5
        label.textColor = Colors.Others.white
        label.numberOfLines = 2
        return label
    }()

    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.small
        label.textColor = Colors.Others.white.withAlphaComponent(0.7)
        label.numberOfLines = 1
        return label
    }()

    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("▶  Play", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Bold.small
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 14
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return btn
    }()

    private lazy var myListButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+ My List", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Bold.small
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = Colors.Others.white.cgColor
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return btn
    }()

    private let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .fill
        sv.distribution = .fillEqually
        return sv
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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = posterImageView.bounds
    }

    // MARK: - Configure

    func configure(with viewModel: AnimeCardViewModel) {
        titleLabel.text = viewModel.title
        genresLabel.text = viewModel.genres

        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - Layout

private extension HeroBannerCell {
    func setup() {
        contentView.addSubview(posterImageView)
        posterImageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genresLabel)
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(myListButton)
        contentView.addSubview(buttonStackView)

        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        genresLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-10)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(genresLabel.snp.top).offset(-6)
        }
    }
}
