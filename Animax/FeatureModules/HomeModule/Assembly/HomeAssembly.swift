//  Created on 22.11.25

typealias Home = Module<HomeModuleInput, HomeModuleOutput>

final class HomeAssembly {
	func build(
		moduleOutput: HomeModuleOutput?,
		routingHandler: HomeRoutingHandlingProtocol
	) -> Home {
		// View
		let view = HomeViewController(withoutXib: true)

		// Interactor
		let interactor = HomeInteractor()

		// Router
		let router = HomeRouter(viewController: view)

		// Presenter
        let presenter = HomePresenter(interactor: interactor, router: router, view: view, moduleOutput: moduleOutput)

		// Dependency Setup
		view.setOutput(presenter)
		interactor.output = presenter
		router.moduleRoutingHandler = routingHandler

		return Module(view: view, input: presenter, output: moduleOutput)
	}
}
