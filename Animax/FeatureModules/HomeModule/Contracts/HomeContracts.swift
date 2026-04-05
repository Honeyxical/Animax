//  Created on 22.11.25

import UIKit

// Module Input
protocol HomeModuleInput {}

// Module Output
protocol HomeModuleOutput {}

// View Input
protocol HomeViewInput: AnyObject {
    func setOutput(_ output: HomeViewOutput)
    func showSections(_ sections: [HomeSectionViewModel])
    func showLoading(_ isLoading: Bool)
    func showError(_ message: String)
}

// View Output
protocol HomeViewOutput {
    func viewDidLoad()
    func didSelectAnime(id: Int)
    func didSearchAnime(query: String)
}

// Interactor Input
protocol HomeInteractorInput {
    func loadContent()
    func searchAnime(query: String)
}

// Interactor Output
protocol HomeInteractorOutput: AnyObject {
    func presentSections(_ sections: [HomeSectionViewModel])
    func presentLoading(_ isLoading: Bool)
    func presentError(_ message: String)
}

// Router
protocol HomeRouterInputProtocol {
    func routeToAnimeDetail(id: Int)
}

// Routing Handling
protocol HomeRoutingHandlingProtocol {
    func performRouteToAnimeDetail(id: Int)
}

// View Models

enum HomeSectionStyle {
    case topHits    // horizontal list rows with rank marker (Anime Top Hits design)
    case cards      // horizontal scroll cards (Anime Cards design)
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
}
