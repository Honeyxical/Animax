import UIKit
import SnapKit

final class GiveRatingViewController: UIViewController {

    private var selectedStars = 0
    private var starButtons: [UIButton] = []

    private let overallScore: Double = 9.8
    private let totalUsers = 69_575
    private let distribution: [CGFloat] = [0.72, 0.15, 0.07, 0.04, 0.02]

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Give Rating"
        l.font = Typography.Heading.heading5
        l.textColor = Colors.Grayscale.gray900
        l.textAlignment = .center
        return l
    }()

    private let scoreLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        l.textColor = Colors.Grayscale.gray900
        return l
    }()

    private let outOfLabel: UILabel = {
        let l = UILabel()
        l.text = "/10"
        l.font = Typography.Body.Regular.medium
        l.textColor = Colors.Grayscale.gray500
        return l
    }()

    private let miniStarsView = UIView()

    private let usersLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.Body.Regular.xSmall
        l.textColor = Colors.Grayscale.gray500
        return l
    }()

    private let barsContainer = UIView()
    private let interactiveStarsStack = UIStackView()

    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(Colors.Grayscale.gray700, for: .normal)
        btn.backgroundColor = Colors.Grayscale.gray100
        btn.titleLabel?.font = Typography.Body.Semibold.medium
        btn.layer.cornerRadius = 24
        btn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return btn
    }()

    private lazy var submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = Colors.Primary.primary
        btn.titleLabel?.font = Typography.Body.Semibold.medium
        btn.layer.cornerRadius = 24
        btn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scoreLabel.text = String(format: "%.1f", overallScore)
        usersLabel.text = "(\(formatNumber(totalUsers)) users)"
        setup()
    }

    @objc private func cancelTapped() { dismiss(animated: true) }
    @objc private func submitTapped() { dismiss(animated: true) }

    @objc private func starTapped(_ sender: UIButton) {
        selectedStars = sender.tag
        let cfg = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        for (i, btn) in starButtons.enumerated() {
            let filled = (i + 1) <= selectedStars
            btn.setImage(UIImage(systemName: filled ? "star.fill" : "star", withConfiguration: cfg), for: .normal)
            btn.tintColor = filled ? Colors.Primary.primary : Colors.Grayscale.gray300
        }
    }

    private func setup() {
        buildMiniStars()
        buildBars()
        buildInteractiveStars()

        let actionStack = UIStackView(arrangedSubviews: [cancelButton, submitButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 12
        actionStack.distribution = .fillEqually

        [titleLabel, scoreLabel, outOfLabel, miniStarsView, usersLabel,
         barsContainer, interactiveStarsStack, actionStack].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(32)
        }
        outOfLabel.snp.makeConstraints {
            $0.lastBaseline.equalTo(scoreLabel)
            $0.leading.equalTo(scoreLabel.snp.trailing).offset(2)
        }
        miniStarsView.snp.makeConstraints {
            $0.top.equalTo(scoreLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(32)
        }
        usersLabel.snp.makeConstraints {
            $0.top.equalTo(miniStarsView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(32)
        }
        barsContainer.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.trailing.equalToSuperview().inset(32)
            $0.width.equalTo(140)
            $0.height.equalTo(CGFloat(distribution.count) * 18)
        }
        interactiveStarsStack.snp.makeConstraints {
            $0.top.equalTo(usersLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        actionStack.snp.makeConstraints {
            $0.top.equalTo(interactiveStarsStack.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
            $0.bottom.lessThanOrEqualToSuperview().inset(32)
        }
    }

    private func buildMiniStars() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        for _ in 0..<5 {
            let cfg = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
            let iv = UIImageView(image: UIImage(systemName: "star.fill", withConfiguration: cfg))
            iv.tintColor = Colors.Primary.primary
            stack.addArrangedSubview(iv)
        }
        miniStarsView.addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func buildBars() {
        for (i, pct) in distribution.enumerated() {
            let num = UILabel()
            num.text = "\(5 - i)"
            num.font = Typography.Body.Regular.xSmall
            num.textColor = Colors.Grayscale.gray500
            num.textAlignment = .right

            let bg = UIView()
            bg.backgroundColor = Colors.Grayscale.gray200
            bg.layer.cornerRadius = 3

            let fill = UIView()
            fill.backgroundColor = Colors.Primary.primary
            fill.layer.cornerRadius = 3

            barsContainer.addSubview(num)
            barsContainer.addSubview(bg)
            bg.addSubview(fill)

            let y = CGFloat(i) * 18
            num.snp.makeConstraints {
                $0.top.equalToSuperview().offset(y)
                $0.leading.equalToSuperview()
                $0.width.equalTo(14)
            }
            bg.snp.makeConstraints {
                $0.centerY.equalTo(num)
                $0.leading.equalTo(num.snp.trailing).offset(6)
                $0.trailing.equalToSuperview()
                $0.height.equalTo(6)
            }
            fill.snp.makeConstraints {
                $0.leading.top.bottom.equalToSuperview()
                $0.width.equalTo(bg).multipliedBy(pct)
            }
        }
    }

    private func buildInteractiveStars() {
        interactiveStarsStack.axis = .horizontal
        interactiveStarsStack.spacing = 8
        interactiveStarsStack.distribution = .fillEqually
        let cfg = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        for i in 1...5 {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: "star", withConfiguration: cfg), for: .normal)
            btn.tintColor = Colors.Grayscale.gray300
            btn.tag = i
            btn.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starButtons.append(btn)
            interactiveStarsStack.addArrangedSubview(btn)
        }
    }

    private func formatNumber(_ n: Int) -> String {
        n >= 1000 ? String(format: "%.1fK", Double(n) / 1000.0) : "\(n)"
    }
}
