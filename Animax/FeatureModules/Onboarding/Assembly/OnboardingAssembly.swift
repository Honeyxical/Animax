//  Created on 09.05.25

typealias Onboarding = Module<OnboardingModuleInput, OnboardingModuleOutput>

final class OnboardingAssembly {
	func build(
		moduleOutput: OnboardingModuleOutput?,
		routingHandler: OnboardingRoutingHandlingProtocol
	) -> Onboarding {
		// View
		let view = OnboardingViewController(withoutXib: true)

		// Interactor
		let interactor = OnboardingInteractor()

		// Router
		let router = OnboardingRouter(viewController: view)

		// Presenter
        let presenter = OnboardingPresenter(interactor: interactor, router: router, view: view, moduleOutput: moduleOutput)

		// Dependency Setup
		view.setOutput(presenter)
		interactor.output = presenter
		router.moduleRoutingHandler = routingHandler

		return Module(view: view, input: presenter, output: moduleOutput)
	}
}
