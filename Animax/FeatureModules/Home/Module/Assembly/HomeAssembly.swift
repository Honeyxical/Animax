typealias Home = Module<HomeModuleInput, HomeModuleOutput>

final class HomeAssembly {
    private let networkService: AnimeNetworkServiceProtocol

    init(networkService: AnimeNetworkServiceProtocol) {
        self.networkService = networkService
    }

    func build(
        moduleOutput: HomeModuleOutput?,
        routingHandler: HomeRoutingHandlingProtocol
    ) -> Home {
        let view = HomeViewController(withoutXib: true)
        let interactor = HomeInteractor(networkService: networkService)
        let router = HomeRouter(viewController: view)
        let presenter = HomePresenter(interactor: interactor, router: router, view: view, moduleOutput: moduleOutput)

        view.setOutput(presenter)
        interactor.output = presenter
        router.moduleRoutingHandler = routingHandler

        return Module(view: view, input: presenter, output: moduleOutput)
    }
}
