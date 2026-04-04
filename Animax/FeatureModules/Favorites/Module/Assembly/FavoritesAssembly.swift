typealias Favorites = Module<FavoritesModuleInput, FavoritesModuleOutput>

final class FavoritesAssembly {
    private let watchlistService: WatchlistServiceProtocol

    init(watchlistService: WatchlistServiceProtocol) {
        self.watchlistService = watchlistService
    }

    func build(
        moduleOutput: FavoritesModuleOutput?,
        routingHandler: FavoritesRoutingHandlingProtocol
    ) -> Favorites {
        let view = FavoritesViewController(withoutXib: true)
        let interactor = FavoritesInteractor(watchlistService: watchlistService)
        let router = FavoritesRouter(viewController: view)
        let presenter = FavoritesPresenter(interactor: interactor, router: router, view: view, moduleOutput: moduleOutput)

        view.setOutput(presenter)
        interactor.output = presenter
        router.moduleRoutingHandler = routingHandler

        return Module(view: view, input: presenter, output: moduleOutput)
    }
}
