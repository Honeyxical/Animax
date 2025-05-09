//  Created on 09.05.25

// Module Input
protocol OnboardingModuleInput {}

// Module Output
protocol OnboardingModuleOutput {}

// View Input
protocol OnboardingViewInput: AnyObject {
	func setTitle(_ title: String)
	func setOutput(_ output: OnboardingViewOutput)
}

// View Output
protocol OnboardingViewOutput {
	func viewDidLoad()
}

// Interactor Input
protocol OnboardingInteractorInput {}

// Interactor Output
protocol OnboardingInteractorOutput: AnyObject {}

// Router
protocol OnboardingRouterInputProtocol {}

// Routing Handling
protocol OnboardingRoutingHandlingProtocol {}
