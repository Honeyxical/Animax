//  Created by Илья Беников on 22.11.25.

import UIKit

final class HomeCoordinatorAssembly {
    let navigationController: UINavigationController
    private let networkService: AnimeNetworkServiceProtocol
    private let watchlistService: WatchlistServiceProtocol

    init(
        navigationController: UINavigationController,
        networkService: AnimeNetworkServiceProtocol,
        watchlistService: WatchlistServiceProtocol
    ) {
        self.navigationController = navigationController
        self.networkService = networkService
        self.watchlistService = watchlistService
    }

    func build() -> HomeCoordinator {
        HomeCoordinator(
            homeAssembly: HomeAssembly(networkService: networkService),
            animeDetailAssembly: AnimeDetailAssembly(networkService: networkService, watchlistService: watchlistService),
            favoritesAssembly: FavoritesAssembly(watchlistService: watchlistService),
            profileAssembly: ProfileAssembly(watchlistService: watchlistService),
            navigationController: navigationController
        )
    }
}
