import UIKit
import SnapKit

final class SignUpViewController: BaseViewController {

    var onSignUpSuccess: (() -> Void)?

    private var isPasswordVisible = false
    private var isRememberMeChecked = false

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    private let contentView = UIView()

    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Create Your Account"
        l.font = Typography.Heading.heading3
        l.textColor = Colors.Grayscale.gray900
        l.textAlignment = .center
        return l
    }()

    private let emailContainer = UIView()
    private let emailIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "envelope")?.withRenderingMode(.alwaysTemplate))
        iv.tintColor = Colors.Grayscale.gray500
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: Colors.Grayscale.gray500]
        )
        return tf
    }()

    private let passwordContainer = UIView()
    private let passwordIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "lock")?.withRenderingMode(.alwaysTemplate))
        iv.tintColor = Colors.Grayscale.gray500
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [.foregroundColor: Colors.Grayscale.gray500]
        )
        return tf
    }()
    private lazy var eyeToggleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = Colors.Grayscale.gray500
        btn.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return btn
    }()

    private let rememberMeRow = UIView()
    private let rememberCheckbox: DSCheckboxView = {
        let cb = DSCheckboxView()
        cb.configure(with: SelectedViewModel(isSelected: false))
        return cb
    }()

    private lazy var signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Bold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 29
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()

    private lazy var orDivider = makeOrDivider()

    private lazy var socialIconsRow: UIStackView = makeSocialIconsRow()

    private lazy var signInLabel: UILabel = {
        let l = UILabel()
        let attributed = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                .font: Typography.Body.Regular.medium as Any,
                .foregroundColor: Colors.Grayscale.gray500
            ]
        )
        attributed.append(NSAttributedString(
            string: "Sign in",
            attributes: [
                .font: Typography.Body.Semibold.medium as Any,
                .foregroundColor: Colors.Primary.primary
            ]
        ))
        l.attributedText = attributed
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSignIn)))
        return l
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

private extension SignUpViewController {
    @objc func handleSignUp() {
        let interestsVC = InterestsViewController()
        interestsVC.onContinue = { [weak self] in
            self?.onSignUpSuccess?()
        }
        navigationController?.pushViewController(interestsVC, animated: true)
    }

    @objc func handleSignIn() {
        navigationController?.popViewController(animated: true)
    }

    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        let iconName = isPasswordVisible ? "eye" : "eye.slash"
        eyeToggleButton.setImage(
            UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
    }

    @objc func handleRememberMeTap() {
        isRememberMeChecked.toggle()
        rememberCheckbox.configure(with: SelectedViewModel(isSelected: isRememberMeChecked))
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let container = textField == emailTextField ? emailContainer : passwordContainer
        let iconView = textField == emailTextField ? emailIconView : passwordIconView
        container.backgroundColor = Colors.Transparent.green
        container.layer.borderWidth = 1
        container.layer.borderColor = Colors.Primary.primary.cgColor
        iconView.tintColor = Colors.Primary.primary
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let container = textField == emailTextField ? emailContainer : passwordContainer
        let iconView = textField == emailTextField ? emailIconView : passwordIconView
        container.backgroundColor = Colors.Grayscale.gray50
        container.layer.borderWidth = 0
        iconView.tintColor = Colors.Grayscale.gray500
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Setup

private extension SignUpViewController {
    func setup() {
        view.backgroundColor = .white
        title = ""

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailContainer)
        emailContainer.addSubview(emailIconView)
        emailContainer.addSubview(emailTextField)
        contentView.addSubview(passwordContainer)
        passwordContainer.addSubview(passwordIconView)
        passwordContainer.addSubview(passwordTextField)
        passwordContainer.addSubview(eyeToggleButton)
        contentView.addSubview(rememberMeRow)
        let rememberLabel = UILabel()
        rememberLabel.text = "Remember me"
        rememberLabel.font = Typography.Body.Regular.medium
        rememberLabel.textColor = Colors.Grayscale.gray700
        rememberMeRow.addSubview(rememberCheckbox)
        rememberMeRow.addSubview(rememberLabel)
        contentView.addSubview(signUpButton)
        contentView.addSubview(orDivider)
        contentView.addSubview(socialIconsRow)
        contentView.addSubview(signInLabel)

        styleFieldContainer(emailContainer)
        styleFieldContainer(passwordContainer)

        emailTextField.delegate = self
        passwordTextField.delegate = self

        let rememberTap = UITapGestureRecognizer(target: self, action: #selector(handleRememberMeTap))
        rememberMeRow.addGestureRecognizer(rememberTap)
        rememberMeRow.isUserInteractionEnabled = true

        setupConstraints(rememberLabel: rememberLabel)
    }

    func setupConstraints(rememberLabel: UILabel) {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        emailContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        emailIconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(emailIconView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
        }
        passwordContainer.snp.makeConstraints { make in
            make.top.equalTo(emailContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        passwordIconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        eyeToggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalTo(passwordIconView.snp.trailing).offset(12)
            make.trailing.equalTo(eyeToggleButton.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(16)
        }
        rememberMeRow.snp.makeConstraints { make in
            make.top.equalTo(passwordContainer.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(30)
        }
        rememberCheckbox.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        rememberLabel.snp.makeConstraints { make in
            make.leading.equalTo(rememberCheckbox.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(rememberMeRow.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        orDivider.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        socialIconsRow.snp.makeConstraints { make in
            make.top.equalTo(orDivider.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(socialIconsRow.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
        }
    }

    func styleFieldContainer(_ container: UIView) {
        container.backgroundColor = Colors.Grayscale.gray50
        container.layer.cornerRadius = 16
    }

    func makeOrDivider() -> UIView {
        let container = UIView()
        let leftLine = UIView()
        leftLine.backgroundColor = Colors.Grayscale.gray200
        let rightLine = UIView()
        rightLine.backgroundColor = Colors.Grayscale.gray200
        let label = UILabel()
        label.text = "or continue with"
        label.font = Typography.Body.Regular.medium
        label.textColor = Colors.Grayscale.gray500
        label.textAlignment = .center

        container.addSubview(leftLine)
        container.addSubview(label)
        container.addSubview(rightLine)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        leftLine.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(label.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
        rightLine.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(label.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
        return container
    }

    func makeSocialIconsRow() -> UIStackView {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .equalSpacing
        let icons: [(String, UIColor)] = [
            ("f.circle.fill", UIColor(hexString: "1877F2")),
            ("g.circle", UIColor(hexString: "EA4335")),
            ("applelogo", Colors.Grayscale.gray900)
        ]
        for (iconName, color) in icons {
            let box = UIView()
            box.backgroundColor = .white
            box.layer.borderWidth = 1
            box.layer.borderColor = Colors.Grayscale.gray200.cgColor
            box.layer.cornerRadius = 16
            let icon = UIImageView(image: UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate))
            icon.tintColor = color
            icon.contentMode = .scaleAspectFit
            box.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(28)
            }
            box.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
            sv.addArrangedSubview(box)
        }
        return sv
    }
}
