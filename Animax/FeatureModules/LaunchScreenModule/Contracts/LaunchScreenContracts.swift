//  Created on 21.03.25

// Module Input
protocol LaunchScreenModuleInput {}

// Module Output
protocol LaunchScreenModuleOutput {}

// View Input
protocol LaunchScreenViewInput: AnyObject {
	func setOutput(_ output: LaunchScreenViewOutput)
    func startAnimation()
}

// View Output
protocol LaunchScreenViewOutput {
    func viewDidLoad()
}

// Interactor Input
protocol LaunchScreenInteractorInput {
    func start()
}

// Interactor Output
protocol LaunchScreenInteractorOutput: AnyObject {
    func presentLoadingAnimation()
    func presentOnboarding()
}

// Router
protocol LaunchScreenRouterInputProtocol {
    func routeToOnboarding()
}

// Routing Handling
protocol LaunchScreenRoutingHandlingProtocol {
    func performRouteToOnboarding()
}
