typealias AnimeDetail = Module<AnimeDetailModuleInput, AnimeDetailModuleOutput>

final class AnimeDetailAssembly {
    private let networkService: AnimeNetworkServiceProtocol

    init(networkService: AnimeNetworkServiceProtocol) {
        self.networkService = networkService
    }

    func build(
        animeId: Int,
        moduleOutput: AnimeDetailModuleOutput?,
        routingHandler: AnimeDetailRoutingHandlingProtocol
    ) -> AnimeDetail {
        let view = AnimeDetailViewController(withoutXib: true)
        let interactor = AnimeDetailInteractor(networkService: networkService)
        let router = AnimeDetailRouter(viewController: view)
        let presenter = AnimeDetailPresenter(
            animeId: animeId,
            interactor: interactor,
            router: router,
            view: view,
            moduleOutput: moduleOutput
        )

        view.setOutput(presenter)
        interactor.output = presenter
        router.moduleRoutingHandler = routingHandler

        return Module(view: view, input: presenter, output: moduleOutput)
    }
}
