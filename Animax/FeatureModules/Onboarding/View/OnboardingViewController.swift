import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    var output: OnboardingViewOutput?

    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let gradientView: OnboardingGradientView = {
        let v = OnboardingGradientView()
        v.isUserInteractionEnabled = true
        return v
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Heading.heading3
        label.textColor = Colors.Others.white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.Body.Medium.xLarge
        label.textColor = Colors.Others.white
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    private let pageDotsView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    private let startButton: DSButtonView = {
        let button = DSButtonView()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        output?.viewDidLoad()
    }
}

extension OnboardingViewController: OnboardingViewInput {
    func setOutput(_ output: OnboardingViewOutput) {
        self.output = output
    }

    func showBackgorundImage(_ image: UIImage) {
        backgroundImageView.image = image
    }

    func showTitleLabel(_ text: String) {
        titleLabel.text = text
    }

    func showDescriptionLabel(_ text: String) {
        descriptionLabel.text = text
    }

    func showStartButton(_ viewModel: DSButtonView.ViewModel) {
        startButton.configure(with: viewModel)
    }
}

private extension OnboardingViewController {
    func setup() {
        view.backgroundColor = Colors.Dark.dark1
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(gradientView)
        gradientView.addSubview(titleLabel)
        gradientView.addSubview(descriptionLabel)
        gradientView.addSubview(pageDotsView)
        gradientView.addSubview(startButton)

        buildPageDots(count: 3, activeIndex: 0)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(226)
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-48)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        pageDotsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(-24)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(pageDotsView.snp.top).offset(-20)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-12)
        }

        startButton.addTapGesture { [weak self] in
            self?.output?.didTapStart()
        }
    }

    func buildPageDots(count: Int, activeIndex: Int) {
        pageDotsView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<count {
            let dot = UIView()
            dot.layer.cornerRadius = 5
            if i == activeIndex {
                dot.backgroundColor = Colors.Primary.primary
                dot.snp.makeConstraints { make in
                    make.width.equalTo(24)
                    make.height.equalTo(10)
                }
            } else {
                dot.backgroundColor = Colors.Others.white.withAlphaComponent(0.4)
                dot.snp.makeConstraints { make in
                    make.width.height.equalTo(10)
                }
            }
            pageDotsView.addArrangedSubview(dot)
        }
    }
}
