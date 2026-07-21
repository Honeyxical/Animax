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
    @objc func handleSkip() { showCongratulations() }
    @objc func handleContinue() { showCongratulations() }

    func showCongratulations() {
        RegistrationSuccessOverlay.present(iconSystemName: "person.fill", over: self) { [weak self] in
            self?.onComplete?()
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
