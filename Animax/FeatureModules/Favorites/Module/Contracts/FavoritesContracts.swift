import UIKit

// Module Input
protocol FavoritesModuleInput {}

// Module Output
protocol FavoritesModuleOutput {}

// View Input
protocol FavoritesViewInput: AnyObject {
    func setOutput(_ output: FavoritesViewOutput)
    func showFavorites(_ items: [AnimeCardViewModel])
    func showEmptyState()
}

// View Output
protocol FavoritesViewOutput {
    func viewWillAppear()
    func didSelectAnime(id: Int)
    func didRemoveFavorite(id: Int, title: String)
}

// Interactor Input
protocol FavoritesInteractorInput {
    func loadFavorites()
    func removeFavorite(id: Int)
}

// Interactor Output
protocol FavoritesInteractorOutput: AnyObject {
    func presentFavorites(_ items: [WatchlistItem])
}

// Router
protocol FavoritesRouterInputProtocol {
    func routeToAnimeDetail(id: Int)
}

// Routing Handling
protocol FavoritesRoutingHandlingProtocol {
    func performRouteToAnimeDetailFromFavorites(id: Int)
}
