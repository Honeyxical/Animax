import UIKit
import SnapKit

final class ShareViewController: UIViewController {

    private let socialApps: [(String, UIColor, String)] = [
        ("WhatsApp",  UIColor(hexString: "#25D366"), "message.fill"),
        ("Twitter",   UIColor(hexString: "#1DA1F2"), "bird"),
        ("Facebook",  UIColor(hexString: "#1877F2"), "globe"),
        ("Instagram", UIColor(hexString: "#E1306C"), "camera.fill"),
        ("Yahoo",     UIColor(hexString: "#6001D2"), "y.circle.fill"),
        ("Chat",      UIColor(hexString: "#0078FF"), "bubble.left.fill"),
        ("WeChat",    UIColor(hexString: "#07C160"), "person.2.fill"),
        ("TikTok",    UIColor(hexString: "#010101"), "music.note"),
    ]

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Share to"
        label.font = Typography.Heading.heading5
        label.textColor = Colors.Grayscale.gray900
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }

        let grid = buildGrid()
        view.addSubview(grid)
        grid.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    private func buildGrid() -> UIView {
        let container = UIView()
        let row1 = buildRow(Array(socialApps.prefix(4)))
        let row2 = buildRow(Array(socialApps.suffix(4)))

        container.addSubview(row1)
        container.addSubview(row2)
        row1.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview() }
        row2.snp.makeConstraints {
            $0.top.equalTo(row1.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        return container
    }

    private func buildRow(_ items: [(String, UIColor, String)]) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        items.forEach { stack.addArrangedSubview(makeSocialIcon(name: $0.0, color: $0.1, icon: $0.2)) }
        return stack
    }

    private func makeSocialIcon(name: String, color: UIColor, icon: String) -> UIView {
        let container = UIView()

        let circle = UIView()
        circle.backgroundColor = color
        circle.layer.cornerRadius = 28

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = Typography.Body.Regular.xSmall
        nameLabel.textColor = Colors.Grayscale.gray700
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true

        circle.addSubview(iconView)
        container.addSubview(circle)
        container.addSubview(nameLabel)

        iconView.snp.makeConstraints { $0.center.equalToSuperview(); $0.width.height.equalTo(22) }
        circle.snp.makeConstraints { $0.top.centerX.equalToSuperview(); $0.width.height.equalTo(56) }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(circle.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(4)
        }
        return container
    }
}
