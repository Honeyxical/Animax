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
    func didTapStart()
}

// Interactor Input
protocol OnboardingInteractorInput {
    func start()
    func openHome()
}

// Interactor Output
protocol OnboardingInteractorOutput: AnyObject {
    func presentStaticData()
    func presentHome()
}

// Router
protocol OnboardingRouterInputProtocol {
    func routeHome()
}

// Routing Handling
protocol OnboardingRoutingHandlingProtocol {
    func prepareForRouteHome()
}
