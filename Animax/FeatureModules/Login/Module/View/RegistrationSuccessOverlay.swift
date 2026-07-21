import UIKit
import SnapKit

final class RegistrationSuccessOverlay: UIView {

    private let dimView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    }()

    private let card: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 32
        return v
    }()

    private let iconCircle: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Primary.primary
        v.layer.cornerRadius = 50
        return v
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Congratulations!"
        l.font = Typography.Heading.heading4
        l.textColor = Colors.Primary.primary
        l.textAlignment = .center
        return l
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.text = "Your account is ready to use. You will be redirected to the Home page in a few seconds.."
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    private let spinner: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = Colors.Primary.primary
        ai.hidesWhenStopped = false
        return ai
    }()

    init(iconSystemName: String) {
        super.init(frame: .zero)
        iconView.image = UIImage(systemName: iconSystemName)?.withRenderingMode(.alwaysTemplate)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(dimView)
        addSubview(card)
        card.addSubview(iconCircle)
        iconCircle.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(messageLabel)
        card.addSubview(spinner)

        let dots: [(CGFloat, CGFloat)] = [(16, 1.0), (10, 0.5), (6, 0.3)]
        let dotPositions: [(CGFloat, CGFloat, Bool)] = [
            (40, -8, false),   // leading, top offset from iconCircle.top
            (-30, 8, true),    // trailing, top
            (-24, 0, true)     // trailing, center
        ]
        for (i, (size, alpha)) in dots.enumerated() {
            let dot = UIView()
            dot.backgroundColor = Colors.Primary.primary.withAlphaComponent(alpha)
            dot.layer.cornerRadius = size / 2
            card.addSubview(dot)
            dot.snp.makeConstraints { make in
                make.width.height.equalTo(size)
                if i == 0 {
                    make.top.equalTo(iconCircle).offset(dotPositions[i].1)
                    make.leading.equalToSuperview().offset(dotPositions[i].0)
                } else {
                    make.top.equalTo(iconCircle).offset(dotPositions[i].1)
                    make.trailing.equalToSuperview().inset(-dotPositions[i].0)
                }
            }
        }

        dimView.snp.makeConstraints { make in make.edges.equalToSuperview() }
        card.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        iconCircle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalTo(iconCircle)
            make.width.height.equalTo(48)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconCircle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        spinner.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
        }
        spinner.startAnimating()
    }

    static func present(
        iconSystemName: String,
        over viewController: UIViewController,
        duration: TimeInterval = 2.5,
        completion: @escaping () -> Void
    ) {
        let overlay = RegistrationSuccessOverlay(iconSystemName: iconSystemName)
        overlay.alpha = 0

        let targetView: UIView
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            targetView = window
        } else {
            targetView = viewController.view
        }
        overlay.frame = targetView.bounds
        targetView.addSubview(overlay)

        UIView.animate(withDuration: 0.25) { overlay.alpha = 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.2) { overlay.alpha = 0 } completion: { _ in
                overlay.removeFromSuperview()
                completion()
            }
        }
    }
}
