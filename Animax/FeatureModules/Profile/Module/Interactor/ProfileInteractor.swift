import Foundation

final class ProfileInteractor {
    weak var output: ProfileInteractorOutput?
    private let watchlistService: WatchlistServiceProtocol

    init(watchlistService: WatchlistServiceProtocol) {
        self.watchlistService = watchlistService
    }
}

extension ProfileInteractor: ProfileInteractorInput {
    func loadProfile() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let viewModel = ProfileViewModel(
            name: "Anime Fan",
            email: "fan@animax.app",
            avatarSystemName: "person.circle.fill",
            favoritesCount: watchlistService.favoritesCount(),
            appVersion: version
        )
        output?.presentProfile(viewModel)
    }

    func logout() {
        output?.performLogout()
    }
}
