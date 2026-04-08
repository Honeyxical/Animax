import UIKit
import SnapKit

final class LoginViewController: BaseViewController {
    var output: LoginViewOutput?

    // MARK: - State
    private var isShowingForm = false
    private var isPasswordVisible = false

    // MARK: - Landing UI (Screen 3)

    private let landingScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()
    private let landingContentView = UIView()

    private let illustrationContainer: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray100
        v.layer.cornerRadius = 100
        return v
    }()

    private let illustrationIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "figure.wave")
        iv.tintColor = Colors.Primary.primary
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let landingTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Let's you in"
        l.font = Typography.Heading.heading3
        l.textColor = Colors.Grayscale.gray900
        l.textAlignment = .center
        return l
    }()

    private lazy var facebookButton = makeSocialRowButton(
        systemIcon: "f.circle.fill", iconColor: UIColor(hexString: "1877F2"),
        title: "Continue with Facebook"
    )
    private lazy var googleButton = makeSocialRowButton(
        systemIcon: "g.circle", iconColor: UIColor(hexString: "EA4335"),
        title: "Continue with Google"
    )
    private lazy var appleButton = makeSocialRowButton(
        systemIcon: "applelogo", iconColor: Colors.Grayscale.gray900,
        title: "Continue with Apple"
    )

    private lazy var orDivider = makeOrDivider()

    private lazy var signInPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign in with password", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Bold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 29
        btn.addTarget(self, action: #selector(handleSignInWithPassword), for: .touchUpInside)
        return btn
    }()

    private lazy var landingSignUpLabel = makeSignInSignUpLabel(
        normalText: "Don't have an account? ",
        actionText: "Sign up",
        action: #selector(handleSignUp)
    )

    // MARK: - Form UI (Sign In with password)

    private let formScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        sv.alpha = 0
        sv.isHidden = true
        return sv
    }()
    private let formContentView = UIView()

    private let formLogoView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let formTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Login to Your Account"
        l.font = Typography.Heading.heading3
        l.textColor = Colors.Grayscale.gray900
        l.textAlignment = .center
        l.numberOfLines = 2
        return l
    }()

    private lazy var forgotPasswordLabel: UILabel = {
        let l = UILabel()
        l.text = "Forgot the password?"
        l.font = Typography.Body.Semibold.medium
        l.textColor = Colors.Primary.primary
        l.textAlignment = .center
        l.isUserInteractionEnabled = true
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleForgotPassword)))
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
        tf.placeholder = "Email"
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
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
        tf.placeholder = "Password"
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.isSecureTextEntry = true
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

    private let rememberMeRow: UIView = {
        let v = UIView()
        return v
    }()
    private let rememberCheckbox: DSCheckboxView = {
        let cb = DSCheckboxView()
        cb.configure(with: SelectedViewModel(isSelected: false))
        return cb
    }()
    private var isRememberMeChecked = false

    private let formErrorLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.small
        l.textColor = Colors.Warnings.error
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private lazy var signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign In", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Bold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 29
        btn.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return btn
    }()

    private let formActivityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        ai.color = Colors.Others.white
        return ai
    }()

    private lazy var formOrDivider = makeOrDivider(text: "or continue with")

    private lazy var socialIconsRow: UIStackView = makeSocialIconsRow()

    private lazy var formSignUpLabel = makeSignInSignUpLabel(
        normalText: "Don't have an account? ",
        actionText: "Sign up",
        action: #selector(handleSignUp)
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {
    func setOutput(_ output: LoginViewOutput) {
        self.output = output
    }

    func showError(_ message: String) {
        formErrorLabel.text = message
        formErrorLabel.isHidden = false
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            formActivityIndicator.startAnimating()
            signInButton.isUserInteractionEnabled = false
            signInButton.alpha = 0.7
        } else {
            formActivityIndicator.stopAnimating()
            signInButton.isUserInteractionEnabled = true
            signInButton.alpha = 1.0
        }
    }
}

// MARK: - Actions

private extension LoginViewController {
    @objc func handleSignInWithPassword() {
        showForm()
    }

    @objc func handleSignIn() {
        formErrorLabel.isHidden = true
        output?.didTapLogin(email: emailTextField.text, password: passwordTextField.text)
    }

    @objc func handleSignUp() {
        output?.didTapSignUp()
    }

    @objc func handleForgotPassword() {
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
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

    func showForm() {
        guard !isShowingForm else { return }
        isShowingForm = true
        formScrollView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.landingScrollView.alpha = 0
            self.formScrollView.alpha = 1
        } completion: { _ in
            self.landingScrollView.isHidden = true
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackToLanding)
        )
        navigationItem.leftBarButtonItem?.tintColor = Colors.Grayscale.gray900
    }

    @objc func handleBackToLanding() {
        guard isShowingForm else { return }
        isShowingForm = false
        landingScrollView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.formScrollView.alpha = 0
            self.landingScrollView.alpha = 1
        } completion: { _ in
            self.formScrollView.isHidden = true
        }
        navigationItem.leftBarButtonItem = nil
    }
}

// MARK: - Setup

private extension LoginViewController {
    func setup() {
        view.backgroundColor = .white
        setupLanding()
        setupForm()
        setupTextFieldDelegates()
    }

