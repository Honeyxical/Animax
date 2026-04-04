typealias Profile = Module<ProfileModuleInput, ProfileModuleOutput>

final class ProfileAssembly {
    private let watchlistService: WatchlistServiceProtocol

    init(watchlistService: WatchlistServiceProtocol) {
        self.watchlistService = watchlistService
    }

    func build(
        moduleOutput: ProfileModuleOutput?,
        routingHandler: ProfileRoutingHandlingProtocol
    ) -> Profile {
        let view = ProfileViewController(withoutXib: true)
        let interactor = ProfileInteractor(watchlistService: watchlistService)
        let router = ProfileRouter(viewController: view)
        let presenter = ProfilePresenter(interactor: interactor, router: router, view: view, moduleOutput: moduleOutput)

        view.setOutput(presenter)
        interactor.output = presenter
        router.moduleRoutingHandler = routingHandler

        return Module(view: view, input: presenter, output: moduleOutput)
    }
}
