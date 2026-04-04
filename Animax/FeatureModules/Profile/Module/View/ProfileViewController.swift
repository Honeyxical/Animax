import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    var output: ProfileViewOutput?

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Colors.Primary.primary
        iv.backgroundColor = Colors.Transparent.green
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Heading.heading5
        label.textColor = Colors.Others.white
        label.textAlignment = .center
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.medium
        label.textColor = Colors.Grayscale.gray500
        label.textAlignment = .center
        return label
    }()

    private let statsCard: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Dark.dark2
        v.layer.cornerRadius = 20
        return v
    }()

    private let favCountLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Heading.heading4
        label.textColor = Colors.Primary.primary
        label.textAlignment = .center
        return label
    }()

    private let favTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourites"
        label.font = Typography.Body.Regular.small
        label.textColor = Colors.Grayscale.gray500
        label.textAlignment = .center
        return label
    }()

    private lazy var settingsSectionLabel = makeSectionHeader("Settings")
    private lazy var aboutSectionLabel = makeSectionHeader("About")

    private lazy var darkModeRow = makeSettingRow(
        icon: "moon.fill",
        title: "Dark Mode",
        accessory: makeToggle()
    )

    private lazy var notificationsRow = makeSettingRow(
        icon: "bell.fill",
        title: "Notifications",
        accessory: makeToggle()
    )

    private lazy var versionRow = makeSettingRow(
        icon: "info.circle.fill",
        title: "App Version",
        detail: "1.0"
    )

    private lazy var logoutButton: DSButtonView = {
        let btn = DSButtonView()
        btn.configure(with: DSButtonView.ViewModel(
            title: "Log Out",
            leftSide: nil,
            rightSide: nil,
            configuration: DSButtonView.ViewModel.Configuration(
                titleColor: Colors.Warnings.error,
                backgroundColor: Colors.Dark.dark2,
                roundingCorner: .filled
            ),
            actionHandler: { [weak self] in
                self?.confirmLogout()
            }
        ))
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.viewWillAppear()
    }
}

// MARK: - ProfileViewInput

extension ProfileViewController: ProfileViewInput {
    func setOutput(_ output: ProfileViewOutput) {
        self.output = output
    }

    func showProfile(_ viewModel: ProfileViewModel) {
        avatarImageView.image = UIImage(systemName: viewModel.avatarSystemName)
        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
        favCountLabel.text = "\(viewModel.favoritesCount)"

        // update version
        if let versionLabel = versionRow.subviews
            .compactMap({ $0 as? UILabel })
            .first(where: { $0.textColor == Colors.Grayscale.gray500 && $0.text != "App Version" }) {
            versionLabel.text = viewModel.appVersion
        }
    }
}

// MARK: - Private Setup

private extension ProfileViewController {
    func setup() {
        view.backgroundColor = Colors.Dark.dark1
        title = "Profile"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(statsCard)
        statsCard.addSubview(favCountLabel)
        statsCard.addSubview(favTitleLabel)

        contentView.addSubview(settingsSectionLabel)
        contentView.addSubview(darkModeRow)
        contentView.addSubview(notificationsRow)
        contentView.addSubview(aboutSectionLabel)
        contentView.addSubview(versionRow)
        contentView.addSubview(logoutButton)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        statsCard.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }
        favCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }
        favTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(favCountLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        settingsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(statsCard.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        darkModeRow.snp.makeConstraints { make in
            make.top.equalTo(settingsSectionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        notificationsRow.snp.makeConstraints { make in
            make.top.equalTo(darkModeRow.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        aboutSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationsRow.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        versionRow.snp.makeConstraints { make in
            make.top.equalTo(aboutSectionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(versionRow.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
            make.bottom.equalToSuperview().offset(-32)
        }
    }

    func makeSectionHeader(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text.uppercased()
        label.font = Typography.Body.Semibold.small
        label.textColor = Colors.Grayscale.gray500
        return label
    }

    func makeSettingRow(icon: String, title: String, detail: String? = nil, accessory: UIView? = nil) -> UIView {
        let container = UIView()
        container.backgroundColor = Colors.Dark.dark2
        container.layer.cornerRadius = 16

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = Colors.Primary.primary
        iconView.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Typography.Body.Medium.medium
        titleLabel.textColor = Colors.Others.white

        container.addSubview(iconView)
        container.addSubview(titleLabel)

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }

        if let accessory = accessory {
            container.addSubview(accessory)
            accessory.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }
        } else if let detail = detail {
            let detailLabel = UILabel()
            detailLabel.text = detail
            detailLabel.font = Typography.Body.Regular.medium
            detailLabel.textColor = Colors.Grayscale.gray500
            container.addSubview(detailLabel)
            detailLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }
        }

        return container
    }

    func makeToggle() -> UISwitch {
        let toggle = UISwitch()
        toggle.onTintColor = Colors.Primary.primary
        toggle.isOn = false
        return toggle
    }

    func confirmLogout() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { [weak self] _ in
            self?.output?.didTapLogout()
        })
        present(alert, animated: true)
    }
}
