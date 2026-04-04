final class AnimeDetailInteractor {
    weak var output: AnimeDetailInteractorOutput?
    private let networkService: AnimeNetworkServiceProtocol
    private let watchlistService: WatchlistServiceProtocol
    private var currentItem: WatchlistItem?

    init(networkService: AnimeNetworkServiceProtocol, watchlistService: WatchlistServiceProtocol) {
        self.networkService = networkService
        self.watchlistService = watchlistService
    }
}

extension AnimeDetailInteractor: AnimeDetailInteractorInput {
    func loadDetail(id: Int) {
        networkService.fetchAnimeDetail(id: id) { [weak self] result in
            switch result {
            case let .success(item):
                self?.currentItem = WatchlistItem(
                    id: item.malId,
                    title: item.titleEnglish ?? item.title,
                    imageURL: item.images.jpg.largeImageUrl ?? item.images.jpg.imageUrl,
                    score: item.score.map { String(format: "%.1f", $0) } ?? "N/A",
                    genres: item.genres.prefix(2).map { $0.name }.joined(separator: " · ")
                )
                self?.output?.presentDetail(item)
                self?.output?.presentFavoriteStatus(isFavorite: self?.watchlistService.isFavorite(id: item.malId) ?? false)
            case let .failure(error):
                self?.output?.presentError(error.localizedDescription)
            }
        }
    }

    func checkFavoriteStatus(id: Int) {
        output?.presentFavoriteStatus(isFavorite: watchlistService.isFavorite(id: id))
    }

    func toggleFavorite() {
        guard let item = currentItem else { return }
        watchlistService.toggleFavorite(item)
        output?.presentFavoriteStatus(isFavorite: watchlistService.isFavorite(id: item.id))
    }
}
