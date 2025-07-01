//  Created on 09.05.25

import UIKit

// Module Input
protocol OnboardingModuleInput {}

// Module Output
protocol OnboardingModuleOutput {}

// View Input
protocol OnboardingViewInput: AnyObject {
	func setOutput(_ output: OnboardingViewOutput)
    func showBackgorundImage(_ image: UIImage)
    func showStartButton(_ viewModel: DSButtonView.ViewModel)
    func showTitleLabel(_ text: String)
    func showDescriptionLabel(_ text: String)
}

// View Output
protocol OnboardingViewOutput {
	func viewDidLoad()
}

// Interactor Input
protocol OnboardingInteractorInput {
    func start()
}

// Interactor Output
protocol OnboardingInteractorOutput: AnyObject {
    func presentStaticData()
}

// Router
protocol OnboardingRouterInputProtocol {}

// Routing Handling
protocol OnboardingRoutingHandlingProtocol {}
