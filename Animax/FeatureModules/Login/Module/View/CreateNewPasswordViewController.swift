import UIKit
import SnapKit

final class CreateNewPasswordViewController: BaseViewController {

    var onComplete: (() -> Void)?

    private var isNewPasswordVisible = false
    private var isConfirmPasswordVisible = false

    // MARK: - UI

    private let illustrationView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray100
        v.layer.cornerRadius = 24
        return v
    }()

    private let illustrationIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "lock.rotation")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Colors.Primary.primary
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Create Your New Password"
        l.font = Typography.Heading.heading4
        l.textColor = Colors.Grayscale.gray900
        l.numberOfLines = 1
        l.textAlignment = .center
        return l
    }()

    // New Password field
    private let newPasswordContainer: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray50
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 1.5
        v.layer.borderColor = Colors.Grayscale.gray200.cgColor
        return v
    }()

    private let newPasswordIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "lock.fill")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Colors.Grayscale.gray400
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let newPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "New Password"
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()

    private lazy var newPasswordEyeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = Colors.Grayscale.gray400
        btn.addTarget(self, action: #selector(toggleNewPasswordVisibility), for: .touchUpInside)
        return btn
    }()

    // Confirm Password field
    private let confirmPasswordContainer: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray50
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 1.5
        v.layer.borderColor = Colors.Grayscale.gray200.cgColor
        return v
    }()

    private let confirmPasswordIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "lock.fill")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Colors.Grayscale.gray400
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm New Password"
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()

    private lazy var confirmPasswordEyeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = Colors.Grayscale.gray400
        btn.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
        return btn
    }()

    private var isRememberMeChecked = true

    private let rememberMeRow: UIView = {
        let v = UIView()
        return v
    }()

    private let rememberCheckbox: DSCheckboxView = {
        let cb = DSCheckboxView()
        cb.configure(with: SelectedViewModel(isSelected: true))
        return cb
    }()

    private let rememberLabel: UILabel = {
        let l = UILabel()
        l.text = "Remember Me"
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        return l
    }()

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

private extension CreateNewPasswordViewController {
    @objc func handleContinue() {
        RegistrationSuccessOverlay.present(
            iconSystemName: "checkmark.shield.fill",
            over: self,
            duration: 2.5
        ) { [weak self] in
            self?.onComplete?()
        }
    }

    @objc func toggleNewPasswordVisibility() {
        isNewPasswordVisible.toggle()
        newPasswordTextField.isSecureTextEntry = !isNewPasswordVisible
        let iconName = isNewPasswordVisible ? "eye" : "eye.slash"
        newPasswordEyeButton.setImage(
            UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
    }

    @objc func toggleConfirmPasswordVisibility() {
        isConfirmPasswordVisible.toggle()
        confirmPasswordTextField.isSecureTextEntry = !isConfirmPasswordVisible
        let iconName = isConfirmPasswordVisible ? "eye" : "eye.slash"
        confirmPasswordEyeButton.setImage(
            UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
    }
}

// MARK: - Setup

private extension CreateNewPasswordViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Create New Password"

        view.addSubview(illustrationView)
        illustrationView.addSubview(illustrationIcon)
        view.addSubview(subtitleLabel)

        setupPasswordField(
            container: newPasswordContainer,
            icon: newPasswordIcon,
            textField: newPasswordTextField,
            eyeButton: newPasswordEyeButton
        )
        setupPasswordField(
            container: confirmPasswordContainer,
            icon: confirmPasswordIcon,
            textField: confirmPasswordTextField,
            eyeButton: confirmPasswordEyeButton
        )

        view.addSubview(newPasswordContainer)
        view.addSubview(confirmPasswordContainer)
        view.addSubview(rememberMeRow)
        rememberMeRow.addSubview(rememberCheckbox)
        rememberMeRow.addSubview(rememberLabel)
        view.addSubview(continueButton)

        illustrationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(180)
        }
        illustrationIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrationView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        newPasswordContainer.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        confirmPasswordContainer.snp.makeConstraints { make in
            make.top.equalTo(newPasswordContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        rememberMeRow.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordContainer.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(24)
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
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
    }

    func setupPasswordField(
        container: UIView,
        icon: UIImageView,
        textField: UITextField,
        eyeButton: UIButton
    ) {
        container.addSubview(icon)
        container.addSubview(textField)
        container.addSubview(eyeButton)

        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        eyeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(12)
            make.trailing.equalTo(eyeButton.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
    }
}
