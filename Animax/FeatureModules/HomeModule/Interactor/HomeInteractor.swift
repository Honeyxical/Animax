final class HomeInteractor {
    weak var output: HomeInteractorOutput?
    private let networkService: AnimeNetworkServiceProtocol

    init(networkService: AnimeNetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension HomeInteractor: HomeInteractorInput {
    func loadContent() {
        output?.presentLoading(true)

        var topAnime: [AnimeItem] = []
        var seasonalAnime: [AnimeItem] = []
        let group = DispatchGroup()

        group.enter()
        networkService.fetchTopAnime { result in
            if case let .success(items) = result { topAnime = items }
            group.leave()
        }

        group.enter()
        networkService.fetchSeasonalAnime { result in
            if case let .success(items) = result { seasonalAnime = items }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.output?.presentLoading(false)
            let sections = self?.buildSections(top: topAnime, seasonal: seasonalAnime) ?? []
            if sections.isEmpty {
                self?.output?.presentError("Failed to load content. Check your connection.")
            } else {
                self?.output?.presentSections(sections)
            }
        }
    }

    func searchAnime(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            loadContent()
            return
        }
        output?.presentLoading(true)
        networkService.searchAnime(query: query) { [weak self] result in
            self?.output?.presentLoading(false)
            switch result {
            case let .success(items):
                let cards = items.map { AnimeCardViewModel(from: $0) }
                let section = HomeSectionViewModel(title: "Search Results", items: cards, style: .cards)
                self?.output?.presentSections([section])
            case let .failure(error):
                self?.output?.presentError(error.localizedDescription)
            }
        }
    }

    private func buildSections(top: [AnimeItem], seasonal: [AnimeItem]) -> [HomeSectionViewModel] {
        var sections: [HomeSectionViewModel] = []
        if !top.isEmpty {
            sections.append(HomeSectionViewModel(
                title: "Top Hits",
                items: top.map { AnimeCardViewModel(from: $0) },
                style: .topHits
            ))
        }
        if !seasonal.isEmpty {
            sections.append(HomeSectionViewModel(
                title: "This Season",
                items: seasonal.map { AnimeCardViewModel(from: $0) },
                style: .cards
            ))
        }
        return sections
    }
}

private extension AnimeCardViewModel {
    init(from item: AnimeItem) {
        id = item.malId
        title = item.titleEnglish ?? item.title
        imageURL = item.images.jpg.largeImageUrl ?? item.images.jpg.imageUrl
        score = item.score.map { String(format: "%.1f", $0) } ?? "N/A"
        genres = item.genres.prefix(2).map { $0.name }.joined(separator: " · ")
    }
}
