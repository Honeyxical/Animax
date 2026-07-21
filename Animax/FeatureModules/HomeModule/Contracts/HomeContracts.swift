import UIKit

protocol HomeModuleInput {}
protocol HomeModuleOutput {}

protocol HomeViewInput: AnyObject {
    func setOutput(_ output: HomeViewOutput)
    func showSections(_ sections: [HomeSectionViewModel])
    func showLoading(_ isLoading: Bool)
    func showError(_ message: String)
}

protocol HomeViewOutput {
    func viewDidLoad()
    func didSelectAnime(id: Int)
    func didSearchAnime(query: String)
    func didTapSeeAllTopHits(items: [AnimeCardViewModel])
    func didTapSeeAllNewEpisodes(items: [AnimeCardViewModel])
    func didTapSearch()
    func didTapNotifications()
}

protocol HomeInteractorInput {
    func loadContent()
    func searchAnime(query: String)
}

protocol HomeInteractorOutput: AnyObject {
    func presentSections(_ sections: [HomeSectionViewModel])
    func presentLoading(_ isLoading: Bool)
    func presentError(_ message: String)
}

protocol HomeRouterInputProtocol {
    func routeToAnimeDetail(id: Int)
    func routeToTopHits(items: [AnimeCardViewModel])
    func routeToNewEpisodes(items: [AnimeCardViewModel])
    func routeToSearch()
    func routeToNotifications()
}

protocol HomeRoutingHandlingProtocol {
    func performRouteToAnimeDetail(id: Int)
    func performRouteToTopHits(items: [AnimeCardViewModel])
    func performRouteToNewEpisodes(items: [AnimeCardViewModel])
    func performRouteToSearch()
    func performRouteToNotifications()
}

enum HomeSectionStyle {
    case hero
    case topHits
    case cards
}

struct HomeSectionViewModel {
    let title: String
    let items: [AnimeCardViewModel]
    let style: HomeSectionStyle
}

struct AnimeCardViewModel {
    let id: Int
    let title: String
    let imageURL: String?
    let score: String
    let genres: String
    let year: String
    let episode: String?
}
