import UIKit
import Kingfisher
import SnapKit

final class AnimeTopHitsCell: UICollectionViewCell {
    static let reuseIdentifier = "AnimeTopHitsCell"

    var onAddToList: (() -> Void)?

    // MARK: - UI

    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Others.white
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowOffset = CGSize(width: 0, height: 4)
        v.layer.shadowRadius = 8
        return v
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = Colors.Grayscale.gray200
        return iv
    }()

    // Green marker square "00" — matches design "Marker" component
    private let rankMarker: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Primary.primary
        v.layer.cornerRadius = 8
        return v
    }()

    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.small
        label.textColor = Colors.Others.white
        label.textAlignment = .center
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.medium
        label.textColor = Colors.Grayscale.gray900
        label.numberOfLines = 2
        return label
    }()

    private let metaLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.xSmall
        label.textColor = Colors.Grayscale.gray500
        label.numberOfLines = 1
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.xSmall
        label.textColor = Colors.Grayscale.gray500
        label.numberOfLines = 2
        return label
    }()

    private lazy var addToListButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+ My List", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.xSmall
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(handleAddToList), for: .touchUpInside)
        return btn
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.xSmall
        label.textColor = Colors.Grayscale.gray500
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
        onAddToList = nil
    }

    // MARK: - Configure

    func configure(with viewModel: AnimeCardViewModel, rank: Int) {
        titleLabel.text = viewModel.title
        genreLabel.text = viewModel.genres
        rankLabel.text = String(format: "%02d", rank)
        scoreLabel.text = viewModel.score != "N/A" ? "⭐ \(viewModel.score)" : ""
        metaLabel.text = "TV Series"

        if let urlString = viewModel.imageURL, let url = URL(string: urlString) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - Actions

private extension AnimeTopHitsCell {
    @objc func handleAddToList() {
        onAddToList?()
    }
}

// MARK: - Layout

private extension AnimeTopHitsCell {
    func setup() {
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        posterImageView.addSubview(rankMarker)
        rankMarker.addSubview(rankLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(metaLabel)
        containerView.addSubview(genreLabel)
        containerView.addSubview(addToListButton)
        containerView.addSubview(scoreLabel)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        }
        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(120)
        }
        // Rank marker bottom-left of poster (matches "00" badge in design)
        rankMarker.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
            make.width.height.equalTo(30)
        }
        rankLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).offset(4)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        metaLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(metaLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
        addToListButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(posterImageView.snp.bottom)
            make.height.equalTo(28)
            make.width.equalTo(80)
        }
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(addToListButton.snp.trailing).offset(8)
            make.centerY.equalTo(addToListButton)
        }
    }
}
