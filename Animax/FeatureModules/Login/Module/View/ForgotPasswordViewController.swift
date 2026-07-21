import UIKit
import SnapKit

final class ForgotPasswordViewController: BaseViewController {

    var onContinue: (() -> Void)?

    private var selectedMethod: ContactMethod = .sms

    enum ContactMethod {
        case sms, email
    }

    // MARK: - UI

    private let illustrationView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray100
        v.layer.cornerRadius = 24
        return v
    }()

    private let illustrationIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "key.fill")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Colors.Primary.primary
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Select which contact details should we use to reset your password"
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    private lazy var smsCard: UIView = makeContactCard(
        icon: "message.fill",
        topText: "via SMS:",
        bottomText: "+1 111 ******99",
        selected: true
    )

    private lazy var emailCard: UIView = makeContactCard(
        icon: "envelope.fill",
        topText: "via Email:",
        bottomText: "and***ley@yourdomain.com",
        selected: false
    )

    private lazy var continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 29
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

private extension ForgotPasswordViewController {
    @objc func handleContinue() {
        let vc = OTPViewController()
        vc.onVerify = { [weak self] in
            self?.pushCreateNewPassword()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func pushCreateNewPassword() {
        let vc = CreateNewPasswordViewController()
        vc.onComplete = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: false)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func handleSMSTap() {
        selectedMethod = .sms
        updateCardSelection()
    }

    @objc func handleEmailTap() {
        selectedMethod = .email
        updateCardSelection()
    }

    func updateCardSelection() {
        let smsSelected = selectedMethod == .sms
        setCardSelected(smsCard, selected: smsSelected)
        setCardSelected(emailCard, selected: !smsSelected)
    }

    func setCardSelected(_ card: UIView, selected: Bool) {
        card.layer.borderColor = selected
            ? Colors.Primary.primary.cgColor
            : Colors.Grayscale.gray200.cgColor
        card.layer.borderWidth = selected ? 2 : 1.5

        if let iconCircle = card.viewWithTag(100) {
            iconCircle.backgroundColor = selected
                ? Colors.Primary.primary
                : Colors.Grayscale.gray200
        }
    }
}

// MARK: - Setup

private extension ForgotPasswordViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Forgot Password"

        view.addSubview(illustrationView)
        illustrationView.addSubview(illustrationIcon)
        view.addSubview(subtitleLabel)
        view.addSubview(smsCard)
        view.addSubview(emailCard)
        view.addSubview(continueButton)

        illustrationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(200)
        }
        illustrationIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrationView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        smsCard.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }
        emailCard.snp.makeConstraints { make in
            make.top.equalTo(smsCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(80)
        }
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }

        let smsTap = UITapGestureRecognizer(target: self, action: #selector(handleSMSTap))
        smsCard.addGestureRecognizer(smsTap)
        smsCard.isUserInteractionEnabled = true

        let emailTap = UITapGestureRecognizer(target: self, action: #selector(handleEmailTap))
        emailCard.addGestureRecognizer(emailTap)
        emailCard.isUserInteractionEnabled = true
    }

    func makeContactCard(icon: String, topText: String, bottomText: String, selected: Bool) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.borderWidth = selected ? 2 : 1.5
        card.layer.borderColor = selected
            ? Colors.Primary.primary.cgColor
            : Colors.Grayscale.gray200.cgColor

        let iconCircle = UIView()
        iconCircle.tag = 100
        iconCircle.layer.cornerRadius = 24
        iconCircle.backgroundColor = selected ? Colors.Primary.primary : Colors.Grayscale.gray200
        card.addSubview(iconCircle)

        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconCircle.addSubview(iconView)

        let topLabel = UILabel()
        topLabel.text = topText
        topLabel.font = Typography.Body.Regular.small
        topLabel.textColor = Colors.Grayscale.gray500

        let bottomLabel = UILabel()
        bottomLabel.text = bottomText
        bottomLabel.font = Typography.Body.Semibold.medium
        bottomLabel.textColor = Colors.Grayscale.gray900

        card.addSubview(topLabel)
        card.addSubview(bottomLabel)

        iconCircle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(22)
        }
        topLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconCircle.snp.trailing).offset(16)
            make.bottom.equalTo(iconCircle.snp.centerY).offset(-2)
            make.trailing.equalToSuperview().inset(16)
        }
        bottomLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconCircle.snp.trailing).offset(16)
            make.top.equalTo(iconCircle.snp.centerY).offset(2)
            make.trailing.equalToSuperview().inset(16)
        }

        return card
    }
}
