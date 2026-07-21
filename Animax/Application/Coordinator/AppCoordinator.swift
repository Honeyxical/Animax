//  Created by Илья Беников on 12.04.25.

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let homeCoordinatorAssembly: HomeCoordinatorAssembly
    private let launchScreenAssembly: LaunchScreenAssembly
    private let onboardingAssembly: OnboardingAssembly
    private let loginAssembly: LoginAssembly

    init(
        homeCoordinatorAssembly: HomeCoordinatorAssembly,
        launchScreenAssembly: LaunchScreenAssembly,
        onboardingAssembly: OnboardingAssembly,
        loginAssembly: LoginAssembly,
        navigationController: UINavigationController
    ) {
        self.homeCoordinatorAssembly = homeCoordinatorAssembly
        self.launchScreenAssembly = launchScreenAssembly
        self.onboardingAssembly = onboardingAssembly
        self.loginAssembly = loginAssembly
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
    func prepareForRouteHome() {
        let module = loginAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(module.view, animated: true)
    }
}

// MARK: - Login

extension AppCoordinator: LoginModuleOutput, LoginRoutingHandlingProtocol {
    func performRouteToHome() {
        let coordinator = homeCoordinatorAssembly.build()
        addChild(coordinator)
        coordinator.onLogout = { [weak self, weak coordinator] in
            if let coordinator = coordinator {
                self?.removeChild(coordinator)
            }
            self?.showLogin()
        }
        coordinator.start(animated: true)
    }
}

// MARK: - Private

private extension AppCoordinator {
    func showLogin() {
        let module = loginAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.setViewControllers([module.view], animated: true)
    }
}
