typealias AnimeDetail = Module<AnimeDetailModuleInput, AnimeDetailModuleOutput>

final class AnimeDetailAssembly {
    private let networkService: AnimeNetworkServiceProtocol
    private let watchlistService: WatchlistServiceProtocol

    init(networkService: AnimeNetworkServiceProtocol, watchlistService: WatchlistServiceProtocol) {
        self.networkService = networkService
        self.watchlistService = watchlistService
    }

    func build(
        animeId: Int,
        moduleOutput: AnimeDetailModuleOutput?,
        routingHandler: AnimeDetailRoutingHandlingProtocol
    ) -> AnimeDetail {
        let view = AnimeDetailViewController(withoutXib: true)
        let interactor = AnimeDetailInteractor(networkService: networkService, watchlistService: watchlistService)
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
