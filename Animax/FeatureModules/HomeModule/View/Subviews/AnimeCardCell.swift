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
        iv.layer.cornerRadius = 12
        iv.backgroundColor = Colors.Grayscale.gray200
        return iv
    }()

    // Score badge top-left (green pill)
    private let scoreBadge: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Primary.primary
        v.layer.cornerRadius = 8
        return v
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.xSmall
        label.textColor = Colors.Others.white
        label.textAlignment = .center
        return label
    }()

    // Large rank number overlay at bottom-left (white text on semi-transparent bg)
    private let rankOverlayView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        v.layer.cornerRadius = 6
        v.isHidden = true
        return v
    }()

    private let rankOverlayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = Colors.Others.white
        label.textAlignment = .center
        return label
    }()

    // Episode label bottom-left (white text on semi-transparent dark bg)
    private let episodeOverlayView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        v.layer.cornerRadius = 6
        v.isHidden = true
        return v
    }()

    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Semibold.small
        label.textColor = Colors.Others.white
        label.textAlignment = .left
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
        rankOverlayView.isHidden = true
        episodeOverlayView.isHidden = true
    }

    // MARK: - Configure

    func configure(with viewModel: AnimeCardViewModel, rank: Int? = nil) {
        titleLabel.text = viewModel.title
        genreLabel.text = viewModel.genres

        // Score badge always shown
        let scoreText = viewModel.score.isEmpty ? "N/A" : viewModel.score
        scoreLabel.text = scoreText
        scoreBadge.isHidden = scoreText == "N/A"

        // Rank overlay (large number at bottom-left of poster)
        if let rank = rank {
            rankOverlayLabel.text = "\(rank)"
            rankOverlayView.isHidden = false
            episodeOverlayView.isHidden = true
        } else if let episode = viewModel.episode, !episode.isEmpty {
            episodeLabel.text = episode
            episodeOverlayView.isHidden = false
            rankOverlayView.isHidden = true
        } else {
            rankOverlayView.isHidden = true
            episodeOverlayView.isHidden = true
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
        contentView.addSubview(scoreBadge)
        scoreBadge.addSubview(scoreLabel)
        posterImageView.addSubview(rankOverlayView)
        rankOverlayView.addSubview(rankOverlayLabel)
        posterImageView.addSubview(episodeOverlayView)
        episodeOverlayView.addSubview(episodeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)

        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }

        // Score badge top-left of poster
        scoreBadge.snp.makeConstraints { make in
            make.top.leading.equalTo(posterImageView).inset(8)
        }
        scoreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        }

        // Rank overlay bottom-left of poster
        rankOverlayView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        rankOverlayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
        }

        // Episode label bottom-left of poster
        episodeOverlayView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        episodeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
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
