import UIKit
import SnapKit

final class OTPViewController: BaseViewController {

    var onVerify: (() -> Void)?

    private var otpDigits: [String] = []
    private let otpLength = 4
    private var countdownSeconds = 60
    private var countdownTimer: Timer?

    // MARK: - UI

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Code has been send to +1 111 ******99"
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    private let otpBoxesStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 16
        sv.distribution = .fillEqually
        return sv
    }()

    private lazy var verifyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Verify", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Bold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 29
        btn.addTarget(self, action: #selector(handleVerify), for: .touchUpInside)
        btn.alpha = 0.5
        btn.isEnabled = false
        return btn
    }()

    private let resendLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = Typography.Body.Regular.medium
        return l
    }()

    private let keypadView = UIView()
    private var otpBoxViews: [OTPBoxView] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startCountdown()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    deinit {
        countdownTimer?.invalidate()
    }
}

// MARK: - Actions

private extension OTPViewController {
    @objc func handleVerify() {
        onVerify?()
    }

    func handleKeyTap(_ digit: String) {
        guard otpDigits.count < otpLength else { return }
        otpDigits.append(digit)
        refreshOTPBoxes()
        if otpDigits.count == otpLength {
            verifyButton.alpha = 1.0
            verifyButton.isEnabled = true
        }
    }

    func handleDelete() {
        guard !otpDigits.isEmpty else { return }
        otpDigits.removeLast()
        refreshOTPBoxes()
        if otpDigits.count < otpLength {
            verifyButton.alpha = 0.5
            verifyButton.isEnabled = false
        }
    }

    func refreshOTPBoxes() {
        for (index, box) in otpBoxViews.enumerated() {
            if index < otpDigits.count - 1 {
                box.setState(.filled(digit: otpDigits[index]))
            } else if index == otpDigits.count - 1 {
                box.setState(.current(digit: otpDigits[index]))
            } else {
                box.setState(.empty)
            }
        }
    }

    func startCountdown() {
        countdownSeconds = 60
        updateResendLabel()
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(tickCountdown),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func tickCountdown() {
        countdownSeconds -= 1
        if countdownSeconds <= 0 {
            countdownTimer?.invalidate()
            countdownTimer = nil
            showResendButton()
        } else {
            updateResendLabel()
        }
    }

    func updateResendLabel() {
        let prefix = "Resend code in "
        let seconds = "\(countdownSeconds) s"
        let full = prefix + seconds
        let attr = NSMutableAttributedString(
            string: full,
            attributes: [
                .font: Typography.Body.Regular.medium as Any,
                .foregroundColor: Colors.Grayscale.gray500
            ]
        )
        attr.addAttributes(
            [
                .foregroundColor: Colors.Primary.primary,
                .font: Typography.Body.Semibold.medium as Any
            ],
            range: (full as NSString).range(of: seconds)
        )
        resendLabel.attributedText = attr
    }

    func showResendButton() {
        let full = "Didn't receive code? Resend"
        let attr = NSMutableAttributedString(
            string: full,
            attributes: [
                .font: Typography.Body.Regular.medium as Any,
                .foregroundColor: Colors.Grayscale.gray500
            ]
        )
        attr.addAttributes(
            [
                .foregroundColor: Colors.Primary.primary,
                .font: Typography.Body.Semibold.medium as Any
            ],
            range: (full as NSString).range(of: "Resend")
        )
        resendLabel.attributedText = attr
        resendLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleResend))
        resendLabel.addGestureRecognizer(tap)
    }

    @objc func handleResend() {
        otpDigits = []
        refreshOTPBoxes()
        verifyButton.alpha = 0.5
        verifyButton.isEnabled = false
        startCountdown()
    }
}

// MARK: - Setup

private extension OTPViewController {
    func setup() {
        view.backgroundColor = .white
        title = "OTP Verification"

        for _ in 0..<otpLength {
            let box = OTPBoxView()
            box.setState(.empty)
            otpBoxesStack.addArrangedSubview(box)
            otpBoxViews.append(box)
        }

        buildKeypad()

        view.addSubview(subtitleLabel)
        view.addSubview(otpBoxesStack)
        view.addSubview(resendLabel)
        view.addSubview(verifyButton)
        view.addSubview(keypadView)

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.trailing.equalToSuperview().inset(48)
        }
        otpBoxesStack.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(72)
            make.width.equalToSuperview().multipliedBy(0.72)
        }
        resendLabel.snp.makeConstraints { make in
            make.top.equalTo(otpBoxesStack.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(resendLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        keypadView.snp.makeConstraints { make in
            make.top.equalTo(verifyButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func buildKeypad() {
        let keys: [[String]] = [
            ["1", "2", "3"],
            ["4", "5", "6"],
            ["7", "8", "9"],
            ["*", "0", "⌫"]
        ]

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 4
        rowStack.distribution = .fillEqually

        keypadView.backgroundColor = Colors.Grayscale.gray50
        keypadView.addSubview(rowStack)
        rowStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        for row in keys {
            let colStack = UIStackView()
            colStack.axis = .horizontal
            colStack.distribution = .fillEqually
            colStack.spacing = 0

            for key in row {
                let btn = UIButton(type: .system)
                if key == "⌫" {
                    btn.setImage(
                        UIImage(systemName: "delete.left")?.withRenderingMode(.alwaysTemplate),
                        for: .normal
                    )
                    btn.tintColor = Colors.Grayscale.gray700
                    btn.addTarget(self, action: #selector(handleDeleteTap), for: .touchUpInside)
                } else if key == "*" {
                    btn.setTitle(key, for: .normal)
                    btn.setTitleColor(Colors.Grayscale.gray700, for: .normal)
                    btn.titleLabel?.font = Typography.Body.Regular.xLarge
                } else {
                    btn.setTitle(key, for: .normal)
                    btn.setTitleColor(Colors.Grayscale.gray900, for: .normal)
                    btn.titleLabel?.font = .systemFont(ofSize: 28, weight: .regular)
                    btn.addTarget(self, action: #selector(handleDigitTap(_:)), for: .touchUpInside)
                }
                colStack.addArrangedSubview(btn)
            }
            rowStack.addArrangedSubview(colStack)
        }
    }

    @objc func handleDigitTap(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        handleKeyTap(title)
    }

    @objc func handleDeleteTap() {
        handleDelete()
    }
}

// MARK: - OTPBoxView

private final class OTPBoxView: UIView {
    enum State {
        case empty
        case filled(digit: String)
        case current(digit: String)
    }

    private let digitLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 24, weight: .medium)
        l.textColor = Colors.Grayscale.gray900
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.Grayscale.gray50
        layer.cornerRadius = 12
        layer.borderWidth = 1.5
        layer.borderColor = Colors.Grayscale.gray200.cgColor

        addSubview(digitLabel)
        digitLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func setState(_ state: State) {
        switch state {
        case .empty:
            digitLabel.isHidden = true
            digitLabel.text = nil
            layer.borderColor = Colors.Grayscale.gray200.cgColor
            backgroundColor = Colors.Grayscale.gray50
        case .filled(let digit):
            digitLabel.isHidden = false
            digitLabel.text = digit
            layer.borderColor = Colors.Grayscale.gray200.cgColor
            backgroundColor = Colors.Grayscale.gray50
        case .current(let digit):
            digitLabel.isHidden = false
            digitLabel.text = digit
            layer.borderColor = Colors.Primary.primary.cgColor
            backgroundColor = Colors.Transparent.green
        }
    }
}
