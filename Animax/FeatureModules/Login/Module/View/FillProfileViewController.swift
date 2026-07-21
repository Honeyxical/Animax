import UIKit
import SnapKit

final class FillProfileViewController: BaseViewController {

    var onContinue: (() -> Void)?

    private var selectedGender: String?

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    private let contentView = UIView()

    // Avatar
    private let avatarContainer = UIView()
    private let avatarBackground: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray100
        v.layer.cornerRadius = 60
        v.clipsToBounds = true
        return v
    }()
    private let avatarPlaceholder: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate))
        iv.tintColor = Colors.Grayscale.gray300
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var editButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "pencil")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(handleEditAvatar), for: .touchUpInside)
        return btn
    }()

    // Fields
    private let fullNameField = makeField(placeholder: "Full Name")
    private let nicknameField = makeField(placeholder: "Nickname")
    private let emailField = makeFieldWithRightIcon(placeholder: "Email", icon: "envelope")
    private let phoneContainer = UIView()
    private let genderContainer = UIView()

    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.keyboardType = .phonePad
        tf.attributedPlaceholder = NSAttributedString(
            string: "Phone Number",
            attributes: [.foregroundColor: Colors.Grayscale.gray500]
        )
        return tf
    }()

    private lazy var genderButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Gender", for: .normal)
        btn.setTitleColor(Colors.Grayscale.gray500, for: .normal)
        btn.titleLabel?.font = Typography.Body.Regular.medium
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(handleGenderTap), for: .touchUpInside)
        return btn
    }()

    // Bottom
    private lazy var skipButton: UIButton = makeBottomButton(
        title: "Skip", titleColor: Colors.Grayscale.gray500, bg: Colors.Grayscale.gray100,
        action: #selector(handleSkip)
    )
    private lazy var continueButton: UIButton = makeBottomButton(
        title: "Continue", titleColor: Colors.Others.white, bg: Colors.Primary.primary,
        action: #selector(handleContinue)
    )

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

private extension FillProfileViewController {
    @objc func handleEditAvatar() {
        // Visual only in this version
    }

    @objc func handleGenderTap() {
        let sheet = UIAlertController(title: "Gender", message: nil, preferredStyle: .actionSheet)
        ["Male", "Female", "Other", "Prefer not to say"].forEach { option in
            sheet.addAction(UIAlertAction(title: option, style: .default) { [weak self] _ in
                self?.selectedGender = option
                self?.genderButton.setTitle(option, for: .normal)
                self?.genderButton.setTitleColor(Colors.Grayscale.gray900, for: .normal)
            })
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

    @objc func handleSkip() {
        onContinue?()
    }

    @objc func handleContinue() {
        onContinue?()
    }
}

// MARK: - Setup

private extension FillProfileViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Fill Your Profile"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarBackground)
        avatarBackground.addSubview(avatarPlaceholder)
        avatarContainer.addSubview(editButton)

        contentView.addSubview(fullNameField)
        contentView.addSubview(nicknameField)
        contentView.addSubview(emailField)

        setupPhoneField()
        contentView.addSubview(phoneContainer)

        setupGenderField()
        contentView.addSubview(genderContainer)

        let bottomBar = makeBottomBar()
        view.addSubview(bottomBar)

        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomBar.snp.top)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        avatarContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(140)
        }
        avatarBackground.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(120)
        }
        avatarPlaceholder.snp.makeConstraints { make in
            make.center.equalTo(avatarBackground)
            make.width.height.equalTo(60)
        }
        editButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(36)
        }

        fullNameField.snp.makeConstraints { make in
            make.top.equalTo(avatarContainer.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        nicknameField.snp.makeConstraints { make in
            make.top.equalTo(fullNameField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(nicknameField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        phoneContainer.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        genderContainer.snp.makeConstraints { make in
            make.top.equalTo(phoneContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-16)
        }

        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(50)
        }
    }

    func setupPhoneField() {
        phoneContainer.backgroundColor = Colors.Grayscale.gray50
        phoneContainer.layer.cornerRadius = 16

        let flagLabel = UILabel()
        flagLabel.text = "🇺🇸"
        flagLabel.font = .systemFont(ofSize: 22)

        let chevron = UIImageView(image: UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate))
        chevron.tintColor = Colors.Grayscale.gray500
        chevron.contentMode = .scaleAspectFit

        phoneContainer.addSubview(flagLabel)
        phoneContainer.addSubview(chevron)
        phoneContainer.addSubview(phoneTextField)

        flagLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        chevron.snp.makeConstraints { make in
            make.leading.equalTo(flagLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        phoneTextField.snp.makeConstraints { make in
            make.leading.equalTo(chevron.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(16)
        }
    }

    func setupGenderField() {
        genderContainer.backgroundColor = Colors.Grayscale.gray50
        genderContainer.layer.cornerRadius = 16

        let chevron = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill")?.withRenderingMode(.alwaysTemplate))
        chevron.tintColor = Colors.Grayscale.gray400
        chevron.contentMode = .scaleAspectFit

        genderContainer.addSubview(genderButton)
        genderContainer.addSubview(chevron)
        genderContainer.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGenderTap))
        genderContainer.addGestureRecognizer(tap)

        genderButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(chevron.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(16)
        }
        chevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(8)
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

    static func makeField(placeholder: String) -> UIView {
        let container = UIView()
        container.backgroundColor = Colors.Grayscale.gray50
        container.layer.cornerRadius = 16

        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: Colors.Grayscale.gray500]
        )

        container.addSubview(tf)
        tf.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
        }
        return container
    }

    static func makeFieldWithRightIcon(placeholder: String, icon: String) -> UIView {
        let container = UIView()
        container.backgroundColor = Colors.Grayscale.gray50
        container.layer.cornerRadius = 16

        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = Typography.Body.Regular.medium
        tf.textColor = Colors.Grayscale.gray900
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: Colors.Grayscale.gray500]
        )
        let iconView = UIImageView(image: UIImage(systemName: icon)?.withRenderingMode(.alwaysTemplate))
        iconView.tintColor = Colors.Grayscale.gray400
        iconView.contentMode = .scaleAspectFit

        container.addSubview(tf)
        container.addSubview(iconView)

        iconView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        tf.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(iconView.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(16)
        }
        return container
    }

    func makeBottomButton(title: String, titleColor: UIColor, bg: UIColor, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = Typography.Body.Semibold.large
        btn.backgroundColor = bg
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }
}
