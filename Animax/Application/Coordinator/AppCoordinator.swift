//  Created by Илья Беников on 12.04.25.

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let launchScreenAssembly: LaunchScreenAssembly
    private let onboardingAssembly: OnboardingAssembly
    private let loginAssembly: LoginAssembly
    private let homeAssembly: HomeAssembly
    private let animeDetailAssembly: AnimeDetailAssembly

    init(
        navigationController: UINavigationController,
        launchScreenAssembly: LaunchScreenAssembly,
        onboardingAssembly: OnboardingAssembly,
        loginAssembly: LoginAssembly,
        homeAssembly: HomeAssembly,
        animeDetailAssembly: AnimeDetailAssembly
    ) {
        self.launchScreenAssembly = launchScreenAssembly
        self.onboardingAssembly = onboardingAssembly
        self.loginAssembly = loginAssembly
        self.homeAssembly = homeAssembly
        self.animeDetailAssembly = animeDetailAssembly
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
        navigationController.pushViewController(module.view, animated: false)
    }
}

// MARK: - Onboarding

extension AppCoordinator: OnboardingModuleOutput, OnboardingRoutingHandlingProtocol {
    func performRouteToLogin() {
        let module = loginAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: true)
    }
}

// MARK: - Login

extension AppCoordinator: LoginModuleOutput, LoginRoutingHandlingProtocol {
    func performRouteToHome() {
        let module = homeAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.setViewControllers([module.view], animated: true)
    }
}

// MARK: - Home

extension AppCoordinator: HomeModuleOutput, HomeRoutingHandlingProtocol {
    func performRouteToAnimeDetail(id: Int) {
        let module = animeDetailAssembly.build(animeId: id, moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: true)
    }
}

// MARK: - AnimeDetail

extension AppCoordinator: AnimeDetailModuleOutput, AnimeDetailRoutingHandlingProtocol {}
