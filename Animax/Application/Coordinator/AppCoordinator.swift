//  Created by Илья Беников on 12.04.25.

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let launchScreenAssembly: LaunchScreenAssembly
    private let onboardingAssembly: OnboardingAssembly
    private let loginAssembly: LoginAssembly
    private let homeAssembly: HomeAssembly
    private let animeDetailAssembly: AnimeDetailAssembly
    private let favoritesAssembly: FavoritesAssembly
    private let profileAssembly: ProfileAssembly

    private weak var tabBarController: UITabBarController?

    init(
        navigationController: UINavigationController,
        launchScreenAssembly: LaunchScreenAssembly,
        onboardingAssembly: OnboardingAssembly,
        loginAssembly: LoginAssembly,
        homeAssembly: HomeAssembly,
        animeDetailAssembly: AnimeDetailAssembly,
        favoritesAssembly: FavoritesAssembly,
        profileAssembly: ProfileAssembly
    ) {
        self.launchScreenAssembly = launchScreenAssembly
        self.onboardingAssembly = onboardingAssembly
        self.loginAssembly = loginAssembly
        self.homeAssembly = homeAssembly
        self.animeDetailAssembly = animeDetailAssembly
        self.favoritesAssembly = favoritesAssembly
        self.profileAssembly = profileAssembly
        super.init(navigationController: navigationController)
    }

    override func start(animated: Bool) {
        let module = launchScreenAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: false)
    }
}

// MARK: - LaunchScreen

extension AppCoordinator: LaunchScreenModuleOutput, LaunchScreenRoutingHandlingProtocol {
    func performRouteToOnboarding() {
        let module = onboardingAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(module.view, animated: false)
    }
}

// MARK: - Onboarding

extension AppCoordinator: OnboardingModuleOutput, OnboardingRoutingHandlingProtocol {
    func performRouteToLogin() {
        let module = loginAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(module.view, animated: true)
    }
}

// MARK: - Login

extension AppCoordinator: LoginModuleOutput, LoginRoutingHandlingProtocol {
    func performRouteToHome() {
        let tabBar = buildTabBarController()
        self.tabBarController = tabBar
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBar], animated: true)
    }
}

// MARK: - Home

extension AppCoordinator: HomeModuleOutput, HomeRoutingHandlingProtocol {
    func performRouteToAnimeDetail(id: Int) {
        pushAnimeDetail(id: id)
    }
}

// MARK: - Favorites

extension AppCoordinator: FavoritesModuleOutput, FavoritesRoutingHandlingProtocol {
    func performRouteToAnimeDetailFromFavorites(id: Int) {
        pushAnimeDetail(id: id)
    }
}

// MARK: - Profile

extension AppCoordinator: ProfileModuleOutput, ProfileRoutingHandlingProtocol {
    func performLogout() {
        tabBarController = nil
        let module = onboardingAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([module.view], animated: true)
    }
}

// MARK: - AnimeDetail

extension AppCoordinator: AnimeDetailModuleOutput, AnimeDetailRoutingHandlingProtocol {}

// MARK: - Tab Bar Builder

private extension AppCoordinator {
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
        let navController = makeStyledNavController(root: module.view)
        navController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return navController
    }

    func buildFavoritesTab() -> UINavigationController {
        let module = favoritesAssembly.build(moduleOutput: self, routingHandler: self)
        let navController = makeStyledNavController(root: module.view)
        navController.tabBarItem = UITabBarItem(
            title: "Favourites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        return navController
    }

    func buildProfileTab() -> UINavigationController {
        let module = profileAssembly.build(moduleOutput: self, routingHandler: self)
        let navController = makeStyledNavController(root: module.view)
        navController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        return navController
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
