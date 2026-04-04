//  Created by Илья Беников on 12.04.25.

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let homeCoordinatorAssembly: HomeCoordinatorAssembly
    
    private let launchScreenAssembly: LaunchScreenAssembly
    private let onboardingAssembly: OnboardingAssembly
    
    init(
        homeCoordinatorAssembly: HomeCoordinatorAssembly,
        launchScreenAssembly: LaunchScreenAssembly,
        onboardingAssembly: OnboardingAssembly,
        navigationController: UINavigationController
    ) {
        self.homeCoordinatorAssembly = homeCoordinatorAssembly
        self.launchScreenAssembly = launchScreenAssembly
        self.onboardingAssembly = onboardingAssembly
        
        super.init(navigationController: navigationController)
    }
    
    override func start(animated: Bool) {
        let module = launchScreenAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: false)
    }
}

extension AppCoordinator: LaunchScreenModuleOutput, LaunchScreenRoutingHandlingProtocol {
    func performRouteToOnboarding() {
        let module = onboardingAssembly.build(moduleOutput: self, routingHandler: self)
        navigationController.pushViewController(module.view, animated: false)
    }
}

extension AppCoordinator: OnboardingModuleOutput, OnboardingRoutingHandlingProtocol {
    func prepareForRouteHome() {
        let coordinator = homeCoordinatorAssembly.build()
        addChild(coordinator)
        coordinator.start(animated: false)
    }
}
