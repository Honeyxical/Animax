import UIKit
import SnapKit

final class LoginViewController: BaseViewController {
    var output: LoginViewOutput?

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back 👋"
        label.font = Typography.Heading.heading3
        label.textColor = Colors.Grayscale.gray900
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to continue watching your favourite anime"
        label.font = Typography.Body.Regular.medium
        label.textColor = Colors.Grayscale.gray600
        label.numberOfLines = 2
        return label
    }()

    private let emailField: DSTextFieldView = {
        let field = DSTextFieldView()
        return field
    }()

    private let passwordField: DSTextFieldView = {
        let field = DSTextFieldView()
        return field
    }()

    private let loginButton: DSButtonView = {
        let button = DSButtonView()
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = Colors.Others.white
        return indicator
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Regular.small
        label.textColor = Colors.Warnings.error
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output?.viewDidLoad()
    }
}

// MARK: - LoginViewInput

extension LoginViewController: LoginViewInput {
    func setOutput(_ output: LoginViewOutput) {
        self.output = output
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            loginButton.isUserInteractionEnabled = false
        } else {
            activityIndicator.stopAnimating()
            loginButton.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Private Setup

private extension LoginViewController {
    func setup() {
        view.backgroundColor = Colors.Others.white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(errorLabel)
        contentView.addSubview(loginButton)
        contentView.addSubview(activityIndicator)

        configureFields()
        configureButton()
        setupConstraints()
    }

    func configureFields() {
        emailField.configure(with: DSTextFieldView.ViewModel(
            placeholder: "Email",
            text: nil,
            leftSide: .image(UIImage(systemName: "envelope") ?? UIImage()),
            rightSide: nil,
            state: .default
        ))
        passwordField.configure(with: DSTextFieldView.ViewModel(
            placeholder: "Password",
            text: nil,
            leftSide: .image(UIImage(systemName: "lock") ?? UIImage()),
            rightSide: nil,
            state: .default
        ))
    }

    func configureButton() {
        loginButton.configure(with: DSButtonView.ViewModel(
            title: "Sign In",
            leftSide: nil,
            rightSide: nil,
            configuration: DSButtonView.ViewModel.Configuration(
                titleColor: Colors.Others.white,
                backgroundColor: Colors.Primary.primary,
                roundingCorner: .rounded
            ),
            actionHandler: { [weak self] in
                self?.handleLogin()
            }
        ))
    }

    func handleLogin() {
        errorLabel.isHidden = true
        let emailText = emailField.currentText
        let passwordText = passwordField.currentText
        output?.didTapLogin(email: emailText, password: passwordText)
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(loginButton)
        }
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(loginButton.snp.bottom).offset(48)
        }
    }
}
