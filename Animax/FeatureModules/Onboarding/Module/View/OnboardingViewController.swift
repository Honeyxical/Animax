//  Created on 09.05.25

import SnapKit

final class OnboardingViewController: BaseViewController {
	var output: OnboardingViewOutput?
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = OnboardingGradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Typography.Heading.heading3
        label.textColor = Colors.Others.white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Typography.Body.Medium.xLarge
        label.textColor = Colors.Others.white
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private let startButton: DSButton = {
        let button = DSButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    func showStartButton(_ viewModel: DSButton.ViewModel) {
        startButton.configure(with: viewModel)
    }
}

private extension OnboardingViewController {
    func setup() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(gradientView)
        gradientView.addSubview(startButton)
        gradientView.addSubview(titleLabel)
        gradientView.addSubview(descriptionLabel)
        
        backgroundImageView.snp.makeConstraints { view in
            view.horizontalEdges.verticalEdges.equalToSuperview()
        }
        gradientView.snp.makeConstraints { view in
            view.leading.trailing.bottom.equalToSuperview()
            view.top.equalToSuperview().offset(226)
        }
        startButton.snp.makeConstraints { view in
            view.bottom.equalToSuperview().offset(-48)
            view.leading.equalToSuperview().offset(24)
            view.trailing.equalToSuperview().offset(-24)
        }
        titleLabel.snp.makeConstraints { view in
            view.leading.equalToSuperview().offset(24)
            view.trailing.equalToSuperview().offset(-24)
            view.bottom.equalTo(descriptionLabel.snp_topMargin).offset(-24)
        }
        descriptionLabel.snp.makeConstraints { view in
            view.leading.equalToSuperview().offset(24)
            view.trailing.equalToSuperview().offset(-24)
            view.bottom.equalToSuperview().offset(-162)
        }
    }
}
