import UIKit

// Module Input
protocol AnimeDetailModuleInput {}

// Module Output
protocol AnimeDetailModuleOutput {}

// View Input
protocol AnimeDetailViewInput: AnyObject {
    func setOutput(_ output: AnimeDetailViewOutput)
    func showDetail(_ viewModel: AnimeDetailViewModel)
    func showLoading(_ isLoading: Bool)
    func showError(_ message: String)
    func showFavoriteStatus(isFavorite: Bool)
}

// View Output
protocol AnimeDetailViewOutput {
    func viewDidLoad()
    func didTapFavorite()
}

// Interactor Input
protocol AnimeDetailInteractorInput {
    func loadDetail(id: Int)
    func checkFavoriteStatus(id: Int)
    func toggleFavorite()
}

// Interactor Output
protocol AnimeDetailInteractorOutput: AnyObject {
    func presentDetail(_ item: AnimeItem)
    func presentError(_ message: String)
    func presentFavoriteStatus(isFavorite: Bool)
}

// Router
protocol AnimeDetailRouterInputProtocol {}

// Routing Handling
protocol AnimeDetailRoutingHandlingProtocol {}

// View Model
struct AnimeDetailViewModel {
    let id: Int
    let title: String
    let imageURL: String?
    let score: String
    let type: String
    let episodes: String
    let episodesCount: Int
    let status: String
    let genres: [String]
    let synopsis: String
    let rating: String
    let year: String
}
