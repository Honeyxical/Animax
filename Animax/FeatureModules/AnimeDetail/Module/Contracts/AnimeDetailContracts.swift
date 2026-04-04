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
}

// View Output
protocol AnimeDetailViewOutput {
    func viewDidLoad()
}

// Interactor Input
protocol AnimeDetailInteractorInput {
    func loadDetail(id: Int)
}

// Interactor Output
protocol AnimeDetailInteractorOutput: AnyObject {
    func presentDetail(_ item: AnimeItem)
    func presentError(_ message: String)
}

// Router
protocol AnimeDetailRouterInputProtocol {}

// Routing Handling
protocol AnimeDetailRoutingHandlingProtocol {}

// View Model
struct AnimeDetailViewModel {
    let title: String
    let imageURL: String?
    let score: String
    let type: String
    let episodes: String
    let status: String
    let genres: [String]
    let synopsis: String
    let rating: String
}
