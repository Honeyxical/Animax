import UIKit

final class HomePresenter: BasePresenter<
    HomeModuleOutput,
    HomeInteractorInput,
    HomeRouterInputProtocol,
    HomeViewInput
> {}

// MARK: Module Input
extension HomePresenter: HomeModuleInput {}

// MARK: View Output
extension HomePresenter: HomeViewOutput {
    func viewDidLoad() {
        interactor.loadContent()
    }

    func didSelectAnime(id: Int) {
        router.routeToAnimeDetail(id: id)
    }

    func didSearchAnime(query: String) {
        interactor.searchAnime(query: query)
    }

    func didTapSeeAllTopHits(items: [AnimeCardViewModel]) {
        router.routeToTopHits(items: items)
    }

    func didTapSeeAllNewEpisodes(items: [AnimeCardViewModel]) {
        router.routeToNewEpisodes(items: items)
    }

    func didTapSearch() {
        router.routeToSearch()
    }

    func didTapNotifications() {
        router.routeToNotifications()
    }
}

// MARK: Interactor Output
extension HomePresenter: HomeInteractorOutput {
    func presentSections(_ sections: [HomeSectionViewModel]) {
        view?.showSections(sections)
    }

    func presentLoading(_ isLoading: Bool) {
        view?.showLoading(isLoading)
    }

    func presentError(_ message: String) {
        view?.showError(message)
    }
}
