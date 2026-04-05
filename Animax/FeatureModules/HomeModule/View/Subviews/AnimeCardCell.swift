import UIKit
import Kingfisher
import SnapKit

final class AnimeCardCell: UICollectionViewCell {
    static let reuseIdentifier = "AnimeCardCell"

    // MARK: - UI

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = Colors.Grayscale.gray200
        return iv
    }()

    // Rank badge top-left (matches design: green rounded square with number)
    private let rankBadge: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Primary.primary
        v.layer.cornerRadius = 8
        return v
    }()

    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.xSmall
        label.textColor = Colors.Others.white
        label.textAlignment = .center
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Semibold.small
        label.textColor = Colors.Grayscale.gray900
        label.numberOfLines = 2
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.xSmall
        label.textColor = Colors.Grayscale.gray500
        label.numberOfLines = 1
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
    }

    // MARK: - Configure

    func configure(with viewModel: AnimeCardViewModel, rank: Int? = nil) {
        titleLabel.text = viewModel.title
        genreLabel.text = viewModel.genres

        if let rank = rank {
            rankLabel.text = String(format: "%02d", rank)
            rankBadge.isHidden = false
        } else {
            rankLabel.text = viewModel.score.isEmpty ? "N/A" : "⭐ \(viewModel.score)"
            rankBadge.isHidden = viewModel.score.isEmpty
        }

        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - Layout

private extension AnimeCardCell {
    func setup() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(rankBadge)
        rankBadge.addSubview(rankLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)

        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        // Badge top-LEFT per design
        rankBadge.snp.makeConstraints { make in
            make.top.leading.equalTo(posterImageView).inset(8)
        }
        rankLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
    }
}
