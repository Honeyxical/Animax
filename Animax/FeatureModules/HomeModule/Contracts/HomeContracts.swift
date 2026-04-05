//  Created on 22.11.25

// Module Input
protocol HomeModuleInput {}

// Module Output
protocol HomeModuleOutput {}

// View Input
protocol HomeViewInput: AnyObject {
	func setTitle(_ title: String)
	func setOutput(_ output: HomeViewOutput)
}

// View Output
protocol HomeViewOutput {
	func viewDidLoad()
}

// Interactor Input
protocol HomeInteractorInput {}

// Interactor Output
protocol HomeInteractorOutput: AnyObject {}

// Router
protocol HomeRouterInputProtocol {}

// Routing Handling
protocol HomeRoutingHandlingProtocol {}
