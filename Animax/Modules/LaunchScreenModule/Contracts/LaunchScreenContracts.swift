//  Created on 21.03.25

// Module Input
protocol LaunchScreenModuleInput {}

// Module Output
protocol LaunchScreenModuleOutput {}

// View Input
protocol LaunchScreenViewInput: AnyObject {
	func setOutput(_ output: LaunchScreenViewOutput)
}

// View Output
protocol LaunchScreenViewOutput {
    func viewDidLoad()
	func viewWillAppear()
}

// Interactor Input
protocol LaunchScreenInteractorInput {}

// Interactor Output
protocol LaunchScreenInteractorOutput: AnyObject {}

// Router
protocol LaunchScreenRouterInputProtocol {}

// Routing Handling
protocol LaunchScreenRoutingHandlingProtocol {}
