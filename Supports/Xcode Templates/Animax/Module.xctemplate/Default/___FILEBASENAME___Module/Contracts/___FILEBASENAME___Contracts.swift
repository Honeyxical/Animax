//  Created on ___DATE___

// Module Input
protocol ___VARIABLE_moduleName___ModuleInput {}

// Module Output
protocol ___VARIABLE_moduleName___ModuleOutput {}

// View Input
protocol ___VARIABLE_moduleName___ViewInput: AnyObject {
	func setTitle(_ title: String)
	func setOutput(_ output: ___VARIABLE_moduleName___ViewOutput)
}

// View Output
protocol ___VARIABLE_moduleName___ViewOutput {
	func viewDidLoad()
}

// Interactor Input
protocol ___VARIABLE_moduleName___InteractorInput {}

// Interactor Output
protocol ___VARIABLE_moduleName___InteractorOutput: AnyObject {}

// Router
protocol ___VARIABLE_moduleName___RouterInputProtocol {}

// Routing Handling
protocol ___VARIABLE_moduleName___RoutingHandlingProtocol {}
