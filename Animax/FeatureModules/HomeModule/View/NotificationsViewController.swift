import UIKit
import SnapKit
import Kingfisher

// MARK: - Notification Model

private struct NotificationItem {
    let imageURL: String
    let title: String
    let date: String
    let subtitle: String
    let badgeText: String // "Update" or "New Release"
}

// MARK: - NotificationsViewController

final class NotificationsViewController: BaseViewController {

    private let notifications: [NotificationItem] = [
        NotificationItem(
            imageURL: "https://cdn.myanimelist.net/images/anime/5/47767l.jpg",
            title: "One Piece",
            date: "12/20/2024",
            subtitle: "Episodes 1080",
            badgeText: "Update"
        ),
        NotificationItem(
            imageURL: "https://cdn.myanimelist.net/images/anime/1171/109222l.jpg",
            title: "Jujutsu Kaisen Season 2",
            date: "12/18/2024",
            subtitle: "Episodes 10",
            badgeText: "Update"
        ),
        NotificationItem(
            imageURL: "https://cdn.myanimelist.net/images/anime/1607/117271l.jpg",
            title: "Dragon Ball Super: Super Hero",
            date: "12/17/2024",
            subtitle: "",
            badgeText: "New Release"
        ),
        NotificationItem(
            imageURL: "https://cdn.myanimelist.net/images/anime/1337/99013l.jpg",
            title: "The Rising of The Shield Hero: Sea...",
            date: "12/15/2024",
            subtitle: "Episodes 20",
            badgeText: "Update"
        ),
        NotificationItem(
            imageURL: "https://cdn.myanimelist.net/images/anime/1286/99889l.jpg",
            title: "Idol Bu Show Movie",
            date: "12/14/2024",
            subtitle: "",
            badgeText: "New Release"
        ),
        NotificationItem(
            imageURL: "https://cdn.myanimelist.net/images/anime/1425/94352l.jpg",
            title: "Date a Live Season IV",
            date: "12/12/2024",
            subtitle: "Episodes 12",
            badgeText: "Update"
        )
    ]

    // MARK: - UI

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.rowHeight = 100
        tv.dataSource = self
        tv.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)
        return tv
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - UITableViewDataSource

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as! NotificationCell
        cell.configure(with: notifications[indexPath.row])
        return cell
    }
}

// MARK: - Private Setup

private extension NotificationsViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Notification"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )

        let moreBtn = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(moreTapped)
        )
        navigationItem.rightBarButtonItem = moreBtn

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func moreTapped() {
        // No-op placeholder
    }
}

// MARK: - NotificationCell

private final class NotificationCell: UITableViewCell {
    static let reuseIdentifier = "NotificationCell"

    // MARK: - UI

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = Colors.Grayscale.gray200
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Bold.medium
        label.textColor = Colors.Grayscale.gray900
        label.numberOfLines = 2
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.xSmall
        label.textColor = Colors.Grayscale.gray400
        label.textAlignment = .right
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.small
        label.textColor = Colors.Grayscale.gray500
        label.numberOfLines = 1
        return label
    }()

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Semibold.small
        label.textColor = Colors.Primary.primary
        label.backgroundColor = Colors.Transparent.green
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }

    // MARK: - Configure

    func configure(with item: NotificationItem) {
        titleLabel.text = item.title
        dateLabel.text = item.date
        subtitleLabel.text = item.subtitle
        badgeLabel.text = "  \(item.badgeText)  "

        if let url = URL(string: item.imageURL) {
            posterImageView.kf.setImage(with: url)
        }
    }
}

private extension NotificationCell {
    func setup() {
        selectionStyle = .none
        backgroundColor = .white

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(badgeLabel)

        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(100)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-8)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }

        badgeLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
        }
    }
}
