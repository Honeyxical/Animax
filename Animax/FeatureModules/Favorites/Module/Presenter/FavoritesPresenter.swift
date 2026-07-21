import UIKit

final class FavoritesPresenter: BasePresenter<
    FavoritesModuleOutput,
    FavoritesInteractorInput,
    FavoritesRouterInputProtocol,
    FavoritesViewInput
> {}

// MARK: Module Input
extension FavoritesPresenter: FavoritesModuleInput {}

// MARK: View Output
extension FavoritesPresenter: FavoritesViewOutput {
    func viewWillAppear() {
        interactor.loadFavorites()
    }

    func didSelectAnime(id: Int) {
        router.routeToAnimeDetail(id: id)
    }

    func didRemoveFavorite(id: Int, title: String) {
        interactor.removeFavorite(id: id)
    }
}

// MARK: Interactor Output
extension FavoritesPresenter: FavoritesInteractorOutput {
    func presentFavorites(_ items: [WatchlistItem]) {
        if items.isEmpty {
            view?.showEmptyState()
        } else {
            let cards = items.map {
                AnimeCardViewModel(id: $0.id, title: $0.title, imageURL: $0.imageURL, score: $0.score, genres: $0.genres, year: "", episode: nil)
            }
            view?.showFavorites(cards)
        }
    }
}
