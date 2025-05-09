//  Created on ___DATE___

typealias ___VARIABLE_moduleName___ = Module<___VARIABLE_moduleName___ModuleInput, ___VARIABLE_moduleName___ModuleOutput>

final class ___VARIABLE_moduleName___Assembly {
	func build(
		moduleOutput: ___VARIABLE_moduleName___ModuleOutput?,
		routingHandler: ___VARIABLE_moduleName___RoutingHandlingProtocol
	) -> ___VARIABLE_moduleName___ {
		// View
		let view = ___VARIABLE_moduleName___ViewController(withoutXib: true)

		// Interactor
		let interactor = ___VARIABLE_moduleName___Interactor()

		// Router
		let router = ___VARIABLE_moduleName___Router(viewController: view)

		// Presenter
		let presenter = ___VARIABLE_moduleName___Presenter(interactor: interactor, routemr: router, view: view, moduleOutput: moduleOutput)

		// Dependency Setup
		view.setOutput(presenter)
		interactor.output = presenter
		router.moduleRoutingHandler = routingHandler

		return Module(view: view, input: presenter, output: moduleOutput)
	}
}
