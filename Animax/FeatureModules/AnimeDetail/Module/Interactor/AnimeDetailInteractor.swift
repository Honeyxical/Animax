final class AnimeDetailInteractor {
    weak var output: AnimeDetailInteractorOutput?
    private let networkService: AnimeNetworkServiceProtocol

    init(networkService: AnimeNetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension AnimeDetailInteractor: AnimeDetailInteractorInput {
    func loadDetail(id: Int) {
        networkService.fetchAnimeDetail(id: id) { [weak self] result in
            switch result {
            case let .success(item):
                self?.output?.presentDetail(item)
            case let .failure(error):
                self?.output?.presentError(error.localizedDescription)
            }
        }
    }
}
