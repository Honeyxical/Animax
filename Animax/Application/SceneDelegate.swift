//  Created by Илья Беников on 21.03.25.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)

        let networkService = AnimeNetworkService()
        let watchlistService = WatchlistService.shared

        let coordinator: CoordinatorProtocol = AppCoordinator(
            homeCoordinatorAssembly: HomeCoordinatorAssembly(
                navigationController: navigationController,
                networkService: networkService,
                watchlistService: watchlistService
            ),
            launchScreenAssembly: LaunchScreenAssembly(),
            onboardingAssembly: OnboardingAssembly(),
            loginAssembly: LoginAssembly(),
            navigationController: navigationController
        )
        coordinator.start(animated: false)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
