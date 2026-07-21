typealias Login = Module<LoginModuleInput, LoginModuleOutput>

final class LoginAssembly {
    func build(
        moduleOutput: LoginModuleOutput?,
        routingHandler: LoginRoutingHandlingProtocol
    ) -> Login {
        let view = LoginViewController(withoutXib: true)
        let interactor = LoginInteractor()
        let router = LoginRouter(viewController: view)
        let presenter = LoginPresenter(interactor: interactor, router: router, view: view, moduleOutput: moduleOutput)

        view.setOutput(presenter)
        interactor.output = presenter
        router.moduleRoutingHandler = routingHandler

        return Module(view: view, input: presenter, output: moduleOutput)
    }
}