    func setupLanding() {
        view.addSubview(landingScrollView)
        landingScrollView.addSubview(landingContentView)

        landingContentView.addSubview(illustrationContainer)
        illustrationContainer.addSubview(illustrationIcon)
        landingContentView.addSubview(landingTitleLabel)
        landingContentView.addSubview(facebookButton)
        landingContentView.addSubview(googleButton)
        landingContentView.addSubview(appleButton)
        landingContentView.addSubview(orDivider)
        landingContentView.addSubview(signInPasswordButton)
        landingContentView.addSubview(landingSignUpLabel)

        landingScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        landingContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(landingScrollView)
        }

        illustrationContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        illustrationIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        landingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrationContainer.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        facebookButton.snp.makeConstraints { make in
            make.top.equalTo(landingTitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(facebookButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        orDivider.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        signInPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(orDivider.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        landingSignUpLabel.snp.makeConstraints { make in
            make.top.equalTo(signInPasswordButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
        }
    }

    func setupForm() {
        view.addSubview(formScrollView)
        formScrollView.addSubview(formContentView)

        formContentView.addSubview(formLogoView)
        formContentView.addSubview(formTitleLabel)
        formContentView.addSubview(emailContainer)
        emailContainer.addSubview(emailIconView)
        emailContainer.addSubview(emailTextField)
        formContentView.addSubview(passwordContainer)
        passwordContainer.addSubview(passwordIconView)
        passwordContainer.addSubview(passwordTextField)
        passwordContainer.addSubview(eyeToggleButton)
        formContentView.addSubview(rememberMeRow)
        rememberMeRow.addSubview(rememberCheckbox)
        let rememberLabel = makeRememberLabel()
        rememberMeRow.addSubview(rememberLabel)
        formContentView.addSubview(formErrorLabel)
        formContentView.addSubview(signInButton)
        formContentView.addSubview(formActivityIndicator)
        formContentView.addSubview(forgotPasswordLabel)
        formContentView.addSubview(formOrDivider)
        formContentView.addSubview(socialIconsRow)
        formContentView.addSubview(formSignUpLabel)

        styleFieldContainer(emailContainer)
        styleFieldContainer(passwordContainer)

        formScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        formContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(formScrollView)
        }
        formLogoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        formTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(formLogoView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        emailContainer.snp.makeConstraints { make in
            make.top.equalTo(formTitleLabel.snp.bottom).offset(32)
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
        formErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(rememberMeRow.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(formErrorLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        formActivityIndicator.snp.makeConstraints { make in
            make.center.equalTo(signInButton)
        }
        forgotPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        formOrDivider.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        socialIconsRow.snp.makeConstraints { make in
            make.top.equalTo(formOrDivider.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        formSignUpLabel.snp.makeConstraints { make in
            make.top.equalTo(socialIconsRow.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
        }

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleRememberMeTap))
        rememberMeRow.addGestureRecognizer(tapRecognizer)
        rememberMeRow.isUserInteractionEnabled = true
    }

    func setupTextFieldDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    // MARK: - Helpers

    func makeSocialRowButton(systemIcon: String, iconColor: UIColor, title: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.borderWidth = 1
        container.layer.borderColor = Colors.Grayscale.gray200.cgColor
        container.layer.cornerRadius = 16

        let icon = UIImageView(image: UIImage(systemName: systemIcon)?.withRenderingMode(.alwaysTemplate))
        icon.tintColor = iconColor
        icon.contentMode = .scaleAspectFit

        let label = UILabel()
        label.text = title
        label.font = Typography.Body.Medium.medium
        label.textColor = Colors.Grayscale.gray900

        container.addSubview(icon)
        container.addSubview(label)

        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return container
    }

    func makeOrDivider(text: String = "or") -> UIView {
        let container = UIView()
        let leftLine = UIView()
        leftLine.backgroundColor = Colors.Grayscale.gray200
        let rightLine = UIView()
        rightLine.backgroundColor = Colors.Grayscale.gray200
        let label = UILabel()
        label.text = text
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

    func makeSignInSignUpLabel(normalText: String, actionText: String, action: Selector) -> UILabel {
        let label = UILabel()
        let attributed = NSMutableAttributedString(
            string: normalText,
            attributes: [
                .font: Typography.Body.Regular.medium as Any,
                .foregroundColor: Colors.Grayscale.gray500
            ]
        )
        attributed.append(NSAttributedString(
            string: actionText,
            attributes: [
                .font: Typography.Body.Semibold.medium as Any,
                .foregroundColor: Colors.Primary.primary
            ]
        ))
        label.attributedText = attributed
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        return label
    }

    func makeRememberLabel() -> UILabel {
        let l = UILabel()
        l.text = "Remember me"
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        return l
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

    func styleFieldContainer(_ container: UIView) {
        container.backgroundColor = Colors.Grayscale.gray50
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 0
        container.layer.borderColor = UIColor.clear.cgColor
    }

    @objc func handleRememberMeTap() {
        isRememberMeChecked.toggle()
        rememberCheckbox.configure(with: SelectedViewModel(isSelected: isRememberMeChecked))
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
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
            handleSignIn()
        }
        return true
    }
}
