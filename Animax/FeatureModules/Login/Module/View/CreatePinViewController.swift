import UIKit
import SnapKit

final class CreatePinViewController: BaseViewController {

    var onContinue: (() -> Void)?

    private var pinDigits: [String] = []
    private let pinLength = 4

    // MARK: - UI

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Add a PIN number to make your account more secure."
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray700
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    private let pinBoxesStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 16
        sv.distribution = .fillEqually
        return sv
    }()

    private lazy var continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(Colors.Others.white, for: .normal)
        btn.titleLabel?.font = Typography.Body.Bold.large
        btn.backgroundColor = Colors.Primary.primary
        btn.layer.cornerRadius = 29
        btn.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        btn.alpha = 0.5
        btn.isEnabled = false
        return btn
    }()

    private let keypadView = UIView()
    private var pinBoxViews: [PinBoxView] = []

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

private extension CreatePinViewController {
    @objc func handleContinue() {
        onContinue?()
    }

    func handleKeyTap(_ digit: String) {
        guard pinDigits.count < pinLength else { return }
        pinDigits.append(digit)
        refreshPinBoxes()
        if pinDigits.count == pinLength {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        }
    }

    func handleDelete() {
        guard !pinDigits.isEmpty else { return }
        pinDigits.removeLast()
        refreshPinBoxes()
        continueButton.alpha = 0.5
        continueButton.isEnabled = false
    }

    func refreshPinBoxes() {
        for (index, box) in pinBoxViews.enumerated() {
            if index < pinDigits.count - 1 {
                box.setState(.filled)
            } else if index == pinDigits.count - 1 {
                box.setState(.current(digit: pinDigits[index]))
            } else {
                box.setState(.empty)
            }
        }
    }
}

// MARK: - Setup

private extension CreatePinViewController {
    func setup() {
        view.backgroundColor = .white
        title = "Create New PIN"

        for _ in 0..<pinLength {
            let box = PinBoxView()
            box.setState(.empty)
            pinBoxesStack.addArrangedSubview(box)
            pinBoxViews.append(box)
        }

        buildKeypad()

        view.addSubview(subtitleLabel)
        view.addSubview(pinBoxesStack)
        view.addSubview(continueButton)
        view.addSubview(keypadView)

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.trailing.equalToSuperview().inset(48)
        }
        pinBoxesStack.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.height.equalTo(72)
            make.width.equalToSuperview().multipliedBy(0.72)
        }
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(pinBoxesStack.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        keypadView.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(16)
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
                    btn.tag = Int(key) ?? 0
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

// MARK: - PinBoxView

private final class PinBoxView: UIView {
    enum State {
        case empty
        case filled
        case current(digit: String)
    }

    private let dotView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.Grayscale.gray900
        v.layer.cornerRadius = 10
        v.isHidden = true
        return v
    }()

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

        addSubview(dotView)
        addSubview(digitLabel)

        dotView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        digitLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func setState(_ state: State) {
        switch state {
        case .empty:
            dotView.isHidden = true
            digitLabel.isHidden = true
            layer.borderColor = Colors.Grayscale.gray200.cgColor
            backgroundColor = Colors.Grayscale.gray50
        case .filled:
            dotView.isHidden = false
            digitLabel.isHidden = true
            layer.borderColor = Colors.Grayscale.gray200.cgColor
            backgroundColor = Colors.Grayscale.gray50
        case .current(let digit):
            dotView.isHidden = true
            digitLabel.isHidden = false
            digitLabel.text = digit
            layer.borderColor = Colors.Primary.primary.cgColor
            backgroundColor = Colors.Transparent.green
        }
    }
}
