final class FavoritesInteractor {
    weak var output: FavoritesInteractorOutput?
    private let watchlistService: WatchlistServiceProtocol

    init(watchlistService: WatchlistServiceProtocol) {
        self.watchlistService = watchlistService
    }
}

extension FavoritesInteractor: FavoritesInteractorInput {
    func loadFavorites() {
        let items = watchlistService.getFavorites()
        output?.presentFavorites(items)
    }

    func removeFavorite(id: Int) {
        let favorites = watchlistService.getFavorites()
        if let item = favorites.first(where: { $0.id == id }) {
            watchlistService.toggleFavorite(item)
        }
        loadFavorites()
    }
}
