//  Created by Илья Беников on 22.11.25.

import UIKit

final class HomeCoordinator: BaseCoordinator {
    private let homeAssembly: HomeAssembly
    private let animeDetailAssembly: AnimeDetailAssembly
    private let favoritesAssembly: FavoritesAssembly
    private let profileAssembly: ProfileAssembly

    var onLogout: (() -> Void)?

    private weak var tabBarController: UITabBarController?

    init(
        homeAssembly: HomeAssembly,
        animeDetailAssembly: AnimeDetailAssembly,
        favoritesAssembly: FavoritesAssembly,
        profileAssembly: ProfileAssembly,
        navigationController: UINavigationController
    ) {
        self.homeAssembly = homeAssembly
        self.animeDetailAssembly = animeDetailAssembly
        self.favoritesAssembly = favoritesAssembly
        self.profileAssembly = profileAssembly
        super.init(navigationController: navigationController)
    }

    override func start(animated: Bool) {
        let tabBar = buildTabBarController()
        self.tabBarController = tabBar
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBar], animated: animated)
    }
}

// MARK: - HomeModuleOutput + Routing

extension HomeCoordinator: HomeModuleOutput, HomeRoutingHandlingProtocol {
    func performRouteToAnimeDetail(id: Int) {
        pushAnimeDetail(id: id)
    }
}

extension HomeCoordinator: FavoritesModuleOutput, FavoritesRoutingHandlingProtocol {
    func performRouteToAnimeDetailFromFavorites(id: Int) {
        pushAnimeDetail(id: id)
    }
}

extension HomeCoordinator: ProfileModuleOutput, ProfileRoutingHandlingProtocol {
    func performLogout() {
        tabBarController = nil
        onLogout?()
    }
}

extension HomeCoordinator: AnimeDetailModuleOutput, AnimeDetailRoutingHandlingProtocol {}

// MARK: - Private

private extension HomeCoordinator {
    func buildTabBarController() -> MainTabBarController {
        let tabBar = MainTabBarController()

        let homeNavController = buildHomeTab()
        let favoritesNavController = buildFavoritesTab()
        let profileNavController = buildProfileTab()

        tabBar.viewControllers = [homeNavController, favoritesNavController, profileNavController]
        return tabBar
    }

    func buildHomeTab() -> UINavigationController {
        let module = homeAssembly.build(moduleOutput: self, routingHandler: self)
        let nav = makeStyledNavController(root: module.view)
        nav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return nav
    }

    func buildFavoritesTab() -> UINavigationController {
        let module = favoritesAssembly.build(moduleOutput: self, routingHandler: self)
        let nav = makeStyledNavController(root: module.view)
        nav.tabBarItem = UITabBarItem(
            title: "Favourites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        return nav
    }

    func buildProfileTab() -> UINavigationController {
        let module = profileAssembly.build(moduleOutput: self, routingHandler: self)
        let nav = makeStyledNavController(root: module.view)
        nav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        return nav
    }

    func makeStyledNavController(root: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.Dark.dark1
        appearance.titleTextAttributes = [
            .foregroundColor: Colors.Others.white,
            .font: Typography.Heading.heading6 as Any
        ]
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.tintColor = Colors.Others.white
        return nav
    }

    func pushAnimeDetail(id: Int) {
        guard let selectedNav = tabBarController?.selectedViewController as? UINavigationController else { return }
        let module = animeDetailAssembly.build(animeId: id, moduleOutput: self, routingHandler: self)
        selectedNav.pushViewController(module.view, animated: true)
    }
}
