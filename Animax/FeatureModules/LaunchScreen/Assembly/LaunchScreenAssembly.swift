//  Created on 21.03.25

typealias LaunchScreen = Module<LaunchScreenModuleInput, LaunchScreenModuleOutput>

final class LaunchScreenAssembly {
	func build(
		moduleOutput: LaunchScreenModuleOutput?,
		routingHandler: LaunchScreenRoutingHandlingProtocol
	) -> LaunchScreen {
		// View
		let view = LaunchScreenViewController(withoutXib: true)

		// Interactor
		let interactor = LaunchScreenInteractor()

		// Router
		let router = LaunchScreenRouter(viewController: view)

		// Presenter
        let presenter = LaunchScreenPresenter(
            interactor: interactor,
            router: router,
            view: view,
            moduleOutput: moduleOutput
        )

		// Dependency Setup
		view.setOutput(presenter)
		interactor.output = presenter
		router.moduleRoutingHandler = routingHandler

		return Module(view: view, input: presenter, output: moduleOutput)
	}
}
