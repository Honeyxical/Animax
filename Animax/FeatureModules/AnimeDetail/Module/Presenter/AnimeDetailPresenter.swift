import UIKit

final class AnimeDetailPresenter: BasePresenter<
    AnimeDetailModuleOutput,
    AnimeDetailInteractorInput,
    AnimeDetailRouterInputProtocol,
    AnimeDetailViewInput
> {
    private let animeId: Int

    init(
        animeId: Int,
        interactor: AnimeDetailInteractorInput,
        router: AnimeDetailRouterInputProtocol,
        view: AnimeDetailViewInput,
        moduleOutput: AnimeDetailModuleOutput?
    ) {
        self.animeId = animeId
        super.init(interactor: interactor, router: router, view: view, moduleOutput: moduleOutput)
    }
}

// MARK: Module Input
extension AnimeDetailPresenter: AnimeDetailModuleInput {}

// MARK: View Output
extension AnimeDetailPresenter: AnimeDetailViewOutput {
    func viewDidLoad() {
        view?.showLoading(true)
        interactor.loadDetail(id: animeId)
    }

    func didTapFavorite() {
        interactor.toggleFavorite()
    }
}

// MARK: Interactor Output
extension AnimeDetailPresenter: AnimeDetailInteractorOutput {
    func presentDetail(_ item: AnimeItem) {
        view?.showLoading(false)
        let viewModel = AnimeDetailViewModel(
            id: item.malId,
            title: item.titleEnglish ?? item.title,
            imageURL: item.images.jpg.largeImageUrl ?? item.images.jpg.imageUrl,
            score: item.score.map { String(format: "%.1f", $0) } ?? "N/A",
            type: item.type ?? "Unknown",
            episodes: item.episodes.map { "\($0) eps" } ?? "Unknown",
            status: item.status ?? "Unknown",
            genres: item.genres.map { $0.name },
            synopsis: item.synopsis ?? "No description available.",
            rating: item.rating ?? "Not rated"
        )
        view?.showDetail(viewModel)
    }

    func presentError(_ message: String) {
        view?.showLoading(false)
        view?.showError(message)
    }

    func presentFavoriteStatus(isFavorite: Bool) {
        view?.showFavoriteStatus(isFavorite: isFavorite)
    }
}
