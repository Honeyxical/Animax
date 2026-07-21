import UIKit
import Kingfisher
import SnapKit

final class FavoriteAnimeCell: UICollectionViewCell {
    static let reuseIdentifier = "FavoriteAnimeCell"
    var onRemove: (() -> Void)?

    // MARK: - UI

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = Colors.Grayscale.gray700
        return iv
    }()

    private let removeButton: UIButton = {
        let btn = UIButton(type: .system)
        let img = UIImage(systemName: "heart.fill")
        btn.setImage(img, for: .normal)
        btn.tintColor = Colors.Warnings.error
        btn.backgroundColor = Colors.Dark.dark2.withAlphaComponent(0.8)
        btn.layer.cornerRadius = 16
        return btn
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.xSmall
        label.textColor = Colors.Others.white
        label.backgroundColor = Colors.Primary.primary
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Semibold.small
        label.textColor = Colors.Others.white
        label.numberOfLines = 2
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.xSmall
        label.textColor = Colors.Grayscale.gray400
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
        onRemove = nil
    }

    // MARK: - Configure

    func configure(with viewModel: AnimeCardViewModel) {
        titleLabel.text = viewModel.title
        genreLabel.text = viewModel.genres
        scoreLabel.text = "⭐ \(viewModel.score)"

        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - Layout

private extension FavoriteAnimeCell {
    func setup() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(removeButton)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)

        removeButton.addTarget(self, action: #selector(handleRemove), for: .touchUpInside)

        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.4)
        }
        removeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(posterImageView).inset(8)
            make.width.height.equalTo(32)
        }
        scoreLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(posterImageView).inset(8)
            make.height.equalTo(22)
        }
        scoreLabel.layoutIfNeeded()
        scoreLabel.snp.makeConstraints { make in
            make.width.equalTo(scoreLabel.intrinsicContentSize.width + 12)
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

    @objc func handleRemove() {
        onRemove?()
    }
}
