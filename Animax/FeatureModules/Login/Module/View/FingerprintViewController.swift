import UIKit
import SnapKit

final class FingerprintViewController: BaseViewController {

    var onComplete: (() -> Void)?

    // MARK: - UI

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Add a fingerprint to make your account more secure."
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    private let fingerprintIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "touchid")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Colors.Primary.primary
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let instructionLabel: UILabel = {
        let l = UILabel()
        l.text = "Please put your finger on the fingerprint scanner to get started."
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    private lazy var skipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(Colors.Grayscale.gray500, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.large
        btn.backgroundColor = Colors.Grayscale.gray100
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return btn
    }()

    private lazy var continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Actions

private extension FingerprintViewController {
    @objc func handleSkip() {
        showCongratulations()
    }

    @objc func handleContinue() {
        showCongratulations()
    }

    func showCongratulations() {
        let overlay = CongratulationsOverlay()
        overlay.frame = UIScreen.main.bounds
        overlay.alpha = 0

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            window.addSubview(overlay)
        } else {
            view.addSubview(overlay)
        }

        UIView.animate(withDuration: 0.25) {
            overlay.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            UIView.animate(withDuration: 0.2) {
                overlay.alpha = 0
            } completion: { _ in
                overlay.removeFromSuperview()
                self?.onComplete?()
            }
        }
    }
}

// MARK: - Setup

private extension FingerprintViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Set Your Fingerprint"

        let bottomBar = makeBottomBar()
        view.addSubview(subtitleLabel)
        view.addSubview(fingerprintIcon)
        view.addSubview(instructionLabel)
        view.addSubview(bottomBar)

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        fingerprintIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(fingerprintIcon.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(50)
        }
    }

    func makeBottomBar() -> UIView {
        let container = UIView()
        container.addSubview(skipButton)
        container.addSubview(continueButton)
        skipButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.42)
        }
        continueButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.52)
        }
        return container
    }
}

// MARK: - CongratulationsOverlay

private final class CongratulationsOverlay: UIView {

    private let dimView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    }()

    private let card: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 32
        v.clipsToBounds = true
        return v
    }()

    private let avatarCircle: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Primary.primary
        v.layer.cornerRadius = 50
        return v
    }()

    private let avatarIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate))
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

    // Decorative dots
    private func makeDot(size: CGFloat, color: UIColor) -> UIView {
        let v = UIView()
        v.backgroundColor = color
        v.layer.cornerRadius = size / 2
        v.snp.makeConstraints { make in make.width.height.equalTo(size) }
        return v
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(dimView)
        addSubview(card)
        card.addSubview(avatarCircle)
        avatarCircle.addSubview(avatarIcon)
        card.addSubview(titleLabel)
        card.addSubview(messageLabel)
        card.addSubview(spinner)

        let dot1 = makeDot(size: 16, color: Colors.Primary.primary)
        let dot2 = makeDot(size: 10, color: Colors.Primary.primary.withAlphaComponent(0.5))
        let dot3 = makeDot(size: 6, color: Colors.Primary.primary.withAlphaComponent(0.3))
        card.addSubview(dot1)
        card.addSubview(dot2)
        card.addSubview(dot3)

        dimView.snp.makeConstraints { make in make.edges.equalToSuperview() }

        card.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
        avatarCircle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        avatarIcon.snp.makeConstraints { make in
            make.center.equalTo(avatarCircle)
            make.width.height.equalTo(50)
        }

        dot1.snp.makeConstraints { make in
            make.top.equalTo(avatarCircle).offset(-8)
            make.leading.equalToSuperview().offset(40)
        }
        dot2.snp.makeConstraints { make in
            make.top.equalTo(avatarCircle).offset(8)
            make.trailing.equalToSuperview().inset(30)
        }
        dot3.snp.makeConstraints { make in
            make.centerY.equalTo(avatarCircle)
            make.trailing.equalToSuperview().inset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarCircle.snp.bottom).offset(20)
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
}
